# sharpSMT

`[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)`

Framework to Count SMT formulas

## Installation

```shell
git clone git@github.com:meelgroup/sharpSMT.git
git submodule update
```

Make individual systems in folders `modelcounters`, `smtsolvers` and `smtcounters`.

## Usage

```shell
./sharpsmt.sh -s <smtsolver> -c <modelcounter> <smt2 filename>
```

Issue `./sharpsmt.sh -h` to know possible options for `<smtsolver>` and `<modelcounter>`.

