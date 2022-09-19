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
    # prefix: utt9t_
    utt9t_color_default=''
    utt9t_color_location=''
    utt9t_color_status=''

    if [ -t 1 ] && [ -z "${NO_COLOR}" ]; then  # stdout is interactive terminal
        utt9t_color_default='\033[0m'
        case $2 in
            PASS)  # location: default; status: green
                utt9t_color_location='\033[0m'
                utt9t_color_status='\033[32m'
                ;;
            FAIL)  # location: red; status: white on red
                utt9t_color_location='\033[31m'
                utt9t_color_status='\033[97;41m'
                ;;
            SKIP)  # location: gray; status: gray
                utt9t_color_location='\033[90m'
                utt9t_color_status='\033[90m'
                ;;
        esac
    fi

    printf "${utt9t_color_location}%s\t${utt9t_color_status}%s${utt9t_color_default}\n" "$1" "$2"

    unset -v utt9t_color_default utt9t_color_location utt9t_color_status
    return 0
}

ut__test_debug_info() {
    # $1 - category
    # $2-... - paragraphs
    # prefix: utt13o_
    utt13o_color=''
    utt13o_color_default=''

    if [ -t 2 ] && [ -z "${NO_COLOR}" ]; then  # stderr is interactive terminal
        utt13o_color='\033[34m'  # blue
        utt13o_color_default='\033[0m'
    fi

    printf "\n${utt13o_color}-- %s${utt13o_color_default}\n\n" "$1" >&2

    shift 1
    for utt13o_paragraph in "$@"; do
        printf '%s\n\n' "${utt13o_paragraph}" >&2
    done

    unset -v utt13o_paragraph utt13o_color utt13o_color_default
    return 0
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
            ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
                "I expected 'test $*' to be true, but the result was false."
            UNITTEST_CURRENT_STATUS=1
            return 1
            ;;
        *)
            ut__test_debug_info "INVALID ASSERTION [${UNITTEST_CURRENT}]" \
                "I tried to check 'test $*', but I got error with message: '${UT4e1_test_error_msg}'. Did you use proper operator?" \
                "Hint: Some operators requires specific type of values. Read 'man test' to learn more."
            UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertEqual $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertNotEqual $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertTrue $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertFalse $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertRaises $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertGreater $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertGreaterEqual $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertLess $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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
    ut__test_debug_info "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertLessEqual $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
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

##
# Find test files inside given directory.
# Arguments:
#     1 (string) - Directory to search inside it.
# Outputs:
#     stdout - List of files.
#     stderr - (optional) Debug/error message.
# Exit Statuses:
#     0 - Successfully traversed all directories.
#    >0 - An error occurred.
##
ut__test_files() {
    # TODO: It works for reasonable number of files with tests. For very large number of test files
    #       it should use temporary file to store them.
    find "$1" -name 'test_*.sh' -print 2>/dev/null
    if [ $? -gt 0 ]; then
        ut__test_debug_info 'TESTS NOT FOUND' \
            "I was looking for 'test_*.sh' files inside '$1' directory using:" \
            "    $ find \"$1\" -name 'test_*.sh' -print" \
            'but I got error with message:' \
            "    $(find \"$1\" -name 'test_*.sh' -print 2>&1)"
        return 1
    fi

    return 0
}

##
# Find directory with tests inside given directory.
# Arguments:
#     1 (string) - Directory to search inside it.
# Outputs:
#     stdout - Directory with test files.
#     stderr - (optional) Debug/error message.
# Exit Statuses:
#     0 - Successfully traversed all directories.
#    >0 - An error occurred.
##
ut__test_directory() {
    find "$1" -type d -name 'tests' -print 2>/dev/null
    if [ $? -gt 0 ]; then
        ut__test_debug_info 'TESTS NOT FOUND' \
            "I was looking for 'tests' directory inside '$1' directory using:" \
            "    $ find \"$1\" -type d -name 'tests' -print" \
            'but I got error with message:' \
            "    $(find \"$1\" -type d -name 'tests' -print 2>&1)"
        return 1
    fi

    return 0
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
    _test_dir=$(ut__test_directory './')
  fi

  _test_files=$(ut__test_files "${_test_dir}")
}

ut__testrunner() {
    # prefix: utt8r_

    UNITTEST_STATUS=0
    for utt8r_testfile in ${_test_files}; do
        (
            utt8r_beforeAll=$(grep -o "^[ \t]*beforeAll" ${utt8r_testfile})
            utt8r_afterAll=$(grep -o "^[ \t]*afterAll" ${utt8r_testfile})
            utt8r_beforeEach=$(grep -o "^[ \t]*setUp" ${utt8r_testfile})
            utt8r_afterEach=$(grep -o "^[ \t]*tearDown" ${utt8r_testfile})
            utt8r_tests=$(grep -o "^[ \t]*test_[^\(]*" ${utt8r_testfile})

            . ${utt8r_testfile}
            ${utt8r_beforeAll}
            for _current_testcase in ${utt8r_tests}; do
                UNITTEST_CURRENT="${utt8r_testfile#./}:${_current_testcase}"
                UNITTEST_CURRENT_STATUS=0

                ${utt8r_beforeEach}
                ${_current_testcase}
                ${utt8r_afterEach}

                if [ ${UNITTEST_CURRENT_STATUS} -eq 0 ]; then
                    ut__test_result "${UNITTEST_CURRENT}" 'PASS'
                else
                    UNITTEST_STATUS=1
                    ut__test_result "${UNITTEST_CURRENT}" 'FAIL'
                fi
            done
            ${utt8r_afterAll}
            unset -v UNITTEST_CURRENT UNITTEST_CURRENT_STATUS
            exit ${UNITTEST_STATUS}
        )
        UNITTEST_STATUS=$?
    done
    return ${UNITTEST_STATUS}
}


#
#   MAIN ROUTINE
#

{
    # color output by default: on supported terminals when NO_COLOR is not set
    if [ -z "${NO_COLOR}" ] && [ $(tput colors) -lt 8 ]; then
        NO_COLOR='YES'
    fi
    ut__parse_args "$@"
    ut__autodiscovery
    ut__testrunner
    exit $?
}
