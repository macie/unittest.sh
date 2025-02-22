#!/bin/sh
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

beforeEach() {
	FIXTURES=$(mktemp -d -t 'unittest_testXXXXXX')
}

afterEach() {
	rm -rf "${FIXTURES}"
}

test_issue8() {
#shellcheck disable=SC2034,SC2116
test_var=$(echo 123)
}

test_issue11() {
	# unittest version message and tput errors are written to stderr
	#shellcheck disable=SC1007
	test "$(TERM= ./unittest -v 2>&1 | wc -l)" -eq 1
}

test_issue13() {
	cat <<-'EOF' >"${FIXTURES}/test_heredoc.sh"
	#!/bin/sh

	test_nested_testcase_outer() {
		cat <<-'EONF' >/dev/null
		test_issue13_INVALID_standard() {
			test_issue13_INVALID_nested() {
			false
			}

			test_issue13_INVALID_nested
		}

		test_issue13_INVALID_oneliner() { false }

		test_issue13_INVALID_before() {
			false
		} test_issue13_INVALID_after() {
			false
		}
		
		test_issue13_INVALID_subshell() ( false	)

		EONF
		false
	}
	EOF

	result=$(./unittest "${FIXTURES}"/test_heredoc.sh | grep 'test_issue13_INVALID_')

	test -z "${result}"
}

test_issue16() {
	cat <<-'EOF' >"${FIXTURES}/test_err_msg_format.sh"
	#!/bin/sh

	test_false() {
		test 0 -eq a
	}
	EOF

	result=$(./unittest "${FIXTURES}"/test_err_msg_format.sh 2>&1 | grep "0 -eq 'a'")

	test "$?" -eq 0
}
