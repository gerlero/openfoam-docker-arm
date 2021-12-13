# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/welcome.sh
#
# Copyright (C) 2020-2021 OpenCFD Ltd.
# Copyright (C) 2021 Gabriel S. Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# General information to display on startup (interactive shell)
#
# ------------------------------------------------------------------------

# Operating system name (may not be apparent for the user)
unset PRETTY_NAME
eval "$(sed -ne '/^PRETTY_NAME=/p' /etc/os-release 2>/dev/null)"

# Admin user
sudo_user=sudofoam
if [ -f /etc/sudoers.d/openfoam ]
then
    grep -q "^${sudo_user}:" /etc/passwd 2>/dev/null || unset sudo_user
else
    unset sudo_user
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


unset foam_api foam_patch foam_build release_notes

if [ -d "$projectDir" ]
then
    # META-INFO: api/patch/build values

    info="$projectDir/META-INFO/api-info"
    eval "$(sed -ne 's/^\(api\|patch\)=/foam_\1=/p' "$info" 2>/dev/null)"

    info="$projectDir/META-INFO/build-info"
    eval "$(sed -ne 's/^\(build\)=/foam_\1=/p' "$info" 2>/dev/null)"

    # Release notes: openfoam-vYYMM
    if [ -n "$foam_api" ]
    then
        release_notes="openfoam-v${foam_api}"
    fi
else
    unset projectDir
fi


# ---------------------------------------------------------------------------
# Output

exec 1>&2
cat<< '__BANNER__'
---------------------------------------------------------------------------
  =========                 |
  \\      /  F ield         | ARM OpenFOAM in a container [from @gerlero]
   \\    /   O peration     |
    \\  /    A nd           | github.com/gerlero/openfoam-docker-arm
     \\/     M anipulation  | www.openfoam.com
---------------------------------------------------------------------------
__BANNER__

cat<< __NOTES__
 Release notes:  https://www.openfoam.com/news/main-news/${release_notes}
 Documentation:  https://www.openfoam.com/documentation/
 Issue Tracker:  https://develop.openfoam.com/Development/openfoam/issues/
 Local Help:     more /openfoam/README
---------------------------------------------------------------------------
System   :  ${PRETTY_NAME:-[]}${sudo_user:+  (admin user: $sudo_user)}
OpenFOAM :  ${projectDir:-[]}
__NOTES__

# Build information - stringify like OpenFOAM output
string="$foam_build"
if [ -n "$foam_api" ]
then
    string="${string}${string:+ }OPENFOAM=${foam_api}"
    [ -n "$foam_patch" ] && string="${string} patch=${foam_patch:-[]}"

    echo "Build    :  $string"
    cat<< '__NOTES__'

Note
    Different OpenFOAM components and modules may be present (or missing)
    on any particular container installation.
    Eg, source code, tutorials, in-situ visualization, paraview plugins,
        external linear-solver interfaces etc.
__NOTES__
fi

cat<< '__FOOTER__'

---------------------------------------------------------------------------
__FOOTER__

# ---------------------------------------------------------------------------
