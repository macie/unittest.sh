#!/bin/sh
# SPDX-FileCopyrightText: 2025 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT
set -u

xtest_invalid_command() {
    ddsttra
}

test_command() {
    true
}

test_assert() {
    test 1 -eq 1
}
