# Quick Guide

We are using [Google's Shell Style Guide](https://google-styleguide.googlecode.com/svn/trunk/shell.xml) with some exceptions:


### Syntax

* use POSIX shell (`#!/bin/sh`). Check [official guide](http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html), [hints from ubuntu team](https://wiki.ubuntu.com/DashAsBinSh), [hints from GreyCat](http://mywiki.wooledge.org/Bashism) and [tricks](http://www.etalabs.net/sh_tricks.html). Unittest.sh should work in: bash, zsh, dash and posh.

* use [shellcheck](http://www.shellcheck.net/) and [checkbashisms](http://sourceforge.net/projects/checkbaskisms/).


### Naming convention

* functions name in format: `ut_<namespace>__<function_name>` (eg. *ut_parser__find_functions*)

* (local) variable names as above: `ut_<namespace>__<local_variable_name>` (eg. *ut_parser__pattern*)
