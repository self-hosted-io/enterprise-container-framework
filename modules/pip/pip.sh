set -eux

python3 -m ensurepip --upgrade --default-pip
python3 -m pip install --upgrade pip==$PYTHON_PIP_VERSION
pip3 install --upgrade pip setuptools