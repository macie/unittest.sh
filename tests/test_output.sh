#!/bin/sh
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

before_all() {
	FIXTURES=$(mktemp -d -t 'unittest_testXXXXXX')

	TESTCASE_SUCCESS="${FIXTURES}/test_success.sh"
	cat <<-'EOF' >"$TESTCASE_SUCCESS"
	test_true() {
		true
	}
	EOF
	TESTCASE_FAILURE="${FIXTURES}/test_failure.sh"
	cat <<-'EOF' >"$TESTCASE_FAILURE"
	test_false() {
		false
	}
	EOF
	TESTCASE_SKIPPED="${FIXTURES}/test_skipped.sh"
	cat <<-'EOF' >"$TESTCASE_SKIPPED"
	xtest_skipped() {
		false
	}
	EOF
	TESTCASE_TEST_FAILURE="${FIXTURES}/test_test_failure.sh"
	cat <<-'EOF' >"$TESTCASE_TEST_FAILURE"
	test_failure() {
		test ! true
	}
	EOF
}

before_each() {
	unset NO_COLOR CLICOLOR_FORCE
}

after_all() {
	rm -rf "${FIXTURES}"
}

#
# PRINT LOCATION
#

test_status_pass() {
	result=$(./unittest "$TESTCASE_SUCCESS")

	test $? -eq 0 && test "${result}" = "PASS	${TESTCASE_SUCCESS}:test_true"
}

test_status_pass_nocolor() {
	result=$(NO_COLOR=1 ./unittest "$TESTCASE_SUCCESS")

	test $? -eq 0 && test "${result}" = "PASS	${TESTCASE_SUCCESS}:test_true"
}

test_status_pass_color_force_set() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_SUCCESS" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_pass_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_SUCCESS" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_fail() {
	result=$(./unittest "$TESTCASE_FAILURE")

	test $? -eq 1 && test "${result}" = "FAIL	${TESTCASE_FAILURE}:test_false"
}

test_status_fail_nocolor() {
	result=$(NO_COLOR=1 ./unittest "$TESTCASE_FAILURE")

	test $? -eq 1 && test "${result}" = "FAIL	${TESTCASE_FAILURE}:test_false"
}

test_status_fail_color_force_set() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_FAILURE" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_fail_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_FAILURE" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_skip() {
	result=$(./unittest "$TESTCASE_SKIPPED")

	test $? -eq 0 && test "${result}" = "SKIP	${TESTCASE_SKIPPED}:xtest_skipped"
}

test_status_skip_nocolor() {
	result=$(NO_COLOR=1 ./unittest "$TESTCASE_SKIPPED")

	test $? -eq 0 && test "${result}" = "SKIP	${TESTCASE_SKIPPED}:xtest_skipped"
}

test_status_skip_color_force_set() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_SKIPPED" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_unknown_color_on() {
	result=$(UT_COLOR_OUTPUT='on' unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_unknown_color_off() {
	result=$(UT_COLOR_OUTPUT='off' unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_unknown_color_auto() {
	result=$(UT_COLOR_OUTPUT='auto' unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

#
# PRINT DEBUG
#

test_debug() {
	expected='-- FAILED TEST ------------------------------- test_test_failure.sh:test_failure'

	result=$(./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | grep 'FAILED TEST')

	test $? -eq 0 && test "${result}" = "${expected}"
}

test_debug_color_force_set() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_debug_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}
