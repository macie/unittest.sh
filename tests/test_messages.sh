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

test_unknown_error_message() {
  result=$( (ut__error_message) 2>&1 )

  local expected="Error: unknown error."

  assertEqual "${result}" "${expected}"
}


#
#  ut__create_fail_message
#

test_create_fail_message() {
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


#
#  ut__fail_indicator
#

test_fail_indicator_quiet() {
  _verbosity=0
  result=$(ut__fail_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}

test_fail_indicator_normal() {
  _verbosity=1
  result=$(ut__fail_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="F"

  assertEqual "${result}" "${expected}"
}

test_fail_indicator_verbose() {
  _verbosity=2
  result=$(ut__fail_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="FAIL"

  assertEqual "${result}" "${expected}"
}

test_fail_indicator_empty_verbosity() {
  _verbosity=
  result=$(ut__fail_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="F"

  assertEqual "${result}" "${expected}"
}

test_fail_indicator_unknown_verbosity() {
  _verbosity=100
  result=$(ut__fail_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="F"

  assertEqual "${result}" "${expected}"
}


#
#  ut__pass_indicator
#

test_pass_indicator_quiet() {
  _verbosity=0
  result=$(ut__pass_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}

test_pass_indicator_normal() {
  _verbosity=1
  result=$(ut__pass_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="."

  assertEqual "${result}" "${expected}"
}

test_pass_indicator_verbose() {
  _verbosity=2
  result=$(ut__pass_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="ok"

  assertEqual "${result}" "${expected}"
}

test_pass_indicator_empty_verbosity() {
  _verbosity=
  result=$(ut__pass_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="."

  assertEqual "${result}" "${expected}"
}

test_pass_indicator_unknown_verbosity() {
  _verbosity=100
  result=$(ut__pass_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="."

  assertEqual "${result}" "${expected}"
}


#
#  ut__testcase_indicator
#

test_testcase_indicator_quiet() {
  _verbosity=0
  result=$(ut__testcase_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}

test_testcase_indicator_normal() {
  _verbosity=1
  result=$(ut__testcase_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}

test_testcase_indicator_verbose() {
  _verbosity=2
  _current_testcase="test testcase"
  _current_testsuite="test testsuite"
  result=$(ut__testcase_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected="${_current_testcase} (${_current_testsuite}) ... "
  _current_testcase=${original_testcase}  # restore testcase for assert echo
  _current_testsuite=${original_testsuite}  # restore testsuite for assert echo

  assertEqual "${result}" "${expected}"
}

test_testcase_indicator_empty_verbosity() {
  _verbosity=
  result=$(ut__testcase_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}

test_testcase_indicator_unknown_verbosity() {
  _verbosity=100
  result=$(ut__testcase_indicator)
  _verbosity=${original_verbosity}  # restore verbosity for assert echo

  local expected=""

  assertEqual "${result}" "${expected}"
}
