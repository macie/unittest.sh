# unittest.sh

[![Build Status](https://dl.circleci.com/status-badge/img/gh/macie/unittest.sh/tree/master.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/macie/unittest.sh/tree/master)

Unit testing framework for shell scripts.


## Cheat sheet

### Autodiscovery

* tests inside `tests/` directory with names `test_<something>.sh`

* test function with names `test_<tested_function_name>()`


### Tests Settings

* functions `setUp()` and `tearDown()` before/after test file

* functions `functionSetUp()` and `functionTearDown()` before/after each test function


### Assertions

| Name               | Arguments       | Example                       |
|:------------------:|:---------------:|:-----------------------------:|
| assertEqual        | 2 (str or int)  | `assertEqual 1 1`             |
| assertNotEqual     | 2 (str or int)  | `assertNotEqual "a" "b"`      |
| assertTrue         | 1 (str or int)  | `assertTrue 4`                |
| assertFalse        | 1 (str or int)  | `assertFalse ""`              |
| assertRaises       | 1 str and 1 int | `assertRaises function 0`     |
| assertGreater      | 2 (str or int)  | `assertGreater 4 2`           |
| assertGreaterEqual | 2 (str or int)  | `assertGreaterEqual "ab" "a"` |
| assertLess         | 2 (str or int)  | `assertLess -2 -1`            |
| assertLessEqual    | 2 (str or int)  | `assertLessEqual 0 0`         |
