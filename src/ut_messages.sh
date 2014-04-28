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
  #     None.
  #
  # Arguments:
  #     None.
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
    '                                  selected directory.' \
      && exit "${EXIT_OK}"
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
    'MIT License (http://opensource.org/licenses/MIT)' \
      && exit "${EXIT_OK}"
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
  #     $1 (str) - (optional) Error message. Default: unknown error.
  #     $2 (str) - (optional) Exit code. Default: standard error.
  #
  # Returns:
  #     Message to stderr and exit with specified exit code.
  #
  utac4__message="${1:-unknown error}"
  utac4__exit_code="${2:-${EXIT_FAIL}}"

  printf 'Error: %s.\\n' "${utac4__message}" 1>&2 \
    && exit "${utac4__exit_code}"
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
  #     $3 (str) - (optional) Verbosity level. Default: normal level.
  #
  # Returns:
  #     None.
  #
  ut552__testsuite="$1"
  ut552__testcase="$2"
  ut552__verbosity="${3:-${NORMAL_VERBOSE}}"

  if [ "${ut552__verbosity}" = "${DETAILED_VERBOSE}" ]; then
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
  #     $1 (int) - (optional) Verbosity level. Default: normal level.
  #
  # Returns:
  #     String or nothing (if quiet verbosity) and 0.
  #
  ut9d9__verbosity="${1:-${NORMAL_VERBOSE}}"

  if [ "${ut9d9__verbosity}" = "${QUIET_VERBOSE}" ]; then
    return
  elif [ "${ut9d9__verbosity}" = "${DETAILED_VERBOSE}" ]; then
    printf '%s\\n' 'ok'
  else  # normal verbosity
    printf '%s' '.'
  fi

  return 0
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
  #     $1 (int) - Verbosity level. Default: normal level.
  #
  # Returns:
  #     String or nothing (if quiet verbosity) and 1.
  #
  ut755__verbosity="${1:-${NORMAL_VERBOSE}}"

  if [ "${ut755__verbosity}" = "${QUIET_VERBOSE}" ]; then
    return
  elif [ "${ut755__verbosity}" = "${DETAILED_VERBOSE}" ]; then
    printf '%s\\n' 'FAIL'
  else  # normal verbosity
    printf '%s' 'F'
  fi

  return 1
}

ut_msg__testcase_fail(){
  #
  # Print assert fail message.
  #
  # Prefix for local variables:
  #     ut989__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (str) - Test suite name.
  #     $2 (str) - Test case name.
  #     $3 (int) - (optional) Test failed flag. Default: 0.
  #
  # Returns:
  #     None.
  #
  ut989__testsuite="$1"
  ut989__testcase="$2"
  ut989__test_failed="${3:-0}"

  if [ "${ut989__test_failed}" = "0" ]; then
    printf '%s\\n' \
      '======================================================================' \
      " FAIL: ${ut989__testcase} (${ut989__testsuite})" \
      '----------------------------------------------------------------------' \
        && return "${EXIT_FAIL}"
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
    printf '%s\\n' "FAILED (failures=${ut9c9__tests_failed})" \
      && return "${EXIT_FAIL}"
  else
    printf '%s\\n' 'OK'
  fi
}
