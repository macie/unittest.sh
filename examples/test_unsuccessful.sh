#!/bin/sh
# SPDX-FileCopyrightText: 2025 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT
set -u

test_assert() {
	true
	test $? -eq 1
}
