#!/bin/sh


test_status_pass() {
    result=$(ut__test_result 'test location' 'PASS')

    test $? -eq 0
    test "${result}" = 'test location	PASS'
}

test_status_fail() {
    result=$(ut__test_result 'failed test location' 'FAIL')

    test $? -eq 0
    test "${result}" = 'failed test location	FAIL'
}

test_status_skip() {
    result=$(ut__test_result 'skipped test location' 'SKIP')

    test $? -eq 0
    test "${result}" = 'skipped test location	SKIP'
}

test_status_unknown() {
    result=$(ut__test_result 'other test location' 'OUCH')

    test $? -eq 0
    test "${result}" = 'other test location	OUCH'
}

