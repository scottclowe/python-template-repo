#!/usr/bin/env bash
#
# conda_min_version
# Helps you get the conda numpy version number you are after.
#
# Inputs
#   - Requirement specification (e.g. 'numpy>=1.6.2').
#   - Python version (e.g. '3.4'). Optional.
#   - Reversal flag (either '' or '-r' to reverse).
# Outputs
#   - Minimal version number of the package which is available on conda and
#     satisfies the version requirement constraint and Python version number.
#     If there is no constraint on the package version number, the lowest
#     version available is outputted.
#     If no Python version is given, the output is the lowest version number
#     across all Python versions.
#     If the reversal flag is given, the maximal version number is returned
#     instead.
#
# Exit code 1 if no output produced.
#
# Scott C. Lowe <scott.code.lowe@gmail.com>

#==============================================================================
# Input handling
#==============================================================================

if (( $# < 1 )) || (( $# > 3 )); then
    echo "Wrong number of inputs. Given $#, expected 1-3.";
    return 1;
fi;

REQUIREMENT_SPEC=$1;
PYTHON_VERSION=$2;
REVERSAL_FLAG=$3;

read -r PACKAGE_NAME VERSION_SIGN VERSION_NUMBER <<< \
    $(echo "$REQUIREMENT_SPEC" | \
        sed 's%^\([^!<>=~]*\)\([!<>=~ ]*\)\(.*\)%\1\n\2\n\3%');

# Example:
# REQUIREMENT_SPEC="numpy>=1.6.2"
# PYTHON_VERSION="3.4"
# PACKAGE_NAME="numpy"
# VERSION_SIGN=">="
# VERSION_NUMBER="1.6.2"

#==============================================================================
# Subfunctions
#==============================================================================
# -----------------------------------------------------------------------------
# conda_package_versions
# Get a list of versions of a package available on conda.
# Inputs
#   Package name (e.g. numpy).
#   Python version (e.g. 3.5). Optional.
# Outputs
#   List of versions of this package for this python version.
function conda_package_versions {
    conda search --canonical -f --use-index-cache "$1" | \
        sed -n "s/^$1-\([^-]*\)-.*py${2/./}.*/\1/p" | \
        sort -Vu;
}
# -----------------------------------------------------------------------------
# version_lt
# Test whether one version string is less than another.
# Inputs
#   First version string (e.g. 1.0.1).
#   Second version string (e.g. 2.4.13).
# Exit code 0 if true, 1 if false.
function version_lt {
    [ $(echo -e "$1\n$2" | sort -V | head -1) != "$2" ];
}
# -----------------------------------------------------------------------------
# version_cmp
# Inputs
#   First version string (e.g. 1.0.1).
#   Constraint (one of '<', '<=', '==', '=', '!=', '>=', '>' or one of
#     '-lt', '-le', '-eq', '-ne', '-ge', 'gt').
#   Second version string (e.g. 2.4.13).
# Exit code 0 if true, 1 if false.
function version_cmp {
    if [ "$2" == "<" ] || [ "$2" == "-lt" ]; then
        version_lt "$1" "$3"; return;
    elif [ "$2" == "<=" ] || [ "$2" == "-le" ]; then
        ! version_lt "$3" "$1"; return;
    elif [ "$2" == "==" ] || [ "$2" == "=" ] || [ "$2" == "-eq" ]; then
        [[ "$1" == "$3" ]]; return;
    elif [ "$2" == "!=" ] || [ "$2" == "-ne" ]; then
        [[ "$1" != "$3" ]]; return;
    elif [ "$2" == ">=" ] || [ "$2" == "-ge" ]; then
        ! version_lt "$1" "$3"; return;
    elif [ "$2" == ">" ] || [ "$2" == "-gt" ]; then
        version_lt "$3" "$1"; return;
    else
        echo "Bad comparison flag input";
        return 2;
    fi;
}
# -----------------------------------------------------------------------------
# constrain_stream
# Inputs
#   Text stream
#   Criteria (pre)
#   Criteria (post)
# Output
#   Text stream containing only lines which pass the criteria
function constrain_stream {
    for LINE in $1; do
        if "$2 $LINE $3"; then
            echo "$LINE";
        fi;
    done;
}
# -----------------------------------------------------------------------------

#==============================================================================
# Main
#==============================================================================

# Get the list of versions of this package satisfying the python version of
# interest
VERSIONS=$(conda_package_versions "$PACKAGE_NAME" "$PYTHON_VERSION");
#
if [[ "$VERSION_NUMBER" == "" ]]; then
    echo "$VERSIONS" | head -1;
    exit;
fi;

# Reverse the list of versions, so we will take the highest that satisfies the
# criteria instead of the lowest
if [[ "$REVERSAL_FLAG" == "-r" ]]; then
    VERSIONS="$(echo "$VERSIONS" | tac)";
fi

# Find the first value satisfying the criteria
for LINE in $(echo "$VERSIONS"); do
#    echo "This line is *$LINE*"; # debug
    # Test this line
    if version_cmp "$LINE" "$VERSION_SIGN" "$VERSION_NUMBER"; then
        # If it is good, echo it and exit
        echo "$LINE";
        exit 0;
    fi;
done;

# If we didn't exist the loop, we didn't find a valid version number which
# satisfies the criteria, and this is an error.
exit 1;
