#!/bin/sh
#
# Tests for ut_messages.
#

# import tested script
. "../ut_messages.sh"

setUp() {
  test_testcase="test testcase"
  test_testsuite="test testsuite"
}

tearDown() {
  unset -v "${test_testcase}"
  unset -v "${test_testsuite}"
}


#
#  ut_msg__help
#

test_help_message_retcode() {
  tested_command="ut_msg__help"

  assertRaises "${tested_command}"
}


#
#  ut_msg__help
#

test_help_message_retcode() {
  tested_command="ut_msg__version"

  assertRaises "${tested_command}"
}


#
#  ut_msg__error
#

test_error_message_value() {
  error_msg='error message'
  exit_value=123

  result_value=$(ut_msg__error "${error_msg}" "${exit_value}" 2>&1)

  expected_value="Error: ${error_msg}."

  assertEqual "${result_value}" "${expected_value}"
}

test_error_message_retcode() {
  error_msg='error message'
  exit_value=123
  tested_command='ut_msg__error "${error_msg}" "${exit_value}"'

  expected_retcode="${exit_value}"

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_error_message_value_no_exit_code() {
  error_msg='error message'
  result_value=$(ut_msg__error "${error_msg}" 2>&1)

  expected_value="Error: ${error_msg}."

  assertEqual "${result_value}" "${expected_value}"
}

test_error_message_retcode_no_exit_value() {
  error_msg='error message'
  tested_command='ut_msg__error "${error_msg}"'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_error_message_unknown_value() {
  result_value=$(ut_msg__error 2>&1)

  expected_value="Error: unknown error."

  assertEqual "${result_value}" "${expected_value}"
}

test_error_message_unknown_retcode() {
  tested_command='ut_msg__error'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_value}"
}


#
#  ut_msg__testcase_indicator
#

test_testcase_indicator_quiet() {
  test_verbosity=0
  result_value=$(ut_msg__testcase_indicator "${test_testsuite}" \
                                            "${test_testcase}" \
                                            "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__testcase_indicator "${test_testsuite}" \
                                            "${test_testcase}" \
                                            "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_detailed() {
  test_verbosity=2
  result_value=$(ut_msg__testcase_indicator "${test_testsuite}" \
                                            "${test_testcase}" \
                                            "${test_verbosity}")

  expected_value="${test_testcase} (${test_testsuite}) ... "

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_empty_verbosity() {
  result_value=$(ut_msg__testcase_indicator "${test_testsuite}" \
                                            "${test_testcase}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__testcase_indicator "${test_testsuite}" \
                                            "${test_testcase}" \
                                            "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut_msg__pass_indicator
#

test_pass_indicator_quiet() {
  test_verbosity=0
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_quiet_retcode() {
  test_verbosity=0
  tested_command='ut_msg__pass_indicator "${test_verbosity}"'

  assertRaises "${tested_command}"
}

test_pass_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_normal_retcode() {
  test_verbosity=1
  tested_command='ut_msg__pass_indicator "${test_verbosity}"'

  assertRaises "${tested_command}"
}

test_pass_indicator_detailed() {
  test_verbosity=2
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="ok"

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_detailed_retcode() {
  test_verbosity=2
  tested_command='ut_msg__pass_indicator "${test_verbosity}"'

  assertRaises "${tested_command}"
}

test_pass_indicator_empty_verbosity() {
  result_value=$(ut_msg__pass_indicator)

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_empty_retcode() {
  tested_command='ut_msg__pass_indicator'

  assertRaises "${tested_command}"
}

test_pass_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__pass_indicator "${test_verbosity}")

  expected_value="."

  assertEqual "${result_value}" "${expected_value}"
}

test_pass_indicator_unknown_retcode() {
  test_verbosity=100
  tested_command='ut_msg__pass_indicator "${test_verbosity}"'

  assertRaises "${tested_command}"
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

test_fail_indicator_quiet_retcode() {
  test_verbosity=0
  tested_command='ut_msg__fail_indicator "${test_verbosity}"'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_fail_indicator_normal() {
  test_verbosity=1
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_normal_retcode() {
  test_verbosity=1
  tested_command='ut_msg__fail_indicator "${test_verbosity}"'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_fail_indicator_detailed() {
  test_verbosity=2
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="FAIL"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_detailed_retcode() {
  test_verbosity=2
  tested_command='ut_msg__fail_indicator "${test_verbosity}"'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_fail_indicator_empty_verbosity() {
  result_value=$(ut_msg__fail_indicator)

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_empty_retcode() {
  tested_command='ut_msg__fail_indicator'

  expected_retcode=1

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_fail_indicator_unknown_verbosity() {
  test_verbosity=100
  result_value=$(ut_msg__fail_indicator "${test_verbosity}")

  expected_value="F"

  assertEqual "${result_value}" "${expected_value}"
}

test_fail_indicator_unknown_retcode() {
  test_verbosity=100
  tested_command='ut_msg__fail_indicator "${test_verbosity}"'

  expected_retcode=1

  assertRaises "${tested_command}" "${expeced_retcode}"
}


#
#  ut_msg__testcase_fail
#

test_testcase_first_fail() {
  test_failed=0
  result_value=$(ut_msg__testcase_fail "${test_testsuite}" \
                                       "${test_testcase}" \
                                       "${test_failed}")

  expected_value=$(printf '%s\\n' \
    '======================================================================' \
    " FAIL: ${ut989__testcase} (${ut989__testsuite})" \
    '----------------------------------------------------------------------')

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_first_fail_retcode() {
  test_failed=0
  tested_command="ut_msg__testcase_fail \"${test_testsuite}\"" \
                                       "\"${test_testcase}\"" \
                                       "\"${test_failed}\""

  expected_retcode=1

  assertRaise "${tested_command}" "${expected_retcode}"
}

test_testcase_more_fail() {
  test_failed=1
  result_value=$(ut_msg__testcase_fail "${test_testsuite}" \
                                       "${test_testcase}" \
                                       "${test_failed}")

  expected_value=''

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_more_fail_retcode() {
  test_failed=1
  tested_command="ut_msg__testcase_fail \"${test_testsuite}\"" \
                                       "\"${test_testcase}\"" \
                                       "\"${test_failed}\""

  expected_retcode=1

  assertRaise "${tested_command}" "${expected_retcode}"
}

test_testcase_fail_empty() {
  result_value=$(ut_msg__testcase_fail "${test_testsuite}" \
                                       "${test_testcase}")

  expected_value=''

  assertEqual "${result_value}" "${expected_value}"
}

test_testcase_fail_empty_retcode() {
  tested_command="ut_msg__testcase_fail \"${test_testsuite}\"" \
                                       "\"${test_testcase}\""

  expected_retcode=1

  assertRaise "${tested_command}" "${expected_retcode}"
}

#
#  ut_msg__traceback
#

test_traceback() {
  test_assert_name='<test assert>'
  test_result_expected='<result expected>'
  test_result_got='<result got>'
  result_value=$(ut_msg__traceback "${test_assert_name}" \
                                   "${test_result_expected}" \
                                   "${test_result_got}")

  expected_value=$(printf '%s\\n' \
    "-> ${test_assert_name} failed" \
    "   expected: ${test_result_expected}" \
    "   got: ${test_result_got}")

  assertEqual "${result_value}" "${expected_value}"
}

test_traceback_empty() {
  result_value=$(ut_msg__traceback)

  expected_value=$(printf '%s\\n' \
    "-> unknown assert failed" \
    "   expected: <unknown>" \
    "   got: <unknown>")
  
  assertEqual "${result_value}" "${expected_value}"
}


#
#  ut_msg__tests_summary
#

test_summary_message_pass() {
  test_testsnumber="10"
  test_teststime="0.123"

  result_value=$(ut_msg__tests_summary "${test_teststime}" \
                                       "${test_testsnumber}")

  expected_value=$(printf '%s\\n' \
    '----------------------------------------------------------------------' \
    "Ran ${test_testsnumber} tests in ${test_teststime}s" \
    "" \
    "OK")

  assertEqual "${result_value}" "${expected_value}"
}

test_summary_message_pass_retcode() {
  test_testsnumber="10"
  test_teststime="0.123"

  tested_command="ut_msg__tests_summary \"${test_teststime}\"" \
                                       "\"${test_testsnumber}\""

  assertRaises "${tested_command}"
}

test_summary_message_fail() {
  test_testsnumber="10"
  test_failsnumber="2"
  test_teststime="0.123"

  result_value=$(ut_msg__tests_summary "${test_teststime}" \
                                       "${test_testsnumber}" \
                                       "${test_failsnumber}")

  expected_value=$(printf '%s\\n' \
    '----------------------------------------------------------------------' \
    "Ran ${test_testsnumber} tests in ${test_teststime}s" \
    "" \
    "FAILED (failures=${test_failsnumber})")

  assertEqual "${result_value}" "${expected_value}"
}

test_summary_message_pass_retcode() {
  test_testsnumber="10"
  test_teststime="0.123"

  tested_command="ut_msg__tests_summary \"${test_teststime}\"" \
                                       "\"${test_testsnumber}\"" \
                                       "\"${test_failsnumber}\""

  expected_retcode=1

  assertRaises "${tested_command}" "${expeced_retcode}"
}
