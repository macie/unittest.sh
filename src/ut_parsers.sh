#!/bin/sh
#
# Parser functions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


ut_parser__file_parser() {
  #
  # Finds something in file.
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     $1 (str) - Filename.
  #     $2 (str) - Pattern in sed format.
  #
  # Returns:
  #     String with matched values splited with colons.
  #
  ut_parser__filename=$1
  ut_parser__function_pattern=$2

  if [ ! -e "${ut_parser__filename}" ]; then
    # no file error
    return 1
  elif [ -z "${ut_parser__function_pattern}" ]; then
    # no pattern error
    return 1
  else
    original_IFS="${IFS}"
    IFS=:
    ut_parser__functions=$(sed -n "${ut_parser__function_pattern}" \
                                  "${ut_parser__filename}")
    IFS="${original_IFS}"

    # return
    printf '%s' "${ut_parser__functions}"
  fi
}

ut_parser__find_source_files() {
  #
  # Finds source files.
  #
  # Uses following regex pattern:
  #    s/                <- substitute matched string with... (see: last line)
  #    [ \t]*            <- zero or more spaces/tabs
  #    \(\.\|source\)    <- dot (POSIX shell) or source keyword (modern shells)
  #    [ \t][ \t]*       <- one or more spaces/tabs (Kleene plus substitute)
  #    \([^\s\|^\;]+\)*  <- wanted filename
  #    /\2/p             <- print filename only
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     $1 (str) - Filename.
  #
  # Returns:
  #     String with source files paths splited with colons.
  #
  ut_parser__filename=$1
  ut_parser__source_pattern="s/[ \t]*\(\.\|source\)[ \t][ \t]*\([^\s\|^\;]+\)*/\2/p"

  # return
  ut_parser__file_parser "${ut_parser__filename}" \
                         "${ut_parser__source_pattern}"
}

ut_parser__find_functions() {
  #
  # Finds functions in file.
  #
  # Uses following regex pattern:
  #    s/        <- substitute matched string with... (see: last line)
  #    [ \n\t]*  <- zero or more whitespaces
  #    \(\w+\)   <- function name
  #    [ \t]*    <- zero or more spaces/tabs
  #    (         <- parenthesis
  #    /\1/p     <- print function names only
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     $1 (str) - Filename.
  #
  # Returns:
  #     String with functions names splited with colons.
  #
  ut_parser__filename=$1
  ut_parser__function_pattern="s/[ \n\t]*\(\w+\)[ \t]*(/\1/p"

  # return
  ut_parser__file_parser "${ut_parser__filename}" \
                         "${ut_parser__function_pattern}"
}

ut_parser__find_test_functions() {
  #
  # Finds test functions in file.
  #
  # Uses following regex pattern:
  #    s/        <- substitute matched string with... (see: last line)
  #    [ \n\t]*  <- zero or more whitespaces
  #    \(\w+\)   <- function name
  #    [ \t]*    <- zero or more spaces/tabs
  #    (         <- parenthesis
  #    /\1/p     <- print function names only
  #
  # Globals:
  #     None
  #
  # Arguments:
  #     $1 (str) - Filename.
  #
  # Returns:
  #     String with functions names splited with colons.
  #
  ut_parser__filename=$1
  ut_parser__function_pattern="s/[ \n\t]*\(test_\w+\)[ \t]*(/\1/p"

  # return
  ut_parser__file_parser "${ut_parser__filename}" \
                         "${ut_parser__function_pattern}"
}

ut_parser__program_args() {
  #
  # Parses script parameters.
  #
  # Prefix for local variables:
  #     ut1e1__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     params (str) - Script params.
  #
  # Returns:
  #     String message or nothing.
  #
  ut1e1__arg_num=$#
  for ut1e1__arg in "$@"; do
    case "${ut1e1__arg}" in
      -h|--help|-\?)
        ut_msg__help_message
        exit 0
      ;;

      -w|--where)
        if [ "${ut1e1__arg_num}" -gt 1 ]; then
          ut1e1__source="$2"
          shift 2
        else
          ut_msg__error_message 'no directory specified'
          exit 64  # command line usage error (via /usr/include/sysexits.h)
        fi
      ;;

      -V|--version|-\?)
        ut__version_message "${UNITTEST_SH_VERSION}"
        exit 0
      ;;

      -v|--verbose)
        ut1e1__verb=2
        shift 1
      ;;

      -q|--quiet)
        ut1e1__verb=0
        shift 1
      ;;

      --with-coverage)
        ut1e1__cover=1
        shift 1
      ;;

      --cover-dir)
        if [ "${ut1e1__arg_num}" -gt 1 ] \
            && [ "${ut1e1__cover}" -eq 1 ]; then
          ut1e1__cover_dir="$2"
          shift 2
        elif [ ${ut1e1__cover} -eq 0 ]; then
          ut_msg__error_message 'no coverage support enabled'
          exit 78  # configuration error (via /usr/include/sysexits.h)
        else
          ut_msg__error_message 'no directory specified'
          exit 64  # command line usage error (via /usr/include/sysexits.h)
        fi
      ;;

      -*)
        ut_msg__error_message "invalid option: $1"
        exit 64  # command line usage error (via /usr/include/sysexits.h)
      ;;
    esac

    ut1e1__arg_num=$(( ut1e1__arg_num - 1 ))
  done

  ut1e1__settings="verb=${ut1e1__verb}"
#  ut1e1__settings="${ut1e1__settings}:cover=${ut1e1__cover}"
#  ut1e1__settings="${ut1e1__settings}:cover_dir=${ut1e1__cover_dir}"
  ut1e1__settings="${ut1e1__settings}:test_source=${ut1e1__source}"

  printf '%s\\n' "${ut1e1__settings}"
}
