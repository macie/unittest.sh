#!/bin/sh


test_same_strings() {
    `test 'abc' = 'abc'`

    test $? -eq 0
}

test_same_strings_false() {
    `test 'abc' = 'abb'`

    test $? -eq 1
}

test_same_strings_mixed() {
    `test '1' = 1`

    test $? -eq 0
}

test_same_strings_mixed2() {
    `test 1 = '1'`

    test $? -eq 0
}

test_same_strings_ints() {
    `test 123 = 123`

    test $? -eq 0
}


test_different_strings() {
    `test 'a' != 'b'`

    test $? -eq 0
}

test_different_strings_false() {
    `test 'a' != 'a'`

    test $? -eq 1
}

test_different_strings_mixed() {
    `test 'a' != 32`

    test $? -eq 0
}

test_different_strings_mixed2() {
    `test 32 != '2'`

    test $? -eq 0
}

test_different_strings_ints() {
    `test 123 != 124`

    test $? -eq 0
}


test_empty_string() {
    `test -z ''`

    test $? -eq 0
}

test_empty_string_false() {
    `test -z ' '`

    test $? -eq 1
}

test_empty_int() {
    `test -z 0`

    test $? -eq 1
}


test_nonempty_string() {
    `test -n ' '`

    test $? -eq 0
}

test_nonempty_string_false() {
    `test -n ''`

    test $? -eq 1
}

test_nonempty_int() {
    `test -n 0`

    test $? -eq 0
}


test_notnull_string() {
    `test ' '`

    test $? -eq 0
}

test_notnull_string_false() {
    `test ''`

    test $? -eq 1
}

test_notnull_int() {
    `test 1`

    test $? -eq 0
}

