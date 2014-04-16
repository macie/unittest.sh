#!/bin/sh


#
#  assertEqual
#

test_assertEqual_equal_ints() {
  result=$(assertEqual 0 0)
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertEqual_unequal_ints() {
  result=$(assertEqual 0 1)
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertEqual_equal_str() {
  result=$(assertEqual "a" "a")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertEqual_unequal_str() {
  result=$(assertEqual "a" "A")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertEqual_int_and_str() {
  result=$(assertEqual 1 "a")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertEqual_int_and_empty_str() {
  result=$(assertEqual 0 "")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}


#
#  assertNotEqual
#

test_assertNotEqual_equal_ints() {
  result=$(assertNotEqual 0 0)
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertNotEqual_unequal_ints() {
  result=$(assertNotEqual 0 1)
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertNotEqual_equal_str() {
  result=$(assertNotEqual "a" "a")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertNotEqual_unequal_str() {
  result=$(assertNotEqual "a" "A")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertNotEqual_int_and_str() {
  result=$(assertNotEqual 1 "a")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertNotEqual_int_and_empty_str() {
  result=$(assertNotEqual 0 "")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}


#
#  assertTrue
#

test_assertTrue_empty_str() {
  result=$(assertTrue "")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertTrue_str() {
  result=$(assertTrue "test")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertTrue_zero() {
  result=$(assertTrue 0)
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertTrue_small_negative_int() {
  result=$(assertTrue -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertTrue_large_negative_int() {
  result=$(assertTrue -1000)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertTrue_small_positive_int() {
  result=$(assertTrue 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertTrue_large_positive_int() {
  result=$(assertTrue 1000)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}


#
#  assertFalse
#

test_assertFalse_empty_str() {
  result=$(assertFalse "")
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertFalse_str() {
  result=$(assertFalse "test")
  result=$?

  local expected=1  # fail

  assertRaises ${result} ${expected}
}

test_assertFalse_zero() {
  result=$(assertFalse 0)
  result=$?

  local expected=0  # pass

  assertRaises ${result} ${expected}
}

test_assertFalse_small_negative_int() {
  result=$(assertFalse -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertFalse_large_negative_int() {
  result=$(assertFalse -1000)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertFalse_small_positive_int() {
  result=$(assertFalse 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertFalse_large_positive_int() {
  result=$(assertFalse 1000)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}
