#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
PYVER=`/usr/bin/python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))'`

rm -rf venv

python3.12 -m venv venv

source venv/bin/activate
pip3 install --upgrade pip
pip3 install --upgrade setuptools
pip3 install --upgrade twine
pip3 install --upgrade wheel

rm -rf dist/*.whl
python3 setup_wheel.py bdist_wheel
wheelfile=`ls dist/*.whl -t | head -n 1`
echo "wheel file: ${wheelfile}"
TWINE_PASSWORD=${CI_JOB_TOKEN} TWINE_USERNAME=gitlab-ci-token python3 -m twine upload --verbose --repository gitlab ${wheelfile}


TWINE_PASSWORD="__token__" TWINE_USERNAME=${PYPI_TOKEN} python3 -m twine upload -r pypi --verbose ${wheelfile}

rm -rf venv
