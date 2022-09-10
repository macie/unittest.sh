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


#
#  ut__create_fail_message
#

xtest_create_fail_message() {
  _assert_failed=0
  _fail_messages=""
  _current_testcase="test testcase"
  _current_testsuite="test testsuite"
  result=$(ut__create_fail_message)

  local expected=$(printf "
======================================================================
 FAIL: ${_current_testcase} (${_current_testsuite})
----------------------------------------------------------------------
 
 ")
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}
  _current_testcase=${original_testcase}
  _current_testsuite=${original_testsuite}

  assertEqual "${result}" "${expected}"
}

test_create_fail_message_second_time() {
  _assert_failed=1
  _fail_messages=""
  result=$(ut__create_fail_message)

  local expected=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result}" "${expected}"
}

test_create_fail_message_many_times() {
  _assert_failed=100
  _fail_messages=""
  result=$(ut__create_fail_message)

  local expected=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result}" "${expected}"
}

test_create_fail_message_empty() {
  _assert_failed=
  _fail_messages=""
  result=$(ut__create_fail_message)

  local expected=""
  # restore values for assert echo
  _assert_failed=${original_assert_failed}
  _fail_messages=${original_fail_messages}

  assertEqual "${result}" "${expected}"
}

