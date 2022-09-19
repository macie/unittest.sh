#!/bin/sh

beforeAll() {
    . ../unittest.sh
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
   result=$(ut__test_directory './' 2>&1)

   test $? -eq 0
   test "${result}" = './'
}

test_invalid_tests_directory() {
   result=$(ut__test_directory 'error' 2>&1)

   test $? -eq 1
   test -n "${result}"
}

test_test_files() {
   result=$(ut__test_files 'test_*.sh' 2>&1)

   test $? -eq 0
   test "${result}" = 'test_*.sh'
}

test_invalid_test_files() {
   result=$(ut__test_files 'error' 2>&1)

   test $? -eq 1
   test -n "${result}"
}
