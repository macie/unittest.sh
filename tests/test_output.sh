#!/bin/sh


test_status_pass() {
    result=$(unittest__print_result 'test location' 'PASS')

    test $? -eq 0
    test "${result}" = 'test location	PASS'
}

test_status_fail() {
    result=$(unittest__print_result 'failed test location' 'FAIL')

    test $? -eq 0
    test "${result}" = 'failed test location	FAIL'
}

test_status_skip() {
    result=$(unittest__print_result 'skipped test location' 'SKIP')

    test $? -eq 0
    test "${result}" = 'skipped test location	SKIP'
}

test_status_unknown() {
    result=$(unittest__print_result 'other test location' 'OUCH')

    test $? -eq 0
    test "${result}" = 'other test location	OUCH'
}

