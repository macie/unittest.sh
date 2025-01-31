#!/bin/sh
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

# shellcheck disable=SC2030,SC2031

#
# PRINT LOCATION
#

test_status_pass() {
    result=$(unittest__print_result 'test location' 'PASS')

    test $? -eq 0 && test "${result}" = 'test location	PASS'
}

test_status_pass_color() {
    result=$(export CLICOLOR_FORCE=1; unittest__print_result 'Location' 'PASS' | awk '/\033/')

    test $? -eq 0 && test -n "${result}"
}

test_status_pass_nocolor() {
    result=$(export CLICOLOR_FORCE=0; unittest__print_result 'Location' 'PASS' | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

test_status_pass_nocolor_empty() {
    result=$(export CLICOLOR_FORCE=; unittest__print_result 'Location' 'PASS' | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

test_status_fail() {
    result=$(unittest__print_result 'failed test location' 'FAIL')

    test $? -eq 0 && test "${result}" = 'failed test location	FAIL'
}

test_status_fail_color() {
    result=$(export CLICOLOR_FORCE=1; unittest__print_result 'Location' 'FAIL' | awk '/\033/')

    test $? -eq 0 && test -n "${result}"
}

test_status_fail_nocolor() {
    result=$(export CLICOLOR_FORCE=0; unittest__print_result 'Location' 'FAIL' | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

test_status_skip() {
    result=$(unittest__print_result 'skipped test location' 'SKIP')

    test $? -eq 0 && test "${result}" = 'skipped test location	SKIP'
}

test_status_skip_color() {
    result=$(export CLICOLOR_FORCE=1; unittest__print_result 'Location' 'SKIP' | awk '/\033/')

    test $? -eq 0 && test -n "${result}"
}

test_status_skip_nocolor() {
    result=$(export CLICOLOR_FORCE=0; unittest__print_result 'Location' 'SKIP' | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

test_status_unknown() {
    result=$(unittest__print_result 'other test location' 'OUCH')

    test $? -eq 0 && test "${result}" = 'other test location	OUCH'
}

test_status_unknown_color() {
    result=$(export CLICOLOR_FORCE=1; unittest__print_result 'Location' 'OUCH' | awk '/\033/')

    test $? -eq 0 && test -n "${result}"
}

test_status_unknown_nocolor() {
    result=$(export CLICOLOR_FORCE=0; unittest__print_result 'Location' 'OUCH' | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

#
# PRINT DEBUG
#

test_debug() {
    expected=$(printf '\n-- PROBLEM CLASS\n\nFirst paragraph\n\n    source code\n\nLast paragraph')
    result=$(unittest__print_debug 'PROBLEM CLASS' 'First paragraph' '    source code' 'Last paragraph' 2>&1)

    test $? -eq 0 && test "${result}" = "${expected}"
}

test_debug_color() {
    result=$(export CLICOLOR_FORCE=1; unittest__print_debug 'SOME ERROR' 'I found error in:' '    $ false' 2>&1 | awk '/\033/')

    test $? -eq 0 && test -n "${result}"
}

test_debug_nocolor() {
    result=$(export CLICOLOR_FORCE=0; unittest__print_debug 'SOME ERROR' 'I found error in:' '    $ false' 2>&1 | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}

test_debug_nocolor_empty() {
    result=$(export CLICOLOR_FORCE=; unittest__print_debug 'SOME ERROR' 'I found error in:' '    $ false' 2>&1 | awk '/\033/')

    test $? -eq 0 && test -z "${result}"
}
