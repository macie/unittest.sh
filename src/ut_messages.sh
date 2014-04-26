#!/bin/sh
#
# Message functions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


ut_msg__help() {
  #
  # Shows help message.
  #
  # Prefix for local variables:
  #     ut37a__
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     String message to standard output.
  #
  printf '%s\\n' \
    'unittest.sh - unit tests framework for shell scripts.' \
    'Usage:' \
    '  unittest.sh [options] [directory or file]' \
    '' \
    'Options:' \
    '  -h, --help                      Show this help and exit.' \
    '  -V, --version                   Show version number and exit.' \
    '  -v, --verbose                   Be more verbose.' \
    '  -q, --quiet                     Be less verbose.' \
    '      --with-coverage             Enable plugin coverage.sh.' \
    '      --cover-dir <directory>     Restrict coverage output to' \
    '                                  selected directory.'
}

ut_msg__version() {
  #
  # Shows version message.
  #
  # Prefix for local variables:
  #     ut89e__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str) - Version number.
  #
  # Returns:
  #     String message to standard output.
  #
  ut89e__version="$1"

  printf '%s\\n' \
    "unittest.sh ${ut89e__version}" \
    'Copyright (c) 2014 Maciej Żok' \
    'MIT License (http://opensource.org/licenses/MIT)'
}

ut_msg__error() {
  #
  # Shows error message.
  #
  # Prefix for local variables:
  #     utac4__
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     $1 (str) - Error message.
  #
  # Returns:
  #     String message to err output.
  #
  utac4__message="$1"

  if [ -z "${utac4__message}" ]; then  # no specified message
    utac4__message='unknown error'
  fi

  printf 'Error: %s.\\n' "${utac4__message}" 1>&2
}

ut_msg__testcase_indicator() {
  #
  # Pass indicator.
  #
  # Prefix for local variables:
  #     ut552__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str) - Current test suite name.
  #     $2 (str) - Current test case name.
  #     $3 (str) - Verbosity level.
  #
  # Returns:
  #     None.
  #
  ut552__testsuite="$1"
  ut552__testcase="$2"
  ut552__verbosity="$3"

  if [ "${ut552__verbosity}" = "2" ]; then
    printf "%s" "${ut552__testcase} (${ut552__testsuite}) ... "
  fi
}

ut_msg__pass_indicator() {
  #
  # Pass indicator.
  #
  # Prefix for local variables:
  #     ut9d9__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (int) - Verbosity level.
  #
  # Returns:
  #     String or nothing (if quiet verbosity).
  #
  ut9d9__verbosity="$1"

  if [ "${ut9d9__verbosity}" = "0" ]; then  # quiet verbosity
    return 0
  elif [ "${ut9d9__verbosity}" = "2" ]; then
    printf '%s\\n' 'ok'
  else  # normal verbosity
    printf '%s' '.'
  fi
}

ut_msg__fail_indicator() {
  #
  # Fail indicator.
  #
  # Prefix for local variables:
  #     ut755__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (int) - Verbosity level.
  #
  # Returns:
  #     String or nothing (if quiet verbosity).
  #
  ut755__verbosity="$1"

  if [ "${ut755__verbosity}" = '0' ]; then  # quiet verbosity
    return 0
  elif [ "${ut755__verbosity}" = '2' ]; then
    printf '%s\\n' 'FAIL'
  else  # normal verbosity
    printf '%s' 'F'
  fi
}

ut_msg__assert_fail(){
  #
  # Print assert fail message.
  #
  # Prefix for local variables:
  #     ut989__
  #
  # Globals:
  #     _assert_failed (int) - Flag shows if assert is failed.
  #
  # Arguments:
  #     $1 (str) - Test suite name.
  #     $2 (str) - Test case name.
  #     $3 (int) - Test failed flag.
  #
  # Returns:
  #     None.
  #
  ut989__testsuite="$1"
  ut989__testcase="$2"
  ut989__test_failed="$3"

  if [ "${ut989__test_failed}" = "0" ]; then
    printf '%s\\n' \
      '======================================================================' \
      " FAIL: ${ut989__testcase} (${ut989__testsuite})" \
      '----------------------------------------------------------------------'
    return 1
  fi
}

ut_msg__traceback() {
  #
  # Prints traceback message.
  #
  # Prefix for local variables:
  #     ut43f__
  #
  # Globals:
  #     None. 
  #
  # Arguments:
  #     $1 (str) - Assert name.
  #     $2 (str) - Result.
  #     $3 (str) - Expected result.
  #
  # Returns:
  #     None.
  #
  ut43f__name="$1"
  ut43f__result="$2"
  ut43f__expected="$3"

  printf '%s\\n' \
    "-> ${ut43f__name} failed" \
    "   expected: ${ut43f__expected}" \
    "   got: ${ut43f__result}"
}

ut_msg__tests_summary() {
  #
  # Tests summary message.
  #
  # Prefix for local variables:
  #     ut9c9__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (int) - Tests ran number.
  #     $2 (int) - Tests failed number.
  #     $3 (int) - Tests time.
  #
  # Returns:
  #     Tests summary message.
  #
  ut9c9__tests_ran="$1"
  ut9c9__tests_failed="$2"
  ut9c9__tests_time="$3"

  printf '%s\\n' \
    '----------------------------------------------------------------------' \
    "Ran ${ut9c9__tests_ran} tests in ${ut9c9__tests_time}s" \
    ""

  if [ "${ut9c9__tests_failed}" -gt 0 ]; then
    printf '%s\\n' "FAILED (failures=${ut9c9__tests_failed})"
    return 1
  else
    printf '%s\\n' 'OK'
  fi
}
