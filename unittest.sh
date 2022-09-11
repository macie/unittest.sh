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

_assert_failed=0
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

  if [ -z "${msg}" ]; then  # no specified message
    msg="unknown error"
  fi

  echo "Error: ${msg}." 1>&2
}

ut__test_result() {
    # Write test status message to stdout
    # $1 - test location
    # $2 - test status
    # prefix: UTfe0_
    if [ ! -t 1 ]; then  # standard output is not terminal
        printf '%s\t%s\n' "$1" "$2"
        return 0
    fi

    case $2 in
        PASS)  printf '%s\t\x1b[32m%s\x1b[0m\n' "$1" "$2" ;;     # default location; green status
        FAIL)  printf '\x1b[31m%s\t\x1b[97;41m%s\x1b[0m\n' "$1" "$2" ;;  # red location; white on red status
        SKIP)  printf '\x1b[90m%s\t%s\x1b[0b\n' "$1" "$2" ;;     # gray location and status
        *)     printf '%s\t%s\n' "$1" "$2" ;;
    esac
    return 0
}

ut__test_debug_info() {
    # $1 - category
    # $2-... - paragraphs
    # _current_testsuite
    # _current_testcase
    # prefix: UT1c0_
    if [ -t 2 ]; then
        printf '\n\x1b[34m-- %s [%s]\x1b[0m\n\n' "$1" "${_current_testsuite}:${_current_testcase}" >&2
    else  # stderr is not interactive terminal, so color is useless
        printf '-- %s [%s]\n\n' "$1" "${_current_testsuite}:${_current_testcase}" >&2
    fi
    shift 1
    for UT1c0_paragraph in "$@"; do
        printf '%s\n\n' "${UT1c0_paragraph}" >&2
    done
    unset -v UT1c0_paragraph
}

#
#   ASSERTIONS
#

test() {
    # same arguments as command test(1)
    UT4e1_test_error_msg=`/bin/test "$@" 2>&1`
    case $? in
        0)  ;;
        1)
            ut__test_debug_info 'FAILED TEST' \
                "I expected 'test $*' to be true, but the result was false."
            _assert_failed=1
            return 1
            ;;
        *)
            ut__test_debug_info 'INVALID ASSERTION' \
                "I tried to check 'test $*', but I got error with message: '${UT4e1_test_error_msg}'. Did you use proper operator?" \
                "Hint: Some operators requires specific type of values. Read 'man test' to learn more."
            _assert_failed=1
            return 1
            ;;
    esac

    return 0
}

