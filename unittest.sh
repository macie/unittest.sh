#!/bin/bash
#
# unittest.sh - unit tests framework for shell scripts.
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


#
#   IMPORTS
#

source "plugins/assert.sh"
source "plugins/stub.sh"


#
#   DEFAULTS
#

_VERSION_="0.1-dev"

_COVERAGE=0  # no coverage
_COVER_DIR=""
_VERBOSITY=1  # normal verbosity
_TEST_DIR=""


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
  echo "unittest.sh - unit tests framework for shell scripts."
  echo "Usage:"
  echo "  unittest.sh [options] [filename]"
  echo 
  echo "Options:"
  echo "  -h, --help                      Show this help and exit."
  echo "  -V, --version                   Show version number and exit."
  echo "  -w, --where <directory>         Look for tests in this directory."
  echo "  -v, --verbose                   Be more verbose."
  echo "  -q, --quiet                     Be less verbose."
  echo "      --with-coverage             Enable plugin coverage.sh."
  echo "      --cover-dir <directory>     Restrict coverage output to"
  echo "                                  selected directory."
}

unittest::version_message() {
  #
  # Shows version message.
  #
  # Globals:
  #     _VERSION_ - Version number.
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     String message to standard output.
  #
  echo "unittest.sh "${_VERSION_};
  echo
  echo "Copyright (c) 2014 Maciej Żok"
  echo "MIT License (http://opensource.org/licenses/MIT)"
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
  local "${@}"

  echo "Error: "${msg}"." 1>&2
}


#
#   FUNCTIONS
#

unittest::parse_args() {
  #
  # Parses script parameters.
  #
  # Globals:
  #     _COVERAGE (int) - Is coverage plugin enabled?
  #     _COVER_DIR (str) - Directory for coverage.
  #     _TEST_DIR (str) - Directory with tests.
  #     _VERBOSITY (int) - Verbosity level.
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
        unittest::help_message
        exit 0
        ;;

      -w|--where)
        if (($# > 1)); then
          _TEST_DIR=$2
          shift 2
        else
          unittest::error_message msg="no directory specified"
          exit 1
        fi
        ;;

      -V|--version|-\?)
        unittest::version_message
        exit 0
        ;;

      -v|--verbose)
        _VERBOSITY=2
        shift 2
        ;;

      -q|--quiet)
        _VERBOSITY=0
        shift 2
        ;;

      --with-coverage)
        _COVERAGE=1
        shift 2
        ;;

      --cover-dir)
        if [[ $# > 1 ]] && [[ ${_COVERAGE} == 1 ]]; then
          _COVER_DIR=$2
          shift 2
        else
          unittest::error_message msg="no directory specified
                                       or no coverage support enabled"
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
  #     _TEST_DIR (str) - Directory with tests.
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     testfiles (str) - Files with tests.
  #
  if [[ ${_TEST_DIR} == "" ]]; then
    _TEST_DIR=$(find $(pwd)/ -type d | grep "tests")
  fi

  testfiles=""
  for testdir in ${_TEST_DIR}; do
    testfiles=${testfiles}\n"$(find "${_TEST_DIR}" -name "test_*.sh")"
  done
}

unittest::start() {
  #
  # Runs instruction before all tests.
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     None
  #
  # Returns:
  #     start_time (str) - Start time of tests (in nanoseconds).
  #
  start_time="$(date +%s%N)"  # in nanoseconds
}

unittest::stop() {
  #
  # Runs instruction after all tests.
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     start_time (str) - Start time of tests (in nanoseconds).
  #     tests_number (str) - Number of tests.
  #
  # Returns:
  #     None.
  #
  local tests_number start_time
  local "${@}"

  local teststime=$(($(date +%s%N) - start_time))

  # FIXME: use printf
  echo "---------------------------------------------"
  echo "Ran "${tests_number}" tests in "${teststime}"s"
  echo

  echo "OK"
  echo "ERROR"
}

unittest::before_test() {
  #
  # Runs instruction before each test function.
  #
  # Globals:
  #     _VERBOSITY (int) - Verbosity level.
  #
  # Arguments:
  #     path (str) - Test file name.
  #     name (str) - Test function name.
  #
  # Returns:
  #     None.
  #
  local path name
  local "${@}"

  if [[ _VERBOSITY == 2 ]]; then
    echo -n ${name}" ("${path}") ... "
  fi

}

unittest::after_test() {
  #
  # Runs instruction after each test function.
  #
  # Globals:
  #     _VERBOSITY (int) - Verbosity level.
  #
  # Arguments:
  #     None.
  #
  # Returns:
  #     None.
  #

  _assert_reset

  if [[ _VERBOSITY == 1 ]]; then
    echo -n "."
    echo -n "E"
  elif [[ _VERBOSITY == 2 ]]; then
    echo "ok"
    echo "error"
  fi
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

  for testfile in $testfiles; do

    source testfile

    testfunctions=`grep -o "test_[^\(]*" ${testfile}`
    setUp=`grep -o "setUp" ${testfile}`
    tearDown=`grep -o "tearDown" ${testfile}`

    for testfunction in $testfunctions; do
      unittest::before_test name=${testfunction} path=${testfile}

      setUp
      testfunction
      tearDown

      unittest::after_test
    done
  done

  unittest::stop start_time=${start_time} tests_number=${tests_number}
}


#
#   MAIN ROUTINE
#

unittest::main () {
  unittest::parse_args "${@}"
  unittest::autodiscovery
  unittest::testrunner

  exit 0
}

unittest::main "${@}"
