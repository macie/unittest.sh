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


#
#   MESSAGES
#

unittest__print_result() {
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
                utt9t_color_location='\033[37m'
                utt9t_color_status='\033[37m'
                ;;
        esac
    fi

    printf "${utt9t_color_location}%s\t${utt9t_color_status}%s${utt9t_color_default}\n" "$1" "$2"

    unset -v utt9t_color_default utt9t_color_location utt9t_color_status
    return 0
}

unittest__print_debug() {
    # $1 - category
    # $2-... - paragraphs
    # prefix: utt13o_
    utt13o_color=''
    utt13o_color_default=''

    if [ -t 2 ] && [ -z "${NO_COLOR}" ]; then  # stderr is interactive terminal
        utt13o_color='\033[34m'  # blue
        utt13o_color_default='\033[0m'
        utt13o_color_quote='\033[37m'  # gray
    fi

    printf "\n${utt13o_color}-- %s${utt13o_color_default}\n\n" "$1" >&2

    shift 1
    for utt13o_paragraph in "$@"; do
        case ${utt13o_paragraph} in
            ' '*) printf "${utt13o_color_quote}" >&2 ;;
            *)  ;;
        esac
        printf "%s${utt13o_color_default}\n\n" "${utt13o_paragraph}" >&2
    done

    unset -v utt13o_paragraph utt13o_color utt13o_color_default
    return 0
}

#
#   ASSERTIONS
#

test() {
    # same arguments as command test(1)
    UT4e1_test_error_msg=$(/bin/test "$@" 2>&1)
    case $? in
        0)  ;;
        1)
            unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
                'I expected:' \
                "    test$(printf " '%s'" "$@")" \
                'to be true, but the result was false.'
            UNITTEST_CURRENT_STATUS=1
            return 1
            ;;
        *)
            unittest__print_debug "INVALID ASSERTION [${UNITTEST_CURRENT}]" \
                'I tried to check' \
                "    test$(printf " '%s'" "$@")" \
                'but I got error with message:' \
                "    ${UT4e1_test_error_msg}" \
                'Did you use proper operator?' \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
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
    unittest__print_debug "FAILED TEST [${UNITTEST_CURRENT}]" \
        "I expected 'assertLessEqual $*' to be true, but the result was false."
    UNITTEST_CURRENT_STATUS=1
    return 1
  fi
}


#
#   FUNCTIONS
#

unittest__parse_args() {
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
        cat >&2 <<-'EOF'
		unittest.sh - unit tests framework for shell scripts.
		Usage:
		  unittest.sh [options] [filename]
		
		Options:
		  -h, --help                      Show this help and exit.
		  -V, --version                   Show version number and exit.
		  -w, --where <directory>         Look for tests in this directory.
		  -v, --verbose                   Be more verbose.
		  -q, --quiet                     Be less verbose.
		      --with-coverage             Enable plugin coverage.sh.
		      --cover-dir <directory>     Restrict coverage output to
		                                  selected directory.
	EOF
        exit 0
      ;;

      -w|--where)
        if [ ${arg_num} -gt 1 ]; then
          _test_dir="$2"
          shift 2
        else
          unittest__print_debug 'INVALID USAGE' \
            "When using flag '${arg}' you need to specify directory."
          exit 64  # command line usage error (via /usr/include/sysexits.h)
        fi
      ;;

      -V|--version)
        cat >&2 <<-EOF
		unittest.sh ${_version_}
		
		Copyright (c) 2014 Maciej Żok
		MIT License (http://opensource.org/licenses/MIT)
	EOF
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
          unittest__print_debug 'INVALID USAGE' \
            "Flag '${arg}' need to be used after flag '--with-coverage'." \
            'Hint: Find valid usage with:' \
            '    $ unittest.sh -h'
          exit 78  # configuration error (via /usr/include/sysexits.h)
        else
          unittest__print_debug 'INVALID USAGE' \
            "When using flag '${arg}' you need to specify directory."
          exit 64  # command line usage error (via /usr/include/sysexits.h)
        fi
      ;;

      -*)
        unittest__print_debug 'INVALID USAGE' \
          "I don't recognize '$1' option. Did you wanted to use option or misspelled file/directory?" \
          'Hint: Find valid usage with:' \
          '    $ unittest.sh -h'
        exit 64  # command line usage error (via /usr/include/sysexits.h)
      ;;
    esac

    arg_num=$(( ${arg_num} - 1 ))
  done
}

