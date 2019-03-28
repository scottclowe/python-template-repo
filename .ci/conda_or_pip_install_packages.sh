#!/usr/bin/env bash
#
# conda_or_pip_install_packages
# Define a helper function which installs dependencies from a list in a file,
# which uses conda where it can and pip when it can't.
#
# Inputs
#   Path to file listing package constraints (i.e. a requirements.txt file).
#
# Exit code 0 if success, 1 if fail on any package
#
# Scott C. Lowe <scott.code.lowe@gmail.com>

#==============================================================================
# Input handling
#==============================================================================

# Check number of inputs is correct
if (( $# != 1 )); then
    echo "Wrong number of inputs. Given $#, expected 1.";
    return 1;
fi;

#==============================================================================
# Main
#==============================================================================

# Make sure conda is up-to-date
conda update -q conda

while read PV; do
    echo "";
    echo "==================================================================";
    # First, we remove the version requirement and get just the package name.
    PN="$(echo $PV | sed 's/^\([^!<>=~ ]*\).*/\1/')";

    # Skip entirely commented out lines
    if echo "$PV" | grep -qE '^#';
    then
        continue;
    # Don't even try conda if the line starts with '-e' (editable install)
    # or other parameter (such as '-r', linking to another requirements file)
    # or is a link to a version control system repository ('git+', 'hg+',
    # 'bzr+', 'svn+', or git://)
    # https://pip.pypa.io/en/stable/reference/pip_install/#vcs-support
    elif echo "$PV" | grep -qEv '^-|.*\+.*|.*git://' &&
        # Now we search the conda database to see if a package with
        # this exact (--use-index-cache) name, `$PN`, is present.
        # We already updated our cache, so we don't need to ask the
        # server again (--use-index-cache). The output of this is a
        # header line and then a list of matching package names (--names-only).
        # We can then grep this to check whether one of the lines of the output
        # is an exact match for the name of the package we want to install.
        conda search $PN --full-name --use-index-cache --names-only |
          grep -qFxi $PN;
    then
        # Try and install the package with this version specification from
        # conda
        USEPIP=0;
        echo "Package $PN is on conda. Installing it from there.";
        echo "------------------------------------------------------------------";
        conda install -q "$PV";
        ERRORCODE=$?;
    else
        # We can't use conda, so we will just try pip
        USEPIP=1;
    fi;
    if [[ $ERRORCODE -ne 0 ]] || [[ $USEPIP -gt 0 ]];
    then
        echo "Package $PV isn't on conda. Trying to install it from PyPI.";
        echo "------------------------------------------------------------------";
        # We want an update '-U' install so we have the most recent version of
        # the dependency which is compatible with the specification.
        pip install -U "$PV";
        ERRORCODE=$?;
    fi;
    # If we couldn't install this package, stop and exit with error code 1 now
    if [[ $ERRORCODE -ne 0 ]]; then exit 1; fi;
done < $1;
