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

readonly UT_VERSION='0.1-dev'

readonly QUIET_VERBOSE=0
readonly NORMAL_VERBOSE=1
readonly DETAILED_VERBOSE=2


#
#   EXIT CODES
#

readonly EXIT_OK=0            # successful exit
readonly EXIT_FAIL=1          # general fail

readonly EXIT_USAGE=130       # command line usage error
readonly EXIT_CONFIG=131      # configuration error

readonly EXIT_IOERROR=140     # input/output error
readonly EXIT_NODIR=141       # directory not found
readonly EXIT_NOFILE=142      # cannot open file
readonly EXIT_NOFUNCTION=143  # function not found
readonly EXIT_NOPATTERN=144   # pattern not found


#
#   PORTABLE
#
#   insert here content of file: <ut_portabillity.sh>


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
