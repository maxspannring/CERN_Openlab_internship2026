#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

rm -rf venv

#now this will run on ALMA9
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
python3 -m twine upload --verbose --repository gitlab ${wheelfile}

rm -rf venv
