#!/bin/sh

# import tested script
#. "../unittest.sh"

setUp() {
  original_assert_failed=${_assert_failed}
  original_fail_messages=${_fail_messages}
  original_verbosity=${_verbosity}
  test_testcase="test testcase"
  test_testsuite="test testsuite"
}

tearDown() {
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}
  _verbosity=${original_verbosity}
  unset -v "${test_testcase}"
  unset -v "${test_testsuite}"
}


#
#  ut__error_message
#

test_error_message() {
  error_msg='error message'

  result_value=$(ut_msg__error_message "${error_msg}" 2>&1)

  expected_value="Error: ${error_msg}."

  assertEqual "${result_value}" "${expected_value}"
}

test_unknown_error_message() {
  result_value=$(ut_msg__error_message 2>&1)

  expected_value="Error: unknown error."

  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut__create_fail_message
#

test_create_fail_message() {
  _assert_failed=0
  _fail_messages=""
  result_value=$(ut_msg__create_fail_message )

  expected_value=$(printf "%s" "
======================================================================
 FAIL: ${test_testcase} (${test_testsuite})
----------------------------------------------------------------------
 
 ")
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result_value}" "${expected_value}"
}

test_create_fail_message_second_time() {
  _assert_failed=1
  _fail_messages=""
  result_value=$(ut__create_fail_message)

  expected_value=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result_value}" "${expected_value}"
}

test_create_fail_message_many_times() {
  _assert_failed=100
  _fail_messages=""
  result_value=$(ut__create_fail_message)

  expected_value=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result_value}" "${expected_value}"
}

test_create_fail_message_empty() {
  _assert_failed=
  _fail_messages=""
  result_value=$(ut__create_fail_message)

  expected_value=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut__fail_indicator
#

test_fail_indicator_quiet() {
  test_verbosity=0
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_verbose() {
  test_verbosity=2
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="FAIL"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_empty_verbosity() {
  result_value=$(ut_msg__fail_indicator)

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut__pass_indicator
#

test_pass_indicator_quiet() {
  test_verbosity=0
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_verbose() {
  test_verbosity=2
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="ok"

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_empty_verbosity() {
  result_value=$(ut_msg__pass_indicator)

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut__testcase_indicator
#

test_testcase_indicator_quiet() {
  test_verbosity=0
  result_value=$(ut_msg__testcase_indicator \
    "${test_testsuite}" "${test_testcase}" "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__testcase_indicator \
    "${test_testsuite}" "${test_testcase}" "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_verbose() {
  test_verbosity=2
  result_value=$(ut_msg__testcase_indicator \
    "${test_testsuite}" "${test_testcase}" "${test_verbosity}")

  expected_value="${test_testcase} (${test_testsuite}) ... "

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_empty_verbosity() {
  result_value=$(ut_msg__testcase_indicator \
    "${test_testsuite}" "${test_testcase}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__testcase_indicator \
    "${test_testsuite}" "${test_testcase}" "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}
