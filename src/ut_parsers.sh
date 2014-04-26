#!/bin/sh
#
# Parser functions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


ut_parser__parser() {
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
  ut_parser__parser "${ut_parser__filename}" "${ut_parser__source_pattern}"
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
  ut_parser__parser "${ut_parser__filename}" "${ut_parser__function_pattern}"
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
  ut_parser__parser "${ut_parser__filename}" "${ut_parser__function_pattern}"
}
