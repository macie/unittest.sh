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

readonly _version_='0.1-dev'

_coverage=0  # no coverage
_cover_dir=''
_verbosity=1  # normal verbosity

_test_dir=''
_test_files=''

_tests_run=0
_tests_failed=0
_fail_messages=''
_tests_starttime=''
_current_testcase=''
_current_testsuite=''


#
#   MESSAGES
#

ut__help_message() {
  #
  # Shows help message.
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
  echo 'unittest.sh - unit tests framework for shell scripts.'
  echo 'Usage:'
  echo '  unittest.sh [options] [filename]'
  echo 
  echo 'Options:'
  echo '  -h, --help                      Show this help and exit.'
  echo '  -V, --version                   Show version number and exit.'
  echo '  -w, --where <directory>         Look for tests in this directory.'
  echo '  -v, --verbose                   Be more verbose.'
  echo '  -q, --quiet                     Be less verbose.'
  echo '      --with-coverage             Enable plugin coverage.sh.'
  echo '      --cover-dir <directory>     Restrict coverage output to'
  echo '                                  selected directory.'
}

ut__version_message() {
  #
  # Shows version message.
  #
  # Globals:
  #     _version_ - Version number.
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     String message to standard output.
  #
  echo "unittest.sh ${_version_}"
  echo
  echo 'Copyright (c) 2014 Maciej Żok'
  echo 'MIT License (http://opensource.org/licenses/MIT)'
}

ut__error_message() {
  #
  # Shows error message.
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     msg (str) - Error message.
  #
  # Returns:
  #     String message to err output.
  #
  local msg
  local "$@"

  echo "Error: ${msg}." 1>&2
}

ut__create_fail_message() {
  #
  # Creates fail message.
  #
  # Globals:
  #     _current_testcase (str) - 
  #     _current_testsuite (str) - 
  #     _fail_messages (str) - 
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  _fail_messages="${_fail_messages}$(printf "
======================================================================
 FAIL: ${_current_testcase} (${_current_testsuite})
----------------------------------------------------------------------
 
 ")"
}

ut__fail_indicator() {
  #
  # Fail indicator.
  #
  # Globals:
  #     _verbosity (int) - Verbosity level.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  if [[ ${_verbosity} == 1 ]]; then
    echo -n 'E'
  elif [[ ${_verbosity} == 2 ]]; then
    echo 'error'
  fi
}

ut__pass_indicator() {
  #
  # Pass indicator.
  #
  # Globals:
  #     _verbosity (int) - Verbosity level.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  if [[ ${_verbosity} == 1 ]]; then
    echo -n '.'
  elif [[ ${_verbosity} == 2 ]]; then
    echo 'ok'
  fi
}

ut__testcase_indicator() {
  #
  # Pass indicator.
  #
  # Globals:
  #     _current_testcase (str) - 
  #     _current_testsuite (str) - 
  #     _verbosity (int) - Verbosity level.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  if [[ ${_verbosity} == 2 ]]; then
    echo -n "${_current_testcase} (${_current_testsuite}) ... "
  fi
}

#
#   ASSERTIONS
#

