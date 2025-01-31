#!/bin/sh
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

# shellcheck disable=SC2317
beforeAll() {
    find() {  # find mock
        case "$1" in
            'error')  echo "find mock returned error" >&2; return 1 ;;
            *)  printf '<mock:%s>' "$1"; return 0 ;;
        esac
    }
}

afterAll() {
    unset -f find
}

test_arg_empty() {
   result=$(unittest__test_files 2>&1)

   test $? -eq 0 && test "${result}" = '<mock:./>'  # default substition of first argument in implementation
}

test_arg_directory() {
   result=$(unittest__test_files 'some_dir/' 2>&1)

   test $? -eq 0 && test "${result}" = '<mock:some_dir/>'
}

test_args_directories() {
   result=$(unittest__test_files 'some_dir/' 'some_other_dir/' 2>&1)

   test $? -eq 0 && test "${result}" = '<mock:some_dir/><mock:some_other_dir/>'
}

test_arg_invalid_directory() {
   result=$(unittest__test_files 'error' 2>&1)

   test $? -eq 1 && test -n "${result}"
}

test_args_invalid_directory() {
   result=$(unittest__test_files 'some_dir/' 'error' 'some_other_dir/' 2>&1)

   test $? -eq 1 && test -n "${result}"
}

test_stdin_directory() {
   result=$(printf 'some_dir/\n' | unittest__test_files - 2>&1)

   test $? -eq 0 && test "${result}" = '<mock:some_dir/>'
}

test_stdin_directories() {
   result=$(printf 'some_dir/\nsome_other_dir/\n' | unittest__test_files - 2>&1)

   test $? -eq 0 && test "${result}" = '<mock:some_dir/><mock:some_other_dir/>'
}

test_stdin_invalid_directory() {
   result=$(printf 'some_dir/\nerror\nsome_other_dir/\n' | unittest__test_files - 2>&1)

   test $? -eq 1 && test -n "${result}"
}

