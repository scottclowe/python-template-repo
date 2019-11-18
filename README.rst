|Travis build| |AppVeyor build| |Coveralls report| |Codecov report|

Python Template/Skeleton Repository
===================================

This repository gives a fully-featured template or skeleton for new Python repositories.


Quick start
-----------

When creating a new repository from this skeleton, these are the steps to follow:

#. **Don't click the fork button**

#. If you want to keep the skeleton's commit history in your own history, replacing ``your_repo_name`` with the name of your new repository, run the commands::

      git clone git@github.com:scottclowe/python-template-repo.git your_repo_name
      cd your_repo_name

   Alternatively, if you don't want to keep the skeleton's commit history, instead run the shell commands::

      git init your_repo_name
      cd your_repo_name
      wget https://github.com/scottclowe/python-template-repo/archive/master.zip
      unzip master.zip
      mv -n python-template-repo-master/* python-template-repo-master/.[!.]* .
      rm -r python-template-repo-master/
      rm master.zip
      git add .
      git commit -m "Add skeleton repository"

   Note that we are doing the move with ``-n`` argument, which will prevent the skeleton repository from clobbering your own files (in case you already made a README.rst file, for instance).

   If you find it more convenient, or you are on Windows, you can download and unzip the zip file through the GUI instead.

#. Make a new, empty git repository on GitHub or other web host of your choice.
   Note down the url of the remote, ``your_repo_url``, either in its ``https`` or ``git@...`` form.

#. Instruct your local repository to synchronise with the remote you just made::

      git remote set-url origin your_repo_url
      git push -u origin master

#. Change the LICENSE file to contain `whichever license you wish to release your code under <https://choosealicense.com/>`_.

#. Edit the file ``package_name/__meta__.py`` to contain your author and repo details.

   name
      The name as it will/would be on PyPI (users will do ``pip install new_name_here``).
      It is `recommended <https://www.python.org/dev/peps/pep-0008/>`_ to use a name all lowercase, runtogetherwords but if separators are needed hyphens are preferred over underscores.

   path
      The path to the package. What you will rename the directory ``package_name``.
      `Should be <https://www.python.org/dev/peps/pep-0008/>`_ the same as ``name``, but now hyphens are disallowed and should be swapped for underscores.
      By default, this is automatically inferred from ``name``.

   license
      Should be the name of the license you just picked and put in the LICENSE file.

   Other fields to enter should be self-explanatory.

#. Move the directory ``package_name`` to ``your_new_path``.::

      mv package_name your_new_path

#. Change references to ``package_name`` to ``your_new_path``:

   - In ``setup.py``, L51::

      exec(read('package_name/__meta__.py'), meta)

   - In ``docs/conf.py``, L22::

      from package_name import __meta__ as meta  # noqa: E402

   - In ``.travis.yml``, L240::
   
      - py.test --flake8 --cov=package_name --cov-report term --cov-report xml --cov-config .coveragerc --junitxml=testresults.xml

#. Swap out the contents of ``requirements.txt`` for your project's current requirements.

#. Swap out the contents of ``README.rst`` with an inital description of your project.

#. Remove ``package_name/module.py`` and ``package_name/tests/test_module.py`` (or keep them around as samples, but note that they require numpy), and start writing your own modules and respective tests.

#. Commit and push your changes::

      git commit -am "Initialise project from skeleton repository"
      git push


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

This should work straight away with `readthedocs <https://readthedocs.org/>`_, if you want to host the documentation online there, go ahead.

Alternative themes can be found `concisely from writethedocs <https://www.writethedocs.org/guide/tools/sphinx-themes/>`_, with further options at https://sphinx-themes.org.

Continuous integration
~~~~~~~~~~~~~~~~~~~~~~
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
