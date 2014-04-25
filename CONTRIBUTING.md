# Quick Guide

We are using [Google's Shell Style Guide](https://google-styleguide.googlecode.com/svn/trunk/shell.xml) with some exceptions:


### Syntax

* use POSIX shell (`#!/bin/sh`). Check [official guide](http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html), [hints from ubuntu team](https://wiki.ubuntu.com/DashAsBinSh), [hints from GreyCat](http://mywiki.wooledge.org/Bashism) and [tricks](http://www.etalabs.net/sh_tricks.html). Unittest.sh should work in: bash, zsh, dash and posh.

* use [shellcheck](http://www.shellcheck.net/) and [checkbashisms](http://sourceforge.net/projects/checkbaskisms/).


### Naming convention

* functions name in format: `ut_<namespace>__<function_name>` (eg. *ut_parser__find_functions*)

* local variable are normal variables (without `local` or `typeset` declaration - POSIX!) but have special names: `ut<hash>__<local_variable_name>` where `<hash>` is first 3 character of sha1 sum of function name (eg. *utac4__message* inside of **ut_msg__error()** function). You can easily generate hash in terminal with command: `echo "function_name" | sha1sum | cut -c -3`
