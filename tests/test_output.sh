#!/bin/sh
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

beforeAll() {
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

afterAll() {
	rm -rf "${FIXTURES}"
}

#
# PRINT LOCATION
#

test_status_pass() {
	result=$(./unittest "$TESTCASE_SUCCESS")

	test $? -eq 0 && test "${result}" = "${TESTCASE_SUCCESS}:test_true	PASS"
}

test_status_pass_color_force_on() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_SUCCESS" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_pass_color_force_off() {
	result=$(CLICOLOR_FORCE=0 ./unittest "$TESTCASE_SUCCESS" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_pass_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_SUCCESS" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_fail() {
	result=$(./unittest "$TESTCASE_FAILURE")

	test $? -eq 1 && test "${result}" = "${TESTCASE_FAILURE}:test_false	FAIL"
}

test_status_fail_color_force_on() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_FAILURE" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_fail_color_force_off() {
	result=$(CLICOLOR_FORCE=0 ./unittest "$TESTCASE_FAILURE" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_fail_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_FAILURE" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_skip() {
	result=$(./unittest "$TESTCASE_SKIPPED")

	test $? -eq 0 && test "${result}" = "${TESTCASE_SKIPPED}:xtest_skipped	SKIP"
}

test_status_skip_color_force_on() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_SKIPPED" | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_skip_color_force_off() {
	result=$(CLICOLOR_FORCE=0 ./unittest "$TESTCASE_SKIPPED" | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_unknown() {
	result=$(unittest__print_result 'other test location' 'OUCH')

	test $? -eq 0 && test "${result}" = 'other test location	OUCH'
}

test_status_unknown_color_force_on() {
	# shellcheck disable=SC2030
	result=$(export CLICOLOR_FORCE=1; unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_status_unknown_color_force_off() {
	# shellcheck disable=SC2030,SC2031
	result=$(export CLICOLOR_FORCE=0; unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_status_unknown_color_force_unset() {
	# shellcheck disable=SC2031
	result=$(export CLICOLOR_FORCE=; unittest__print_result 'Location' 'OUCH' | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

#
# PRINT DEBUG
#

test_debug() {
	expected="-- FAILED TEST [${TESTCASE_TEST_FAILURE}:test_failure]"

	result=$(./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | grep 'FAILED TEST')

	test $? -eq 0 && test "${result}" = "${expected}"
}

test_debug_color_force_on() {
	result=$(CLICOLOR_FORCE=1 ./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | awk '/\033/')

	test $? -eq 0 && test -n "${result}"
}

test_debug_color_force_off() {
	result=$(CLICOLOR_FORCE=0 ./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}

test_debug_color_force_unset() {
	result=$(CLICOLOR_FORCE='' ./unittest "$TESTCASE_TEST_FAILURE" 2>&1 | awk '/\033/')

	test $? -eq 0 && test -z "${result}"
}
