# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/fix-perms.sh
#
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# A post-installation fix permissions on (OpenFOAM container environment)
#
# ------------------------------------------------------------------------

baseDir="$(cd "${0%/*}" && pwd -L)" # path/assets/fix-perms.sh -> path/assets
baseDir="${baseDir%/*}"             # path/assets -> path

if [ -d "$baseDir" ]
then
    echo "# Permissions on $baseDir and entry point(s)" 1>&2
    chmod -R a+rX "$baseDir"

    if [ "$(id -u)" = 0 ]
    then
        chown -R root:root "$baseDir"
    fi

    for script in "$baseDir"/chroot "$baseDir"/run
    do
        [ -f "$script" ] && chmod 0755 "$script"
    done
    exit 0
else
    echo "# No $baseDir directory" 1>&2
    exit 1
fi

# ------------------------------------------------------------------------