assertEqual() {
  # assertEqual 0 0  => pass
  local result="$1"
  local expected="$2"

  if [ "${result}" = "${expected}" ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertEqual $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertNotEqual() {
  # assertNotEqual 0 1  => pass
  local result="$1"
  local expected="$2"

  if [ "${result}" != "${expected}" ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertNotEqual $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertTrue() {
  # assertTrue 1  => pass
  # assertTrue ""  => fail
  local result="$1"

  if [ "${result}" != "0" ] \
       && [ "${result}" ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertTrue $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertFalse() {
  # assertFalse 0  => pass
  # assertFalse ""  => pass
  local result="$1"

  if [ "${result}" = "0" ] \
      || [ ! "${result}" ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertFalse $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertRaises() {
  # assertRaises function 1
  local result="$1"
  local expected="$2"

  if [ -n "${expected}" ] \
      && [ "${result}" = "${expected}" ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertRaises $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertGreater() {
  local result=$1
  local expected=$2

  if [ -n "${result}" ] \
      && [ -n "${expected}" ] \
      && [ ${result} -eq ${result} 2> /dev/null ] \
      && [ ${expected} -eq ${expected} 2> /dev/null ] \
      && [ ${result} -gt ${expected} ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertGreater $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertGreaterEqual() {
  local result=$1
  local expected=$2

  if [ -n "${result}" ] \
      && [ -n "${expected}" ] \
      && [ ${result} -eq ${result} 2> /dev/null ] \
      && [ ${expected} -eq ${expected} 2> /dev/null ] \
      && [ ${result} -ge ${expected} ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertGreaterEqual $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertLess() {
  local result=$1
  local expected=$2

  if [ -n "${result}" ] \
      && [ -n "${expected}" ] \
      && [ ${result} -eq ${result} 2> /dev/null ] \
      && [ ${expected} -eq ${expected} 2> /dev/null ] \
      && [ ${result} -lt ${expected} ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertLess $*' to be true, but the result was false."
    _assert_failed=1
    return 1
  fi
}

assertLessEqual() {
  local result=$1
  local expected=$2

  if [ -n "${result}" ] \
      && [ -n "${expected}" ] \
      && [ ${result} -eq ${result} 2> /dev/null ] \
      && [ ${expected} -eq ${expected} 2> /dev/null ] \
      && [ ${result} -le ${expected} ]; then
    return 0
  else
    ut__test_debug_info 'FAILED TEST' \
        "I expected 'assertLessEqual $*' to be true, but the result was false."
    _assert_failed=1
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
  arg_num=$#
  for arg in "$@"; do
    case "${arg}" in
      -h|--help|-\?)
        ut__help_message
        exit 0
      ;;

      -w|--where)
        if [ ${arg_num} -gt 1 ]; then
          _test_dir="$2"
          shift 2
        else
          ut__error_message msg='no directory specified'
          exit 64  # command line usage error (via /usr/include/sysexits.h)
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
        if [ ${arg_num} -gt 1 ] \
            && [ ${_coverage} -eq 1 ]; then
          _cover_dir="$2"
          shift 2
        elif [ ${_coverage} -eq 0 ]; then
          ut__error_message msg='no coverage support enabled'
          exit 78  # configuration error (via /usr/include/sysexits.h)
        else
          ut__error_message msg='no directory specified'
          exit 64  # command line usage error (via /usr/include/sysexits.h)
        fi
      ;;

      -*)
        ut__error_message msg="invalid option: $1"
        exit 64  # command line usage error (via /usr/include/sysexits.h)
      ;;
    esac

    arg_num=$(( ${arg_num} - 1 ))
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
  if [ "${_test_dir}" = '' ]; then
    _test_dir=$(find $(pwd)/ -type d -name 'tests' -print)
  fi

  _test_files="$(find "${_test_dir}" -name 'test_*.sh')"
}

ut__testrunner() {
    # prefix: utt8r_

    utt8r_exit_code=0
    for utt8r_testfile in ${_test_files}; do
        _current_testsuite="${utt8r_testfile#"$(pwd)/"}"
        (
            utt8r_beforeEach=$(grep -o "^[ \t]*setUp" ${utt8r_testfile})
            utt8r_afterEach=$(grep -o "^[ \t]*tearDown" ${utt8r_testfile})
            utt8r_tests=$(grep -o "^[ \t]*test_[^\(]*" ${utt8r_testfile})

            utt8r_testsuite_exit_code=0

            . ${utt8r_testfile}
            for _current_testcase in ${utt8r_tests}; do
                _assert_failed=0

                ${utt8r_beforeEach}
                ${_current_testcase}
                ${utt8r_afterEach}

                if [ ${_assert_failed} -eq 0 ]; then
                    utt8r_test_status='PASS'
                else
                    utt8r_test_status='FAIL'
                    utt8r_testsuite_exit_code=1
                fi
                ut__test_result "${_current_testsuite}:${_current_testcase}" "${utt8r_test_status}"
            done

            exit ${utt8r_testsuite_exit_code}
        )
        utt8r_exit_code=$(( $? || ${utt8r_exit_code} ))
    done

    return ${utt8r_exit_code}
}


#
#   MAIN ROUTINE
#

{
  ut__parse_args "$@"
  ut__autodiscovery
  ut__testrunner
  exit $?
}
