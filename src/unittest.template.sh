#!/bin/sh
#
# unittest.sh - unit tests framework for shell scripts.
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


#
#   DEFAULTS
#

readonly UNITTEST_SH_VERSION='0.1-dev'

readonly QUIET_VERBOSE=0
readonly NORMAL_VERBOSE=1
readonly DETAILED_VERBOSE=2

_coverage=0  # no coverage
_cover_dir=''
_verbosity=1  # normal verbosity

_test_dir=''
_test_files=''

_assert_failed=0
_tests_run=0
_tests_failed=0
_fail_messages=''
_tests_starttime=''
_current_testcase=''
_current_testsuite=''


#
#   EXIT CODES
#

readonly EXIT_OK=0
readonly EXIT_FAIL=1


#
#   MESSAGES
#
#   insert here content of file: <ut_messages.sh>


#
#   ASSERTIONS
#
#   insert here content of file: <ut_assertions.sh>


#
#   PARSERS
#
#   insert here content of file: <ut_parsers.sh>


#
#   RUNNER
#
#   insert here content of file: <ut_runner.sh>


#
#   MAIN ROUTINE
#

ut__main() {
  #
  # Prefix for local variables:
  #     ut257__
  #
  ut_runner__parse_args "$@"
  ut_runner__autodiscovery "${ut257__test_dir}"
  ut_runner__testsrunner

  exit 0
}

ut__main "$@"
