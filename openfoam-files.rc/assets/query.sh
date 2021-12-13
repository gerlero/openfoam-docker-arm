# --------------------------------*- sh -*-----------------------------------
# File: /openfoam/assets/query.sh
#
# Copyright (C) 2021 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Handle some basic queries related to OpenFOAM installation.
# naming as per etc/openfoam script
#
#  -build-info           Print META-INFO api/patch/build
#  -show-api | -version  Print META-INFO api value and exit
#  -show-patch           Print META-INFO patch value and exit
#  -show-prefix          Print project directory and exit
#
# ------------------------------------------------------------------------

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


getApiInfo()
{
    value="$(sed -ne 's@^'"$1"' *= *\([0-9][0-9]*\).*@\1@p' "$projectDir"/META-INFO/api-info 2>/dev/null)"

    if [ -n "$value" ]
    then
        echo "$value"
    else
        echo "Could not determine OPENFOAM '$1' value" 1>&2
        return 1
    fi
}


# Print meta variables
#
#  - api    : from META-INFO/api-info
#  - patch  : from META-INFO/api-info
#  - build  : from META-INFO/build-info

printMeta()
{
    sed -ne '/^\(api\|patch\)=/p' "$projectDir"/META-INFO/api-info 2>/dev/null
    sed -ne '/^build=/p' "$projectDir"/META-INFO/build-info 2>/dev/null
}


# ---------------------------------------------------------------------------

# Parse for known options
while [ "$#" -gt 0 ]
do
    case "$1" in
    -show-api | -version | --version)  # Show API and exit
        getApiInfo api
        exit $?
        ;;

    -build-info)  # Show META-INFO (api, patch, build)
        printMeta
        exit 0
        ;;

    -show-patch)  # Show API and exit
        getApiInfo patch
        exit $?
        ;;
    -show-prefix)  # Show project directory and exit
        if [ -n "$projectDir" ]
        then
            echo "$projectDir"
            exit 0
        else
            echo "Could not determine OPENFOAM 'prefix' value" 1>&2
            break
        fi
        ;;
    esac
    shift
done

exit 1  # Nothing processed

# ---------------------------------------------------------------------------
