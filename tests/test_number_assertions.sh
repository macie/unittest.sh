#!/bin/sh


test_equal_ints() {
    `test 11 -eq 11`

    test $? -eq 0
}

test_equal_ints_false() {
    `test 11 -eq 5 2>/dev/null`

    test $? -eq 1
}

test_equal_strings() {
    `test 'a' -eq 'a' 2>/dev/null`

    test $? -eq 1
}

test_equal_mixed() {
    `test 'a' -eq 1 2>/dev/null`

    test $? -eq 1
}

test_equal_mixed2() {
    `test 2 -eq 'b' 2>/dev/null`

    test $? -eq 1
}


test_notequal_ints() {
    `test 432 -ne 0`

    test $? -eq 0
}

test_notequal_ints_false() {
    `test 7 -ne 7 2>/dev/null`

    test $? -eq 1
}

test_notequal_strings() {
    `test 'a' -ne 'b' 2>/dev/null`

    test $? -eq 1
}

test_notequal_mixed() {
    `test 'a' -ne 1 2>/dev/null`

    test $? -eq 1
}

test_notequal_mixed2() {
    `test 2 -ne 'b' 2>/dev/null`

    test $? -eq 1
}


test_greaterthan_ints() {
    `test 432 -gt 0`

    test $? -eq 0
}

test_greaterthan_ints_false() {
    `test 7 -gt 7 2>/dev/null`

    test $? -eq 1
}

test_greaterthan_strings() {
    `test 'a' -gt 'b' 2>/dev/null`

    test $? -eq 1
}

test_greaterthan_mixed() {
    `test 'aa' -gt 1 2>/dev/null`

    test $? -eq 1
}

test_greaterthan_mixed2() {
    `test 2000 -gt 'b' 2>/dev/null`

    test $? -eq 1
}


test_greaterequal_ints() {
    `test 0 -ge -1`

    test $? -eq 0
}

test_greaterequal_ints_false() {
    `test 6 -ge 7 2>/dev/null`

    test $? -eq 1
}

test_greaterequal_strings() {
    `test 'a' -ge 'a' 2>/dev/null`

    test $? -eq 1
}

test_greaterequal_mixed() {
    `test 'a' -ge 1 2>/dev/null`

    test $? -eq 1
}

test_greaterequal_mixed2() {
    `test 2 -ge 'b' 2>/dev/null`

    test $? -eq 1
}


test_lessthan_ints() {
    `test -2 -lt -1`

    test $? -eq 0
}

test_lessthan_ints_false() {
    `test 7 -lt 7 2>/dev/null`

    test $? -eq 1
}

test_lessthan_strings() {
    `test 'a' -lt 'bb' 2>/dev/null`

    test $? -eq 1
}

test_lessthan_mixed() {
    `test 'a' -lt 100 2>/dev/null`

    test $? -eq 1
}

test_lessthan_mixed2() {
    `test -2 -lt 'b' 2>/dev/null`

    test $? -eq 1
}


test_lessequal_ints() {
    `test 0 -le 0`

    test $? -eq 0
}

test_lessequal_ints_false() {
    `test 7 -le 6 2>/dev/null`

    test $? -eq 1
}

test_lessequal_strings() {
    `test 'a' -le 'b' 2>/dev/null`

    test $? -eq 1
}

test_lessequal_mixed() {
    `test 'a' -le 1111 2>/dev/null`

    test $? -eq 1
}

test_lessequal_mixed2() {
    `test 2 -le 'zzz' 2>/dev/null`

    test $? -eq 1
}

