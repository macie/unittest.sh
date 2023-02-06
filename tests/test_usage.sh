#!/bin/sh


test_invalid_params_msg() {
    result=$(./unittest --unknown params 2>&1 | grep '\--unknown params')

    test $? -eq 0 && test -n "${result}"
}
