|GHA tests| |Travis build| |AppVeyor build| |Coveralls report| |Codecov report| |pre-commit| |black|

Python Template/Skeleton Repository
===================================

This repository gives a fully-featured template or skeleton for new Python repositories.


Quick start
-----------

When creating a new repository from this skeleton, these are the steps to follow:

#. **Don't click the fork button**

#.
    #.  You can create a new repository on GitHub from this template by clicking the `Use this template <https://github.com/scottclowe/python-template-repo/generate>`_ button.

    #.  Alternatively, if your new repository is not going to be on GitHub, you can `download this repo as a zip <https://github.com/scottclowe/python-template-repo/archive/master.zip>`_ and work from there.
        However, you should note that this zip does not include the .gitignore and .gitattributes files (because GitHub automatically ommits them, which use usually helpful but is not for our purposes).
        Thus you will also need to download the `.gitignore <https://raw.githubusercontent.com/scottclowe/python-template-repo/master/.gitignore>`__ and `.gitattributes <https://raw.githubusercontent.com/scottclowe/python-template-repo/master/.gitattributes>`_ files.

        The following shell commands can be used for this purpose on \*nix systems::

          git init your_repo_name
          cd your_repo_name
          wget https://github.com/scottclowe/python-template-repo/archive/master.zip
          unzip master.zip
          mv -n python-template-repo-master/* python-template-repo-master/.[!.]* .
          rm -r python-template-repo-master/
          rm master.zip
          wget https://raw.githubusercontent.com/scottclowe/python-template-repo/master/.gitignore
          wget https://raw.githubusercontent.com/scottclowe/python-template-repo/master/.gitattributes
          git add .
          git commit -m "Initial commit"
          git rm LICENSE

        Note that we are doing the move with ``-n`` argument, which will prevent the template repository from clobbering your own files (in case you already made a README.rst file, for instance).

        You'll need to instruct your new local repository to synchronise with the remote ``your_repo_url``::

          git remote set-url origin your_repo_url
          git push -u origin master

#.  Remove the dummy files ``package_name/module.py`` and ``package_name/tests/test_module.py``::

        rm package_name/module.py
        rm package_name/tests/test_module.py

    If you prefer, you can keep them around as samples, but should note that they require numpy.

#.  Depending on your needs, some of the files may be superflous to you.
    You can remove any superflous files, as follows.

    - *Yes to pre-commit!* You can delete the lint GitHub Action, as it is superfluous with the lint checks which are also in pre-commit::

        rm -f .github/workflows/lint.yml

    - *No pre-commit!* Delete these files::

        rm -f .pre-commit-config.yaml
        rm -f .github/workflows/pre-commit.yml
        sed -i '/^pre-commit/d' requirements-dev.txt

    - *No Python 2.7 support!* Delete these items from the unit testing CI::

        sed -i 's/"2\.7", //' .github/workflows/test.yml
        sed -i '/- "2\.7"/d' .travis.yml
        sed -i '29,36d' .appveyor.yml
        sed -i '16,23d' .appveyor.yml

    - *No GitHub Actions!* Delete this directory::

        rm -r .github/

    - *No unit testing!* Delete these files::

        rm -rf .ci/
        rm -rf package_name/tests/
        rm -f .github/workflows/test.yml
        rm -f .appveyor.yml
        rm -f .coveragerc
        rm -f .travis.yml
        rm -f requirements-test.txt

    - *No Travis!* Delete this file::

        rm -f .travis.yml

    - *No Appveyor!* Delete these files::

        rm -rf .ci/appveyor/
        rm -f .appveyor.yml

    - *No Documentation!* Delete these files and lines::

        rm -rf docs/
        sed -i '70,74d' .github/workflows/test.yml

#.  Delete the LICENSE file and replace it with a LICENSE file of your own choosing.
    If the code is intended to be freely available for anyone to use, use an `open source license <https://choosealicense.com/>`__, such as `MIT License <https://choosealicense.com/licenses/mit/>`__ or `GPLv3 <https://choosealicense.com/licenses/gpl-3.0/>`__.
    If you don't want your code to be used by anyone else, add a LICENSE file which just says

        Copyright (c) YEAR, YOUR NAME

        All right reserved.

    Note that if you don't include a LICENSE file, you will still have copyright over your own code (this copyright is automatically granted), and your code will be private source (technically nobody else will be permitted to use it, even if you make your code publicly available).

#.  Edit the file ``package_name/__meta__.py`` to contain your author and repo details.

    name
          The name as it will/would be on PyPI (users will do ``pip install new_name_here``).
          It is `recommended <https://www.python.org/dev/peps/pep-0008/>`__ to use a name all lowercase, runtogetherwords but if separators are needed hyphens are preferred over underscores.

    path
        The path to the package. What you will rename the directory ``package_name``.
        `Should be <https://www.python.org/dev/peps/pep-0008/>`__ the same as ``name``, but now hyphens are disallowed and should be swapped for underscores.
        By default, this is automatically inferred from ``name``.

    license
        Should be the name of the license you just picked and put in the LICENSE file (e.g. ``MIT`` or ``GPLv3``).

    Other fields to enter should be self-explanatory.

#. Rename the directory ``package_name`` to be the ``path`` variable you just added to ``__meta__.py``.::

      PACKAGE_NAME=your_actual_package_name
      mv package_name "$PACKAGE_NAME"

#.  Change references to ``package_name`` to your path variable:

    This can be done with the command::

        PACKAGE_NAME=your_actual_package_name
        sed -i "s/package_name/$PACKAGE_NAME/" setup.py \
            docs/conf.py docs/index.rst \
            .github/workflows/test.yml .travis.yml .appveyor.yml

    Which will make changes in the following places.

    - In ``setup.py``, L69::

        exec(read('package_name/__meta__.py'), meta)

    - In ``docs/conf.py``, L23::

        from package_name import __meta__ as meta  # noqa: E402

    - In ``.github/workflows/test.yml``, L62::

        python -m pytest --cov=package_name --cov-report term --cov-report xml --cov-config .coveragerc --junitxml=testresults.xml

    - In ``.travis.yml``, L244::

        - py.test --flake8 --cov=package_name --cov-report term --cov-report xml --cov-config .coveragerc --junitxml=testresults.xml

    - In ``.appveyor.yml``, L213::

        - "%CMD_IN_ENV% python -m pytest --cov=package_name --cov-report term --cov-report xml --cov-config .coveragerc --junitxml=testresults.xml"

#.  Swap out the contents of ``requirements.txt`` for your project's current requirements.
    If you don't have any requirements yet, delete the contents of ``requirements.txt``.

#.  Swap out the contents of ``README.rst`` with an inital description of your project.
    If you are keeping all the badges, make sure to change the URLs from ``scottclowe/python-template-repo`` to ``your_username/your_repo``.
    If you prefer, you can use markdown instead of rST.

#.  Commit and push your changes::

      git commit -am "Initialise project from template repository"
      git push


Features
--------

The template repository comes with a `pre-commit <https://pre-commit.com/>`__ stack.
This is a set of git hooks which are executed everytime you make a commit.
The hooks catch errors as they occur, and will automatically fix some of these errors.

To set up the pre-commit hook, run the following code::

    pip install -r requirements-dev.txt
    pre-commit install

Whenever you try to commit code which needs to be modified by the commit hook, you'll have to add the commit hooks changes and then redo your commit.

You can also manually run the pre-commit stack on all the files at any time::

    pre-commit run --all-files

The pre-commit stack will run the following operations:

- Change the code style to be `black <https://github.com/psf/black>`__.
  Any code `inside docstrings <https://github.com/asottile/blacken-docs>`__ will also be formatted.

- Imports are automatically sorted using `isort <https://github.com/timothycrosley/isort>`__.

- `flake8 <https://gitlab.com/pycqa/flake8>`__ is run to check for conformity to the python style guide `PEP8 <https://www.python.org/dev/peps/pep-0008/>`__, along with several other formatting issues.

- `setup-cfg-fmt <https://github.com/asottile/setup-cfg-fmt>`__ is used to format any setup.cfg files.

- Several `hooks from pre-commit <https://github.com/pre-commit/pre-commit-hooks>`__ are used to screen for non-language specific git issues, such as bugged JSON and YAML files, and overly large files.
  JSON files are also prettified automatically to have standardised indentation.

- Several `hooks from pre-commit specific to python <https://github.com/pre-commit/pygrep-hooks>`__ are used to screen for rST formatting issues, and ensure noqa flags always specify an error code to ignore.

Once it is set up, the pre-commit stack will run locally on every commit.
The pre-commit stack will also run on github with one of the action workflows, which ensures overall conformity to a common code style.


Contents
--------

Dummy package
~~~~~~~~~~~~~
The directory ``package_name`` contains a dummy package, with a single module ``module.py``.

__meta__.py
"""""""""""
The file ``package_name/__meta__.py`` contains all the metadata for the package and allows us to do single-sourcing for nearly all of these details.
You only have to write the metadata once in this centralised location, and everything else picks it up from there.

__init__.py
"""""""""""
The file ``package_name/__init__.py`` imports the metadata from ``__meta__.py``, so it is available with::

   import package_name
   print(package_name.__meta__)

We also expose the version number from within the metadata directly available as a ``__version__`` attribute::

   import package_name
   print(package_name.__version__)

Unit tests
~~~~~~~~~~
The file ``package_name/tests/base_test.py`` provides a class for unit testing which provides easy access to all the numpy testing in one place (so you don't need to import a stack of testing functions in every test file, just import the ``BaseTestClass`` instead).

There is also support for ``unittest`` on Python 2.6 (via ``unittest2``), in case you still need to support it.

setup.py
~~~~~~~~
The template setup.py file is based on the `example from setuptools documentation <https://setuptools.readthedocs.io/en/latest/setuptools.html#basic-use>`_, and the comprehensive example from `Kenneth Reitz <https://github.com/kennethreitz/setup.py>`_ (released under `MIT License <https://github.com/kennethreitz/setup.py/blob/master/LICENSE>`_).

Documentation building
~~~~~~~~~~~~~~~~~~~~~~
The `sphinx <https://www.sphinx-doc.org/>`_ configuration file ``docs/conf.py`` is set up to work well out of the box.

- `autodoc <http://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html>`_ is enabled, and will generate an API description based on the docstrings in your code.

- `Napoleon <https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html>`_ is enabled, so you can write docstrings in plain `reST <http://docutils.sourceforge.net/rst.html>`_, or use `Google format <https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html#example-google>`_ or `Numpy format <https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_numpy.html#example-numpy-style-python-docstrings>`_.

- `Intersphinx <http://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html>`_ mappings are enabled for some common packages, so if your docstrings refer to classes or functions from them these references should become links to the appropriate documentation.

You can build the documentation with::

   make -C docs html

And view the documentation like so::

   sensible-browser docs/_build/html/index.html

This should work straight away with `readthedocs <https://readthedocs.org/>`_.
If you want to host the documentation online there, go ahead.

Alternative themes can be found `concisely from writethedocs <https://www.writethedocs.org/guide/tools/sphinx-themes/>`_, with further options at https://sphinx-themes.org.

.github Workflow
~~~~~~~~~~~~~~~~

Three workflows are included by default

- lint
- pre-commit
- test

Both the lint and pre-commit workflows check for code style and formatting.
If you are using the pre-commit hooks, the lint workflow is superfluous and can be deleted.

The test workflow runs the unit tests.

Other Continuous integration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The file ``.travis.yml`` provides configuration for continuous integration *both* on `Travis CI <https://travis-ci.org/>`_  (`documentation <https://docs.travis-ci.com/user/languages/python/>`_) and on `Shippable <https://shippable.com>`_ (`documentation <http://docs.shippable.com/ci/python-template-repo>`_)
Note that Shippable has an API aligned with Travis and `operates from <https://docs.platformio.org/en/latest/ci/shippable.html>`_ the ``.travis.yml`` if there is no ``shippable.yml`` configuration file.

Alternative continuous integration services are also available:

- Travis has a `free CI plan <https://travis-ci.com/plans>`_ for open source projects.

- Shippable offers a `limited free service for both open and private projects <http://docs.shippable.com/getting-started/billing-overview/>`_.

- `Circle CI <https://circleci.com>`_ (notes on `converting <https://circleci.com/docs/2.0/migrating-from-travis/>`_ from ``.travis.yml``) is another option with a limited `free option <https://circleci.com/pricing/#build-linux>`_.

- `Appveyor <https://www.appveyor.com>`_ is particularly useful, as it provides a Windows-based test suite and can be used to `build Windows wheel files to submit to PyPI <https://github.com/ogrisel/python-appveyor-demo>`_.

- `Jenkins <https://jenkins.io/>`_ is useful if you want to run your CI test suite locally or on your own private server instead of in the cloud.

Our ``.travis.yml`` file is configured to run `flake8 <http://flake8.pycqa.org>`_ as part of the tests.
If you prefer to split the unit tests from code style, automated code style review can alternatively be performed with `Stickler <https://stickler-ci.com>`_ (free for open source) instead.

As part of the CI test suite, the documentation will also be generated, so tests will fail if there is a problem with the documentation generation.

Also, we include the option to test the dependencies at their *oldest* version, in addition to the newest version (which is the default and is normally run).
This is done by setting all entries in ``requirements*.txt`` which are ``>=x.y.z`` to be ``~=x.y.z``.
This option is enabled by setting the environment variable ``USE_OLDEST_DEPENDENCIES=false``.
By default, jobs are spawned both with ``USE_OLDEST_DEPENDENCIES=false`` and ``USE_OLDEST_DEPENDENCIES=true``, for each Python version.

For scientific packages, installing numpy and scipy through pip can be much slower than installing them through conda.
Consequently, we use a miniconda environment and conda-install numpy and scipy before pip-installing the other packages.
To set other packages to prefer conda over pip, add them to the space-delimited variable ``PACKAGES_TO_CONDA``.

Coverage
~~~~~~~~
The configuration file ``.coveragerc`` will ensure the coverage report ignores the test directory.

Coverage can also be continuously tracked with cloud services which are free for private repositories.
Our ``.travis.yml`` file is configured to push coverage to `CodeCov <https://codecov.io/>`_ and `Coveralls <https://coveralls.io/>`_.

One can also get continuous integration for code quality review:

- `Codacy <https://www.codacy.com/>`_ (free for open source).
- `CodeBeat <https://codebeat.co/>`_ (free for open source).
- `SonarCloud <https://sonarcloud.io/>`_ (free for open source); `SonarQube <https://www.sonarqube.org/>`_ as a cloud service.
- `Scrutinizer <https://scrutinizer-ci.com/>`_ (free for open source).
- `GitPrime <https://www.gitprime.com/>`_ (free for open source).
- `Code Climate <https://codeclimate.com/>`_ (no free option).

.gitignore
~~~~~~~~~~
The template .gitignore file is based on the GitHub defaults found `here <https://github.com/github/gitignore>`_.
It is essentially the default `Python gitignore <https://github.com/github/gitignore/blob/master/Python.gitignore>`_, `Windows gitignore <https://github.com/github/gitignore/blob/master/Global/Windows.gitignore>`_, `Linux gitignore <https://github.com/github/gitignore/blob/master/Global/Linux.gitignore>`_, and `Mac OSX gitignore <https://github.com/github/gitignore/blob/master/Global/macOS.gitignore>`_ concatenated together.
(Released under `CC0-1.0 <https://github.com/github/gitignore/blob/master/LICENSE>`_.)

.gitattributes
~~~~~~~~~~~~~~
The template .gitattributes file is based on the defaults from Alexander Karatarakis found `here <https://github.com/alexkaratarakis/gitattributes>`_.
It is essentially the default `Common gitattributes <https://github.com/alexkaratarakis/gitattributes/blob/master/Common.gitattributes>`_ and `Python gitattributes <https://github.com/alexkaratarakis/gitattributes/blob/master/Python.gitattributes>`_ concatenated together.
(Released under `MIT License <https://github.com/alexkaratarakis/gitattributes/blob/master/LICENSE.md>`_.)


Contributing
------------

Contributions are welcome! If you can see a way to improve this skeleton:

- Do click the fork button
- Make your changes and make a pull request.

Or to report a bug or request something new, make an issue.


.. |GHA tests| image:: https://github.com/scottclowe/python-template-repo/workflows/tests/badge.svg
   :target: https://github.com/scottclowe/python-template-repo/actions?query=workflow%3Atests
.. |Travis build| image:: https://travis-ci.org/scottclowe/python-template-repo.svg?branch=master
   :target: https://travis-ci.org/scottclowe/python-template-repo
.. |Shippable build| image:: https://img.shields.io/shippable/5674d4821895ca447466a204/master.svg?label=shippable
   :target: https://app.shippable.com/projects/5674d4821895ca447466a204
.. |AppVeyor build| image:: https://ci.appveyor.com/api/projects/status/3r2wmghdv5vvcta4/branch/master?svg=true
   :target: https://ci.appveyor.com/project/scottclowe/python-template-repo/branch/master
.. |Coveralls report| image:: https://coveralls.io/repos/scottclowe/python-template-repo/badge.svg?branch=master&service=github
   :target: https://coveralls.io/github/scottclowe/python-template-repo?branch=master
.. |Codecov report| image:: https://codecov.io/github/scottclowe/python-template-repo/coverage.svg?branch=master
   :target: https://codecov.io/github/scottclowe/python-template-repo?branch=master
.. |pre-commit| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit
.. |black| image:: https://img.shields.io/badge/code%20style-black-000000.svg
   :target: https://github.com/psf/black
