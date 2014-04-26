#!/bin/sh
#
# Assertions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


ut_assert__assertEqual() {
  #
  # Assertion for eqaul values.
  #
  # Prefix for local variables:
  #     uted1__
  #
  # Example:
  #     assertEqual 0 0  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  uted1__result="$1"
  uted1__expected="$2"

  if [ "${uted1__result}" = "${uted1__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertEqual" \
                      "${uted1__result}" \
                      "${uted1__expected}"
    return 1
  fi
}

ut_assert__assertNotEqual() {
  #
  # Assertion for not eqaul values.
  #
  # Prefix for local variables:
  #     ut295__
  #
  # Example:
  #     assertNotEqual 0 1  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut295__result="$1"
  ut295__expected="$2"

  if [ "${ut295__result}" != "${ut295__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertNotEqual" \
                      "${ut295__result}" \
                      "not ${ut295__expected}"
    return 1
  fi
}

ut_assert__assertTrue() {
  #
  # Assertion for true.
  #
  # Prefix for local variables:
  #     utfb5__
  #
  # Example:
  #     assertTrue 1   => pass
  #     assertTrue ""  => fail
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #
  # Returns:
  #     None.
  #
  utfb5__result="$1"

  if [ "${utfb5__result}" != "0" ] \
       && [ "${utfb5__result}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertTrue" \
                      "${utfb5__result}" \
                      "1"
    return 1
  fi
}

ut_assert__assertFalse() {
  #
  # Assertion for false.
  #
  # Prefix for local variables:
  #     utc56__
  #
  # Example:
  #     assertFalse 0   => pass
  #     assertTrue ""  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #
  # Returns:
  #     None.
  #
  utc56__result="$1"

  if [ "${utc56__result}" = "0" ] \
      || [ ! "${utc56__result}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertFalse" \
                      "${utc56__result}" \
                      "0"
    return 1
  fi
}

ut_assert__assertRaises() {
  #
  # Assertion for return values.
  #
  # Prefix for local variables:
  #     ut713__
  #
  # Example:
  #     assertRaises some_function 1
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (int) - Tested result.
  #     $2 (int) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut713__result="$1"
  ut713__expected="$2"

  if [ -n "${ut713__expected}" ] \
      && [ "${ut713__result}" = "${ut713__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertRaises" \
                      "${ut713__result}" \
                      "${ut713__expected}"
    return 1
  fi
}

ut_assert__assertGreater() {
  #
  # Assertion for greater values.
  #
  # Prefix for local variables:
  #     utf74__
  #
  # Example:
  #     assertGreater 0 1  => fail
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  utf74__result=$1
  utf74__expected=$2

  if [ -n "${utf74__result}" ] \
      && [ -n "${utf74__expected}" ] \
      && [ "${utf74__result}" -eq "${utf74__result}" ] 2> /dev/null \
      && [ "${utf74__expected}" -eq "${utf74__expected}" ] 2> /dev/null \
      && [ "${utf74__result}" -gt "${utf74__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertGreater" \
                      "${utf74__result}" \
                      "> ${utf74__expected}"
    return 1
  fi
}

ut_assert__assertGreaterEqual() {
  #
  # Assertion for greater eqaul values.
  #
  # Prefix for local variables:
  #     ut5f1__
  #
  # Example:
  #     assertGreaterEqual 1 1  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut5f1__result=$1
  ut5f1__expected=$2

  if [ -n "${ut5f1__result}" ] \
      && [ -n "${ut5f1__expected}" ] \
      && [ "${ut5f1__result}" -eq "${ut5f1__result}" ] 2> /dev/null \
      && [ "${ut5f1__expected}" -eq "${ut5f1__expected}" ] 2> /dev/null \
      && [ "${ut5f1__result}" -ge "${ut5f1__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertGreaterEqual" \
                      "${ut5f1__result}" \
                      ">= ${ut5f1__expected}"
    return 1
  fi
}

ut_assert__assertLess() {
  #
  # Assertion for less values.
  #
  # Prefix for local variables:
  #     ut695__
  #
  # Example:
  #     assertLess 0 1  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut695__result=$1
  ut695__expected=$2

  if [ -n "${ut695__result}" ] \
      && [ -n "${ut695__expected}" ] \
      && [ "${ut695__result}" -eq "${ut695__result}" ] 2> /dev/null \
      && [ "${ut695__expected}" -eq "${ut695__expected}" ] 2> /dev/null \
      && [ "${ut695__result}" -lt "${ut695__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertLess" \
                      "${ut695__result}" \
                      "< ${ut695__expected}"
    return 1
  fi
}

ut_assert__assertLessEqual() {
  #
  # Assertion for less eqaul values.
  #
  # Prefix for local variables:
  #     ut199__
  #
  # Example:
  #     assertNotEqual 0 1  => pass
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str or int) - Tested result.
  #     $2 (str or int) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut199__result=$1
  ut199__expected=$2

  if [ -n "${ut199__result}" ] \
      && [ -n "${ut199__expected}" ] \
      && [ "${ut199__result}" -eq "${ut199__result}" ] 2> /dev/null \
      && [ "${ut199__expected}" -eq "${ut199__expected}" ] 2> /dev/null \
      && [ "${ut199__result}" -le "${ut199__expected}" ]; then
    return 0
  else
    ut_msg__assert_fail "${CURRENT_TESTSUITE}" \
                        "${CURRENT_TESTCASE}" \
                        "${TEST_FAIL_FLAG}"
    TEST_FAIL_FLAG=$?

    ut_msg__traceback "assertLessEqual" \
                      "${ut199__result}" \
                      "<= ${ut199__expected}"
    return 1
  fi
}