assertEqual() {
  # assertEqual 0 0  => pass
  local result="$1"
  local expected="$2"

  if [[ "${result}" = "${expected}" ]]; then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertNotEqual() {
  # assertNotEqual 0 1  => pass
  local result="$1"
  local expected="$2"

  if [[ "${result}" != "${expected}" ]]; then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertTrue() {
  # assertTrue 1  => pass
  # assertTrue ""  => fail
  local result="$1"

  if ([ "${result}" != "0" ]) && ([ "${result}" ]); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertFalse() {
  # assertFalse 0  => pass
  # assertFalse ""  => pass
  local result="$1"

  if ([ "${result}" = "0" ]) || ([ ! "${result}" ]); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertRaises() {
  # assertRaises function 1
  local result="$1"
  local expected="$2"

  if [[ "${result}" = "${expected}" ]]; then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertGreater() {
  local result=$1
  local expected=$2

  if (( ${result} > ${expected} )); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertGreaterEqual() {
  local result=$1
  local expected=$2

  if (( ${result} >= ${expected} )); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertLess() {
  local result=$1
  local expected=$2

  if (( ${result} < ${expected} )); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}

assertLessEqual() {
  local result=$1
  local expected=$2

  if (( ${result} <= ${expected} )); then
    ut__pass_indicator
    return 0
  else
    ut__fail_indicator
    ut__create_fail_message
    return 1
  fi
}


#
#   FUNCTIONS
#

ut__parse_args() {
  #
  # Parses script parameters.
  #
  # Globals:
  #     _coverage (int) - Is coverage plugin enabled?
  #     _cover_dir (str) - Directory for coverage.
  #     _test_dir (str) - Directory with tests.
  #     _verbosity (int) - Verbosity level.
  #
  # Arguments:
  #     params (str) - Script params.
  #
  # Returns:
  #     String message or nothing.
  #
  while [[ $1 == -* ]]; do
    case "$1" in
      -h|--help|-\?)
        ut__help_message
        exit 0
        ;;

      -w|--where)
        if (($# > 1)); then
          _test_dir="$2"
          shift 2
        else
          ut__error_message msg='no directory specified'
          exit 1
        fi
        ;;

      -V|--version|-\?)
        ut__version_message
        exit 0
        ;;

      -v|--verbose)
        _verbosity=2
        shift 1
        ;;

      -q|--quiet)
        _verbosity=0
        shift 1
        ;;

      --with-coverage)
        _coverage=1
        shift 1
        ;;

      --cover-dir)
        if [[ $# > 1 ]] && [[ ${_coverage} == 1 ]]; then
          _cover_dir="$2"
          shift 2
        else
          ut__error_message msg='no directory specified
                                       or no coverage support enabled'
          exit 1
        fi
        ;;

      -*)
        ut__error_message msg="invalid option: $1"
        exit 1
        ;;
    esac
  done
}

ut__autodiscovery() {
  #
  # Finds directories with tests.
  #
  # Globals:
  #     _test_dir (str) - Directory with tests.
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     testfiles (str) - Files with tests.
  #
  if [[ "${_test_dir}" == '' ]]; then
    _test_dir=$(find $(pwd)/ -regex '.*/tests' -print -quit)
  fi

  _test_files="$(find "${_test_dir}" -name "test_*.sh")"
}

ut__start() {
  #
  # Runs instruction before all tests.
  #
  # Globals:
  #     _tests_starttime (str) - Start time of tests (in nanoseconds).
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  _tests_starttime="$(date +%s%N)"  # nanoseconds_since_epoch
}

ut__stop() {
  #
  # Runs instruction after all tests.
  #
  # Globals:
  #     _tests_starttime (str) - Start time of tests (in nanoseconds).
  #     _tests_run (str) - Number of tests.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  local end_status=""
  local tests_endtime="$(date +%s%N)"    # nanoseconds_since_epoch
  # required visible decimal place for seconds (leading zeros if needed)
  local tests_time="$( \
    printf "%010d" "$(( ${tests_endtime} - ${_tests_starttime} ))")"

  # in format: seconds.microseconds (eg. 0.012)
  tests_time="${tests_time:0:${#tests_time}-9}.${tests_time:${#tests_time}-9:${#tests_time}-7}"

  if (( ${_tests_failed} > 0 )); then
    printf "${_fail_messages}"
    end_status="FAILED (failures=${_tests_failed})"
  else
    end_status='OK'
  fi

  printf "
----------------------------------------------------------------------
Ran ${_tests_run} tests in ${tests_time}s

${end_status}
"
}

ut__before_test() {
  #
  # Runs instruction before each test function.
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
  ut__testcase_indicator
}

ut__after_test() {
  #
  # Runs instruction after each test function.
  #
  # Globals:
  #     _verbosity (int) - Verbosity level.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  return 0
}

ut__testrunner() {
  #
  # Runs tests.
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

  ut__start

  for testfile in ${_test_files}; do

    _current_testsuite="${testfile#"$(pwd)/"}"

    source ${testfile}
    local setup=$(grep -o "setUp" ${testfile})
    local teardown=$(grep -o "tearDown" ${testfile})
    local test_suite=$(grep -o "test_[^\(]*" ${testfile})

    for test_case in ${test_suite}; do
      (( _tests_run++ ))

      _current_testcase="${test_case}"
      ut__before_test
      ${setup}

      ${test_case}
      if [[ $? = 1 ]]; then
        # TODO: needed test for 2 diferent return codes from one test function
        (( _tests_failed++ ))
      fi

      ${teardown}
      ut__after_test

      # reset test_case
      unset -f ${test_case}
    done

    # reset setup and teardown
    unset -v ${setup} ${teardown}
  done

  ut__stop
}


#
#   MAIN ROUTINE
#

ut__main () {
  ut__parse_args "$@"
  ut__autodiscovery
  ut__testrunner

  exit 0
}

ut__main "$@"
