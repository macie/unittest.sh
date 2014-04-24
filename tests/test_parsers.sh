#!/bin/sh

# import tested script
#. "../unittest.sh"

setUp() {
  parser_testfile=$(mktemp -t "unittest.sh-parser-testfile-XXXXXX") || exit 1
  printf '%s' '
#!/usr/bin/env bash
. "${source_file}"
source ~/source/file

some_func() {
  return 0
}

test_some_func() {
  return 0
}

. "${not_parsed}"
 ' >> "${parser_testfile}"
}

tearDown() {
  rm -rf "${parser_testfile}"
}


#
#  ut_parser__parser
#

test_parser_no_params() {
  result_value=$(ut_parser__parser)
  result_retcode=$?

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
  assertRaises "${result_retcode}" "1"
}

test_parser_no_pattern() {
  result_value=$(ut_parser__parser "${parser_testfile}")
  result_retcode=$?

  expected_value=""

  assertEqual "${result_value}" "${expected_value}"
  assertRaises "${result_retcode}" "1"
}

test_parser_simple_pattern() {
  test_pattern="s/(test string)/\1/p"
  result_value=$(ut_parser__parser "${parser_testfile}" "${test_pattern}")
  result_retcode=$?

  expected_value="test string"

  assertEqual "${result_value}" "${expected_value}"
  assertRaises "${result_retcode}" "1"
}


#
#  ut_parser__find_source_files
#

test_find_source_files() {
  result_value=$(ut_parser__find_source_files "${parser_testfile}")
  result_retcode=$?

  expected_value='${source_file}:~/source/file'

  assertEqual "${result_value}" "${expected_value}"
  assertRaises "${result_retcode}" "1"
}


#
#  ut_parser__find_functions
#

test_find_functions() {
  result_value=$(ut_parser__find_functions "${parser_testfile}")
  result_retcode=$?

  expected_value='some_func:test_some_func'

  assertEqual "${result_value}" "${expected_value}"
  assertRaises "${result_retcode}" "1"
}
