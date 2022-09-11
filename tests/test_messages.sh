#!/bin/sh


setUp() {
  original_assert_failed=${_assert_failed}
  original_fail_messages=${_fail_messages}
  original_verbosity=${_verbosity}
  original_testsuite=${_current_testcase}
  original_testsuite=${_current_testsuite}
}

tearDown() {
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}
  _verbosity=${original_verbosity}
  _current_testcase=${original_testcase}
  _current_testsuite=${original_testsuite}
}


#
#  ut__error_message
#

test_error_message() {
  error_msg='error message'

  result=$( (ut__error_message msg="${error_msg}") 2>&1 )

  local expected="Error: ${error_msg}."

  assertEqual "${result}" "${expected}"
}

xtest_unknown_error_message() {
  result=$( (ut__error_message) 2>&1 )

  local expected="Error: unknown error."

  assertEqual "${result}" "${expected}"
}

