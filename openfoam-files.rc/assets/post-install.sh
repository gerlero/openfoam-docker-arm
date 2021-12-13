# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/post-install.sh
#
# Copyright (C) 2020-2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# A post-installation setup adjustment (OpenFOAM container environment)
#
# -fix-perms : execution bits on main directory and entrypoint(s)
# -no-sudo   : disable setup for a sudo user
# ------------------------------------------------------------------------
sudo_user=sudofoam

# Parse options
while [ "$#" -gt 0 ]
do
    case "$1" in
    (-h | -help*)
        echo "No help available" ;;

    (-no-sudo)
        unset sudo_user ;;

    # Correct some permissions (or use fix-perms.sh beforehand)
    (-fix-perms)
        if [ -d /openfoam ]
        then
            echo "# Permissions on /openfoam and entry point(s)" 1>&2
            chmod a+rX /openfoam

            for dir in /openfoam/assets
            do
                [ -d "$dir" ] && chmod -R a+rX "$dir"
            done
            for script in /openfoam/chroot /openfoam/run
            do
                [ -x "$script" ] && chmod 0755 "$script"
            done
        fi
        ;;
    esac
    shift
done

if [ ! -d /openfoam ]
then
    echo "# No /openfoam directory - stopping" 1>&2
    exit 1
fi

echo "# Home directory for container user: /home/openfoam" 1>&2
[ -d "/home/openfoam" ] || mkdir -p /home/openfoam

# ------------------------------------------------------------------------
# Pseudo-admin user 'sudofoam' and a sudoers entry for that user
#
# None of this is particularly secure, but if we wish to grant unlimited
# sudo rights, this is what it takes

if [ -n "$sudo_user" ] && grep -q "^${sudo_user}:" /etc/passwd 2>/dev/null
then
    echo "# User <$sudo_user> already exists - not adding as admin-user" 1>&2
    unset sudo_user
fi

if [ "${sudo_user:-none}" != none ] \
&& command -v sudo >/dev/null \
&& /usr/sbin/useradd \
        --comment "sudo user for openfoam container" \
        --user-group \
        --create-home \
        --shell /bin/bash \
        "${sudo_user}"
then
    echo "# Added user and sudo content for <$sudo_user> admin-user" 1>&2
    if [ -x /usr/bin/passwd ]
    then
        cat<<-__EOF__ | /usr/bin/passwd "${sudo_user}" 2>/dev/null
	foam
	foam
	__EOF__
    fi
    if [ -d /etc/sudoers.d ]
    then
        cat<<-__EOF__ > /etc/sudoers.d/openfoam
	## Admin (sudo) user within openfoam container
	${sudo_user} ALL=(ALL) NOPASSWD:ALL
	## END
	__EOF__
        chmod 0440 /etc/sudoers.d/openfoam
    else
        echo "Warning: no /etc/sudoers.d/ - sudo not installed?" 1>&2
    fi

# This does not seem to work:
#     cat<<-__EOF__ > /usr/bin/sudofoam
# #!/bin/sh
# # Run sudo via the ${sudo_user} user
# /usr/bin/su ${sudo_user} -c "/usr/bin/sudo \$@"
# #--
# __EOF__
#
#     chmod 0755 /usr/bin/sudofoam
else
    echo "# No admin (sudo) account added" 1>&2
fi


# ------------------------------------------------------------------------

# Hooks for interactive bash
if [ -f /etc/bash.bashrc ]
then
    if grep -q -F /etc/bash.bashrc.local /etc/bash.bashrc
    then
        # SuSE: /etc/bash.bashrc.local
        echo "# Update /etc/bash.bashrc.local for openfoam" 1>&2
        cat <<__EOF__ >> /etc/bash.bashrc.local
# OpenFOAM environment
[ -f /openfoam/bash.rc ] && . /openfoam/bash.rc
__EOF__
    chmod 0644 /etc/bash.bashrc.local

    elif grep -q -F /openfoam/bash.rc /etc/bash.bashrc
    then
        echo "# /etc/bash.bashrc already adjusted" 1>&2
    else
        # Debian: /etc/bash.bashrc
        echo "# Update /etc/bash.bashrc for openfoam" 1>&2
        cat <<__EOF__ >> /etc/bash.bashrc

# OpenFOAM environment
[ -f /openfoam/bash.rc ] && . /openfoam/bash.rc
__EOF__
    fi
else
    echo "Warning: no /etc/bash.bashrc or /etc/bash.bashrc.local" 1>&2
fi


# Find the (latest) installed version
unset prefix projectDir
findLatestOpenFOAM()
{
    prefix="$1"
    projectDir="$(/bin/ls -d "$prefix"/openfoam[0-9]* 2>/dev/null | sort -n | tail -1)"
}

if [ -f "/openfoam/META-INFO/api-info" ]
then
    # Installed directly under /openfoam
    unset prefix
    projectDir=/openfoam
else
    findLatestOpenFOAM /openfoam

    # Installed in system locations
    [ -n "$projectDir" ] || findLatestOpenFOAM /usr/lib/openfoam
fi


# Create/update profile

if [ -d "$projectDir" ]
then
    package="${projectDir##*/}"
    echo "# Found openfoam=$package prefix=${prefix:-/}" 1>&2

    # Disposable 'sandbox'
    sandbox="$projectDir/sandbox"

    echo "# Define openfoam sandbox: $sandbox" 1>&2
    mkdir -p -m 1777 "$sandbox"

    # Generate /etc/profile.d/openfoam-99run.sh
    sed -e "s#@PREFIX@#${prefix}#g" \
        -e "s#@PACKAGE@#${package}#g" \
        /openfoam/assets/profile.sh.in > /etc/profile.d/openfoam-99run.sh

else
    echo "Warning: cannot find latest openfoam package" 1>&2
    echo "  /etc/profile.d/openfoam.sh - may require further adjustment" 1>&2

    # Generate /etc/profile.d/openfoam-99run.sh
    cp -f /openfoam/assets/profile.sh.in /etc/profile.d/openfoam-99run.sh
fi


# Set MPI environment

if command -v mpi-selector >/dev/null
then
    # openSUSE uses mpi-selector
    if [ "$(mpi-selector --system --query | wc -l)" -eq 0 ]
    then
    (
        set -- $(mpi-selector --list)
        if [ "$#" -eq 1 ]
        then
            mpi-selector --system --set "$1"
        fi
    )
    fi

    echo "# MPI settings (mpi-selector)" 1>&2
    mpi-selector --query  1>&2
    echo "# ---------------" 1>&2

elif [ -f /etc/redhat-release ]
then

    # RedHat/Fedora generally rely on modules loading, but we may not have them
    # so attempt to reuse prefs.sys-openmpi instead

    prefs=etc/config.sh/prefs.sys-openmpi
    if [ -d "$projectDir" ] && [ -f "$projectDir/$prefs" ]
    then
    (
        . "$projectDir/$prefs"

        echo "# MPI environment ($MPI_ARCH_PATH)" 1>&2
        if [ -d "$MPI_ARCH_PATH" ]
        then

            # Generate /etc/profile.d/openfoam-01openmpi.sh
            sed -e 's#@MPI_ARCH_PATH@#'"${MPI_ARCH_PATH}"'#g' \
                /openfoam/assets/mpivars.sh.in > /etc/profile.d/openfoam-01openmpi.sh
        fi
    )
    fi
fi

# Permissions
for i in /etc/profile.d/openfoam*.sh
do
    if [ -f "$i" ]
    then
        chmod 0644 "$i"
    fi
done


# ---------------------------------------------------------------------------