##
# Find files with tests (test_*.sh).
# SYNOPSIS:
#     unittest__test_files [directory...]
# OPERANDS:
#     directory - A pathname of directory to search in. If no directory is
#         given, it will look for 'tests' directory inside current one. If
#         a directory is '-', it will use stdin.
# STDIN:
#     (optional) List of directories to search in. Used when call with '-' argument.
# STDOUT:
#     List of 'test_*.sh' file paths.
# STDERR:
#     (optional) Debug/error message.
# EXIT STATUS:
#     0 - Successfully traversed all directories.
#    >0 - An error occurred.
# EXAMPLES:
#     unittest__test_files ./unit_tests ./integration_tests
#     ls ../ | unittest__test_files -
# CAVEATS:
#     Calling it inside pipeline without '-' will disregards standard input and
#     use defaults instead.
unittest__test_files() {
    {
        if [ "$1" = '-' ]; then
            cat -
        else
            printf '%s\n' "$@"
        fi
     } |
     while read -r unittest_dir; do
         find "${unittest_dir:-./}" -path "*${unittest_dir:-tests/}*" -name 'test_*.sh' 2>/dev/null
         if [ $? -gt 0 ]; then
             unittest__print_debug 'TESTS NOT FOUND' \
                 "I was looking for 'test_*.sh' files inside '${unittest_dir:-tests/}' directory using:" \
                 "    $ find \"${unittest_dir:-./}\" -path \"*${unittest_dir:-tests/}*\" -name 'test_*.sh' -print" \
                 'but instead of files I got an error with message:' \
                 "    $(find "${unittest_dir:-./}" -path "*${unittest_dir:-tests/}*" -name 'test_*.sh' -print 2>&1)"
             unset -v unittest_dir
             return 1
         fi
         unset -v unittest_dir
     done

     return $?
}

##
# Run tests from given files.
# STDIN: List of files.
# STDOUT: Test name with status.
# STDERR: (optional) Debug/error message.
# EXIT STATUS:
#     0 - All tests passed.
#    >0 - Some tests failed.
##
unittest__run() {
    # prefix: utt8r_

    UNITTEST_STATUS=0
    for utt8r_testfile in $(cat -); do
        (
            utt8r_beforeAll=$(sed -n 's/^[ \t]*\(beforeAll\)[ \t]*(.*/\1/p' ${utt8r_testfile})
            utt8r_afterAll=$(sed -n 's/^[ \t]*\(afterAll\)[ \t]*(.*/\1/p' ${utt8r_testfile})
            utt8r_beforeEach=$(sed -n -e 's/^[ \t]*\(beforeEach\)[ \t]*(.*/\1/p' -e 's/^[ \t]*\(setUp\)[ \t]*(.*/\1/p' ${utt8r_testfile})
            utt8r_afterEach=$(sed -n -e 's/^[ \t]*\(afterEach\)[ \t]*(.*/\1/p' -e 's/^[ \t]*\(tearDown\)[ \t]*(.*/\1/p' ${utt8r_testfile})
            utt8r_tests=$(sed -n 's/^[ \t]*\(x\{0,1\}test_[^(]*\)(.*/\1/p' ${utt8r_testfile})

            . ${utt8r_testfile}
            ${utt8r_beforeAll}
            for _current_testcase in ${utt8r_tests}; do
                UNITTEST_CURRENT="${utt8r_testfile#./}:${_current_testcase}"
                UNITTEST_CURRENT_STATUS=0

                case ${_current_testcase} in
                    x*)
                        unittest__print_result "${UNITTEST_CURRENT}" 'SKIP'
                        ;;
                    *)
                        ${utt8r_beforeEach}
                        # test result is status of last command in test
                        if ${_current_testcase}; then
                            if [ ${UNITTEST_CURRENT_STATUS} -ne 0 ]; then
                                # legacy undocumented behavior: assertions could exist
                                # in the middle of test
                                unittest__print_result "${UNITTEST_CURRENT}" 'FAIL'
                            else
                                unittest__print_result "${UNITTEST_CURRENT}" 'PASS'
                            fi
                        else
                            # last command in test failed
                            UNITTEST_STATUS=1
                            unittest__print_result "${UNITTEST_CURRENT}" 'FAIL'
                        fi
                        ${utt8r_afterEach}
                        ;;
                esac
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
    unittest__parse_args "$@"
    echo "${_test_dir}" | unittest__test_files - | unittest__run
    exit $?
}
