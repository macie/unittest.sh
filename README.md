# unittest.sh

[![Build Status](https://dl.circleci.com/status-badge/img/gh/macie/unittest.sh/tree/master.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/macie/unittest.sh/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/8af95532e36373322d1c/maintainability)](https://codeclimate.com/github/macie/unittest.sh/maintainability)

Unit testing framework for shell scripts.


## Cheat sheet

* can find test suites: files with names `test_<suite_description>.sh` inside `tests\` directory

* test cases: functions `test_<test_case_description>()`

* assertions: call `test` function (same usage as unix `test` command)

* functions `beforeAll()` and `afterAll()` are run before/after all tests in file

* functions `beforeEach()` and `afterEach()` are run before/after each test (`setUp()` and `tearDown()` are deprecated and will be removed in next version)

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

