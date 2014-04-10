#!/bin/bash
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
_current_testcase=''
_current_testsuite=''


#
#   MESSAGES
#

unittest::help_message() {
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

unittest::version_message() {
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

unittest::error_message() {
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

unittest::create_fail_message() {
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

unittest::fail_indicator() {
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

unittest::pass_indicator() {
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

unittest::testcase_indicator() {
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
  # assert::equal 0 0  => pass
  local result="$1"
  local expected="$2"

  (( _tests_run++ ))
  if [[ "${result}" = "${expected}" ]]; then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertNotEqual() {
  # assert::not_equal 0 1  => pass
  local result="$1"
  local expected="$2"

  (( _tests_run++ ))
  if [[ "${result}" != "${expected}" ]]; then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertTrue() {
  # assert::true 1  => pass
  # assert::true ""  => fail
  local result="$1"

  (( _tests_run++ ))
  if ([ "${result}" != "0" ]) && ([ "${result}" ]); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertFalse() {
  # assert::false 0  => pass
  # assert::false ""  => pass
  local result="$1"

  (( _tests_run++ ))
  if ([ "${result}" = "0" ]) || ([ ! "${result}" ]); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertRaises() {
  # assert:raises function 0
  local result="$1"
  local expected="$2"

  (( _tests_run++ ))
  if [[ "${result}" = "${expected}" ]]; then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertGreater() {
  local result=$1
  local expected=$2

  (( _tests_run++ ))
  if (( ${result} > ${expected} )); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertGreaterEqual() {
  local result=$1
  local expected=$2

  (( _tests_run++ ))
  if (( ${result} >= ${expected} )); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertLess() {
  local result=$1
  local expected=$2

  (( _tests_run++ ))
  if (( ${result} < ${expected} )); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}

assertLessEqual() {
  local result=$1
  local expected=$2

  (( _tests_run++ ))
  if (( ${result} <= ${expected} )); then
    unittest::pass_indicator
    return 0
  else
    (( _tests_failed++ ))
    unittest::fail_indicator
    unittest::create_fail_message
    return 1
  fi
}


#
#   FUNCTIONS
#

unittest::parse_args() {
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
  while [[ "$1" == "-*" ]]; do
    case "$1" in
      -h|--help|-\?)
        unittest::help_message
        exit 0
        ;;

      -w|--where)
        if (($# > 1)); then
          _test_dir="$2"
          shift 2
        else
          unittest::error_message msg='no directory specified'
          exit 1
        fi
        ;;

      -V|--version|-\?)
        unittest::version_message
        exit 0
        ;;

      -v|--verbose)
        _verbosity=2
        shift 2
        ;;

      -q|--quiet)
        _verbosity=0
        shift 2
        ;;

      --with-coverage)
        _coverage=1
        shift 2
        ;;

      --cover-dir)
        if [[ $# > 1 ]] && [[ ${_coverage} == 1 ]]; then
          _cover_dir="$2"
          shift 2
        else
          unittest::error_message msg='no directory specified
                                       or no coverage support enabled'
          exit 1
        fi
        ;;

      -*)
        unittest::error_message msg="invalid option: $1"
        exit 1
        ;;
    esac
  done
}

unittest::autodiscovery() {
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
    _test_dir=$(find $(pwd)/ -type d | grep -m 1 -E '/tests(/.*)?$')
  fi

  _test_files="$(find "${_test_dir}" -name "test_*.sh")"
}

unittest::start() {
  #
  # Runs instruction before all tests.
  #
  # Globals:
  #     start_time (str) - Start time of tests (in nanoseconds).
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  _start_time="$(date +%s%N)"  # in nanoseconds
}

unittest::stop() {
  #
  # Runs instruction after all tests.
  #
  # Globals:
  #     _start_time (str) - Start time of tests (in nanoseconds).
  #     _tests_run (str) - Number of tests.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #
  local end_status=""
  local teststime=$(($(date +%s%N) - ${_start_time}))

  if (( ${_tests_failed} > 0 )); then
    printf "${_fail_messages}"
    end_status="FAILED (failures=${_tests_failed})"
  else
    end_status='OK'
  fi

  printf "
----------------------------------------------------------------------
Ran ${_tests_run} tests in ${teststime}s

${end_status}
"
}

unittest::before_test() {
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
  unittest::testcase_indicator
}

unittest::after_test() {
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

unittest::testrunner() {
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

  unittest::start

  for testfile in ${_test_files}; do

    _current_testsuite="${testfile#"$(pwd)/"}"

    source ${testfile}
    local setup=$(grep -o "setUp" ${testfile})
    local teardown=$(grep -o "tearDown" ${testfile})
    local test_suite=$(grep -o "test_[^\(]*" ${testfile})

    for test_case in ${test_suite}; do

      _current_testcase="${test_case}"
      unittest::before_test
      ${setup}
      ${test_case}
      ${teardown}
      unittest::after_test

      # reset test_case
      unset -f ${test_case}
    done

    # reset setup and teardown
    unset -v ${setup} ${teardown}
  done

  unittest::stop
}


#
#   MAIN ROUTINE
#

unittest::main () {
  unittest::parse_args "$@"
  unittest::autodiscovery
  unittest::testrunner

  exit 0
}

unittest::main "$@"
