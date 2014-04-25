#!/bin/sh
#
# Runner functions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


ut_runner__autodiscovery() {
  #
  # Finds directories with tests.
  #
  # Prefix for local variables:
  #     ut8cf__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str) - Directory with tests.
  #
  # Returns:
  #     String with test file names separated with colon.
  #
  ut8cf__test_dir="$1"

  if [ "${ut8cf__test_dir}" = '' ]; then
    ut8cf__test_dir=$(find "$(pwd)/" -regex '.*/tests' -print -quit)
  fi

  find "${ut8cf__test_dir}" -name "test_*.sh" || return 1
}

ut_runner__start() {
  #
  # Runs instruction before all tests.
  #
  # Prefix for local variables:
  #     utb4c__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     String with start time of tests (in nanoseconds).
  #
  date +%s%N || return 1  # nanoseconds_since_epoch
}

ut_runner__stop() {
  #
  # Runs instruction after all tests.
  #
  # Infix for local variables:
  #     ut5d8__
  #
  # Globals:
  #     _tests_starttime (str) - Start time of tests (in nanoseconds).
  #     _tests_run (int) - Number of tests.
  #     _tests_failed (int) - Number of failed tests.
  #
  # Arguments:
  #     $1 (str) - 
  #     $2 (int) -
  #     $3 (int) -
  #
  # Returns:
  #     None.
  #
  ut5d8__starttime="$1"
  ut5d8__ran_number="$2"
  ut5d8__failed_number="$3"

  ut5d8__tests_endtime="$(date +%s%N)"    # nanoseconds_since_epoch
  # required visible decimal place for seconds (leading zeros if needed)
  ut5d8__tests_time="$( \
    printf "%010d" "$(( ut5d8__tests_endtime - ut5d8__starttime ))")"

  # in format: seconds.microseconds (eg. 0.012)
  ut5d8__tests_time="${ut5d8__tests_time:0:${#ut5d8__tests_time}-9}.${ut5d8__tests_time:${#ut5d8__tests_time}-9:${#ut5d8__tests_time}-7}"

  ut_msg__tests_summary "${ut5d8__ran_number}" \
                        "${ut5d8__failed_number}" \
                        "${ut5d8__tests_time}"
}

ut_runner__before_test() {
  #
  # Runs instruction before each test function.
  #
  # Prefix for local variables:
  #     ut867__
  #
  # Globals:
  #     TEST_FAIL_FLAG (int) - Flag shows if assert is failed.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  TEST_FAIL_FLAG=0

  ut_msg__testcase_indicator
}

ut_runner__after_test() {
  #
  # Runs instruction after each test function.
  #
  # Prefix for local variables:
  #     uta70__
  #
  # Globals:
  #     TEST_FAIL_FLAG (int) - Flag shows if test failed.
  #     _tests_failed (int) - Number of failed tests.
  #     _tests_run (int) - Number of tests.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     0 if pass, 1 if failed.
  #
  uta70__verbosity="$1"

  if [ "${TEST_FAIL_FLAG}" -eq 1 ]; then
    ut_msg__fail_indicator "${uta70__verbosity}"
    return 1
  else
    ut_msg__pass_indicator "${uta70__verbosity}"
    return 0
  fi
}

ut_runner__testsrunner() {
  #
  # Runs tests.
  #
  # Prefix for local variables:
  #     utbb8__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  utbb8__tests_ran=0
  utbb8__tests_failed=0

  ut_runner__start

  for utbb8__testfile in ${utbb8__test_files}; do

    utbb8__current_testsuite="${utbb8__testfile#"$(pwd)/"}"

    . "${utbb8__testfile}"
    utbb8__setup=$(grep -o "setUp" "${utbb8__testfile}")
    utbb8__teardown=$(grep -o "tearDown" "${utbb8__testfile}")
    utbb8__test_suite=$(grep -o "test_[^\(]*" "${utbb8__testfile}")

    for utbb8__test_case in ${utbb8__test_suite}; do

      utbb8__current_testsuite="${utbb8__test_case}"
      ut_runner__before_test
      ${utbb8__function_setup}

      ${utbb8__test_case}

      ${utbb8__function_teardown}
      ut_runner__after_test "${utbb8__verbosity}"
      utbb8__tests_failed=$(( utbb8__tests_failed + $? ))

      # reset test_case
      if [ "${utbb8__test_case}" != "" ]; then
        unset -f "${utbb8__test_case}"
      fi
    done

    utbb8__tests_ran=$(( utbb8__tests_ran + 1 ))

    # reset setup and teardown
    if [ "${utbb8__function_setup}" != "" ]; then
      unset -f "${utbb8__function_setup}"
    fi
    if [ "${utbb8__function_teardown}" != "" ]; then
      unset -f "${utbb8__function_teardown}"
    fi
  done

  ut_runner__stop "${utbb8__test_starttime}" \
                  "${utbb8__tests_ran}" \
                  "${utbb8__tests_failed}"
}
