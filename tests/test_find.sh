#!/bin/sh

beforeAll() {
    find() {  # find mock
        case "$1" in
            'error')  echo "$1" >&2; return 1 ;;
            *)  echo $1; return 0 ;;
        esac
    }
}

afterAll() {
    unset -f find
}

test_tests_directory() {
   result=$(unittest__test_files 'some_dir/' 2>&1)

   test $? -eq 0
   test "${result}" = 'some_dir/'
}

test_invalid_tests_directory() {
   result=$(unittest__test_files 'error' 2>&1)

   test $? -eq 1
   test -n "${result}"
}

