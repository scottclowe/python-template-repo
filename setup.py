#!/usr/bin/env python


import os

from distutils.core import setup
from setuptools.command.test import test as TestCommand


def read(fname):
    with open(os.path.join(os.path.dirname(__file__), fname)) as f:
        return f.read()

install_requires = read('requirements.txt')

extras_require = {}

# Dev dependencies
extras_require['dev'] = read('requirements-dev.txt')

# Everything
extras_require['all'] = (
    + extras_require['dev']
)


# Can't import __meta__.py if the requirements aren't installed
# due to imports in __init__.py. This is a workaround.
meta = {}
exec(read('package_name/__meta__.py'), meta)


class PyTest(TestCommand):

    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        import pytest
        pytest.main(self.test_args)


setup(
    # Essential details on the package and its dependencies
    name = meta['name'],
    version = meta['version'],
    packages = [meta['name']],
    package_dir = {meta['name']: os.path.join(".", meta['path'])},
    install_requires = install_requires,
    extras_require = extras_require,

    # Metadata to display on PyPI
    author = meta['author'],
    author_email = meta['author_email'],
    description = meta['description'],
    long_description = read('README.rst'),
    license = "MIT",
    url = meta['url'],
    classifiers = [
        "Natural Language :: English",
        "Programming Language :: Python",
    ],
    # Could also include keywords, download_url, project_urls, etc.

    # Custom commands
    cmdclass = {'test': PyTest},
)
