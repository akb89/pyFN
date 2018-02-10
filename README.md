# pyfn
[![GitHub release][release-image]][release-url]
[![PyPI release][pypi-image]][pypi-url]
[![Build][travis-image]][travis-url]
[![Requirements Status][req-image]][req-url]
[![Code Coverage][coverage-image]][coverage-url]
[![FrameNet][framenet-image]][framenet-url]
[![Python][python-image]][python-url]
[![MIT License][license-image]][license-url]

Welcome to **pyfn**, a Python modules to process FrameNet XML data.

## HowTo
### Convert FrameNet XML splits to BIOS tagging format
Splits directory should follow:
```
.
|-- fndata-1.x
|   |-- train
|   |   |-- fulltext
|   |   |   |-- ABC.xml
|   |   |   |-- DEF.xml
|   |   |   |-- ...
|   |   |-- lu
|   |   |   |-- lu$%*.xml
|   |   |   |-- lu%*$.xml
|   |   |   |-- ...
|   |-- dev
|   |   |-- fulltext
|   |   |   |-- HIJ.xml
|   |   |   |-- KLM.xml
|   |   |   |-- ...
|   |   |-- lu
|   |   |   |-- lu%$*.xml
|   |   |   |-- lu%$*.xml
|   |   |   |-- ...
|   |-- test
|   |   |-- fulltext
|   |   |   |-- NOP.xml
|   |   |   |-- QRS.xml
|   |   |   |-- ...
|   |   |-- lu
|   |   |   |-- lu*$%.xml
|   |   |   |-- lu*%$.xml
|   |   |   |-- ...
```

```bash
pyfn --from fnxml --to bios --source /abs/path/to/fn/splits/dir --target /abs/path/to/bios/splits/dir
```
The script will then generate n-files under the `/abs/path/to/bios/splits/dir` directory, depending on your splits configuration (train, dev, test):
- train.bios
- dev.bios
- test.bios

## PyPI

https://tom-christie.github.io/articles/pypi/

```python
import pypandoc

#converts markdown to reStructured
z = pypandoc.convert('README','rst',format='markdown')

#writes converted file
with open('README.rst','w') as outfile:
    outfile.write(z)
```

[release-image]:https://img.shields.io/github/release/akb89/pyfn.svg?style=flat-square
[release-url]:https://github.com/akb89/pyfn/releases/latest
[pypi-image]:https://img.shields.io/pypi/v/pyfn.svg?style=flat-square
[pypi-url]:https://github.com/akb89/pyfn/releases/latest
[travis-image]:https://img.shields.io/travis/akb89/pyfn.svg?style=flat-square
[travis-url]:https://travis-ci.org/akb89/pyfn
[coverage-image]:https://img.shields.io/coveralls/akb89/pyfn/master.svg?style=flat-square
[coverage-url]:https://coveralls.io/github/akb89/pyfn?branch=master
[framenet-image]:https://img.shields.io/badge/framenet-1.5%E2%87%A1-blue.svg?style=flat-square
[framenet-url]:https://framenet.icsi.berkeley.edu/fndrupal
[python-image]:https://img.shields.io/pypi/pyversions/pyfn.svg?style=flat-square
[python-url]:https://github.com/akb89/pyfn/releases/latest
[license-image]:http://img.shields.io/badge/license-MIT-000000.svg?style=flat-square
[license-url]:LICENSE.txt
[req-url]:https://requires.io/github/akb89/pyfn/requirements/?branch=master
[req-image]:https://img.shields.io/requires/github/akb89/pyfn.svg?style=flat-square
