# Quick Guide

In short: be consistent with existing code.

### Syntax

* indentation: 1 tab (smaller script size than 4 spaces; consistent with
`cat <<-EOF` idiom)
* use POSIX shell syntax. `unittest` meant to be able to run on any
POSIX-compliant system. See more:
    * [official guide](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html),
    * [hints from ubuntu team](https://wiki.ubuntu.com/DashAsBinSh),
    * [hints from GreyCat](http://mywiki.wooledge.org/Bashism)
    * [tricks](http://www.etalabs.net/sh_tricks.html)
    * [shellcheck](http://www.shellcheck.net/)
    * [checkbashisms](http://sourceforge.net/projects/checkbaskisms/)
* functions that don't modify global variables should be defined as subshells
(with body inside `()`),e.g. `some_func() ( ... )`. This simplify variable
lifecycle management
* functions that modify global variables should be defined as curly braces
functions (with body inside `{}`), e.g. `some_func() { ... }`. All variables
defined inside function are global, so they should be unset after use,
e.g. `unset -v ut_somevar`

### Naming convention

* function names are lowercase with **unittest__** prefix,
e.g. `unittest__print_result`
* global variable names are uppercase with **UT_** prefix, e.g. `UT_VERSION`
* local variable names inside curly braces functions are lowercase with **ut_**
prefix,  e.g. `ut_i`
