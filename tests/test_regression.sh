#!/bin/sh

test_issue8() {
#shellcheck disable=SC2034,SC2116
test_var=$(echo 123)
}

test_issue11() {
    # unittest version message and tput errors are written to stderr
    test "$(TERM= ./unittest -v 2>&1 | wc -l)" -eq 1
}