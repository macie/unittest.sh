# unittest.sh

[![Build Status](https://dl.circleci.com/status-badge/img/gh/macie/unittest.sh/tree/master.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/macie/unittest.sh/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/8af95532e36373322d1c/maintainability)](https://codeclimate.com/github/macie/unittest.sh/maintainability)

_Unittest is the standard test runner._

It follows the unix philosophy with a modern touch, so it is:

- easy to use: readable elm-inspired error messages & colorized output (if applicable)
- easy to package: POSIX-compatible & MIT license
- easy to extend: with pipelines & standard unix tools
- easy to replace: tests can be run manually (see: _[Brief theory of shell testing](#brief-theory-of-shell-testing)_).

Its simplicity makes it useful not only for testing shell scripts, but also for black-box testing of commands written
in any language.

## Usage

With basic call, it searches inside `tests\` directory for `test_*.sh` files with `test_*` functions:

```bash
$ unittest.sh
tests/test_asserts.sh:test_assertEqual_equal_ints	PASS
tests/test_asserts.sh:test_assertEqual_unequal_ints	PASS
...
```

Result is reported to stdout. Non-zero exit code indicates, that some tests has failed. To be passed,
each test should exit with 0 code.

In addition to `test_*` functions, you can also define functions named:

- `xtest_*` - will be reported as SKIP (without error)
- `beforeEach` and `afterEach` - test preparation/cleanup code executed before/after each test function
- `beforeAll` and `afterAll` - test preparation/cleanup code executed once per file, before/after all test functions.

Tests can call `test` function, which extends [test](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html)
command with readable error report (to stderr):

```bash
$ unittest.sh
...
tests/test_number_assertions.sh:test_lessequal_mixed2	PASS

-- FAILED TEST [tests/test_output.sh:test_status_pass]

I expected:

    test '0' '-eq' '10'

to be true, but the result was false.

tests/test_output.sh:test_status_pass	FAIL
tests/test_output.sh:test_status_fail	PASS
...
```

For example tests see files inside [tests directory](./tests).

## Install

Using `curl`:
```bash
curl -fLO https://raw.githubusercontent.com/macie/unittest.sh/master/unittest.sh
chmod +x unittest.sh
```

or with `wget`:

```bash
wget https://raw.githubusercontent.com/macie/unittest.sh/master/unittest.sh
chmod +x unittest.sh
```

## Alternatives

Robert Lehmann created list of [the most popular shell testing tools](https://github.com/lehmannro/assert.sh#related-projects).
The main difference between them and this project: _unittest_ is idiomatic to unix. It uses only POSIX commands
and standard output with simple format. So the result can be easily transformed or extended.

The only comparable alternative is to run tests manually (as described below).

### Brief theory of shell testing

From its beginning, unix is test-friendly. The simplest shell test is based on exit codes:

```bash
$ command && echo PASS || echo FAIL
PASS
```

Commands which don't crash by default are quite common. Much useful tests verifies what command do (with
a little help from standard unix tools):

```bash
$ [ -n "$(command)" ] && echo PASS || echo FAIL
PASS
$ command | grep 'expected output' && echo PASS || echo FAIL
PASS
```

Tests for further usage can be wrapped by function inside shell script:

```bash
$ test_command.sh <<EOF
test_run() {
    command
}

test_output() {
    command | grep 'expected output'
}
EOF
```

Exit code of function is the same as exit code of the last command in function, so after sourcing we can use them as before:

```bash
$ . test_command.sh
$ test_output && echo PASS || echo FAIL
PASS
```

Finally, all tests from a file can be run with some `grep` and loop. And this is basically `unittest`.

## Cheat sheet

### Deprecated assertions

These one will be removed in next version. Use `test` instead.

| Name               | Arguments       | Example                       | `test` equivalent of example |
|:------------------:|:---------------:|:-----------------------------:|:----------------------------:|
| assertEqual        | 2 (str or int)  | `assertEqual 1 1`             | `test 1 -eq 1`               |
| assertNotEqual     | 2 (str or int)  | `assertNotEqual "a" "b"`      | `test 'a' != 'b'`            |
| assertTrue         | 1 (str or int)  | `assertTrue 4`                | `test 4`                     |
| assertFalse        | 1 (str or int)  | `assertFalse ""`              | `test ! ''`                  |
| assertRaises       | 1 str and 1 int | `assertRaises function 0`     | `test $? -eq 0`              |
| assertGreater      | 2 (str or int)  | `assertGreater 4 2`           | `test 4 -gt 2`               |
| assertGreaterEqual | 2 (str or int)  | `assertGreaterEqual "ab" "a"` | `test ${#var1} -ge ${#var2}` |
| assertLess         | 2 (str or int)  | `assertLess -2 -1`            | `test -2 -lt -1`             |
| assertLessEqual    | 2 (str or int)  | `assertLessEqual 0 0`         | `test 0 -le 0`               |

