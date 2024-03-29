import sys
if sys.version_info[:2] < (3, 5):
    msg = [
        "This version of cocotb requires at least Python 3.5,",
        "you are running Python %d.%d.%d." % (
            sys.version_info[0], sys.version_info[1], sys.version_info[2])
    ]
    if sys.version_info[0] == 2:
        msg += [
            "If you have Python 3 installed on your machine try ",
            "using 'python3 -m pip' instead of 'pip' to install cocotb."
        ]
    msg += [
        "For more information please refer to the documentation at ",
        "https://cocotb.readthedocs.io."
    ]

    raise SystemExit("\n".join(msg))

import logging
from setuptools import setup
from setuptools import find_packages
from os import path, walk
from io import StringIO

# Note: cocotb is not installed properly yet and is missing dependencies and binaries
# We can still import other files next to setup.py, as long as they're in MANIFEST.in
# The below line is necessary for PEP517 support
sys.path.append(path.dirname(__file__))
from cocotb_build_libs import get_ext, build_ext


def read_file(fname):
    with open(path.join(path.dirname(__file__), fname), encoding='utf8') as f:
        return f.read()


def package_files(directory):
    paths = []
    for (fpath, directories, filenames) in walk(directory):
        for filename in filenames:
            paths.append(path.join('..', fpath, filename))
    return paths


# store log from build_libs and display at the end in verbose mode
# see https://github.com/pypa/pip/issues/6634
log_stream = StringIO()
handler = logging.StreamHandler(log_stream)
log = logging.getLogger("cocotb._build_libs")
log.setLevel(logging.INFO)
log.addHandler(handler)

setup(
    name='cocotb',
    cmdclass={'build_ext': build_ext},
    use_scm_version=dict(
        write_to='cocotb/_version.py',
        write_to_template='__version__ = {version!r}',
        version_scheme='release-branch-semver'
    ),
    description='cocotb is a coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python.',
    url='https://docs.cocotb.org',
    license='BSD',
    long_description=read_file('README.md'),
    long_description_content_type='text/markdown',
    author='Chris Higgs, Stuart Hodgson',
    maintainer='cocotb contributors',
    maintainer_email='cocotb@lists.librecores.org',
    setup_requires=['setuptools_scm'],
    install_requires=['cocotb-bus<1.0'],
    python_requires='>=3.5',
    packages=find_packages(),
    package_data={
        'cocotb': (
            package_files('cocotb/share/makefiles') +   # noqa: W504
            package_files('cocotb/share/include') +     # noqa: W504
            package_files('cocotb/share/def') +         # noqa: W504
            package_files('cocotb/share/lib/verilator')
        )
    },
    ext_modules=get_ext(),
    entry_points={
        'console_scripts': [
            'cocotb-config=cocotb.config:main',
        ]
    },
    platforms='any',
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "License :: OSI Approved :: BSD License",
        "Topic :: Scientific/Engineering :: Electronic Design Automation (EDA)",
    ],

    # these appear in the sidebar on PyPI
    project_urls={
        "Bug Tracker": "https://github.com/cocotb/cocotb/issues",
        "Source Code": "https://github.com/cocotb/cocotb",
        "Documentation": "https://docs.cocotb.org",
    },

    extras_require={
        "bus": ["cocotb_bus"]
    }
)

print(log_stream.getvalue())
