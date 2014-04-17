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


#
#  assertRaises
#

test_assertRaises_pass() {
  local func_return_code=0
  result=$(assertRaises ${func_return_code} 0)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertRaises_error() {
  local func_return_code=1
  result=$(assertRaises ${func_return_code} 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertRaises_empty_string() {
  result=$(assertRaises "" 0)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertRaises_string() {
  result=$(assertRaises "a" 0)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertRaises_two_empty_strings() {
  result=$(assertRaises "" "")
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}


#
#  assertGreater
#

test_assertGreater_positives() {
  result=$(assertGreater 1 0)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreater_positives_not_greater() {
  result=$(assertGreater 0 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_positives_equal() {
  result=$(assertGreater 1 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_negatives() {
  result=$(assertGreater -1 -2)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreater_negatives_not_greater() {
  result=$(assertGreater -2 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_negatives_equal() {
  result=$(assertGreater -1 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_mixed() {
  result=$(assertGreater 1 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreater_mixed_not_greater() {
  result=$(assertGreater -1 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_string() {
  result=$(assertGreater "a" -1)  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_than_string() {
  result=$(assertGreater 1 "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_two_strings() {
  result=$(assertGreater "a" "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreater_two_empty_strings() {
  result=$(assertGreater "" "")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

#
#  assertGreaterEqual
#

test_assertGreaterEqual_positives() {
  result=$(assertGreaterEqual 1 0)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_positives_not_greater() {
  result=$(assertGreaterEqual 0 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_positives_equal() {
  result=$(assertGreaterEqual 1 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_negatives() {
  result=$(assertGreaterEqual -1 -2)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_negatives_not_greater() {
  result=$(assertGreaterEqual -2 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_negatives_equal() {
  result=$(assertGreaterEqual -1 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_mixed() {
  result=$(assertGreaterEqual 1 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_mixed_not_greater() {
  result=$(assertGreaterEqual -1 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_string() {
  result=$(assertGreaterEqual "a" -1)  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_than_string() {
  result=$(assertGreaterEqual 1 "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_two_strings() {
  result=$(assertGreaterEqual "a" "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertGreaterEqual_two_empty_strings() {
  result=$(assertGreaterEqual "" "")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}


#
#  assertLess
#

test_assertLess_positives() {
  result=$(assertLess 0 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLess_positives_not_less() {
  result=$(assertLess 1 0)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_positives_equal() {
  result=$(assertLess 1 1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_negatives() {
  result=$(assertLess -2 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLess_negatives_not_less() {
  result=$(assertLess -1 -2)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_negatives_equal() {
  result=$(assertLess -1 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_mixed() {
  result=$(assertLess -1 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLess_mixed_not_less() {
  result=$(assertLess 1 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_string() {
  result=$(assertLess "a" 1)  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_than_string() {
  result=$(assertLess -1 "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_two_strings() {
  result=$(assertLess "a" "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLess_two_empty_strings() {
  result=$(assertLess "" "")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}


#
#  assertLessEqual
#

test_assertLessEqual_positives() {
  result=$(assertLessEqual 0 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLessEqual_positives_not_less() {
  result=$(assertLessEqual 1 0)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_positives_equal() {
  result=$(assertLessEqual 1 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLessEqual_negatives() {
  result=$(assertLessEqual -2 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLessEqual_negatives_not_less() {
  result=$(assertLessEqual -1 -2)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_negatives_equal() {
  result=$(assertLessEqual -1 -1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLessEqual_mixed() {
  result=$(assertLessEqual -1 1)
  result=$?

  local expected=0 # pass

  assertRaises ${result} ${expected}
}

test_assertLessEqual_mixed_not_less() {
  result=$(assertLessEqual 1 -1)
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_string() {
  result=$(assertLessEqual "a" 1)  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_than_string() {
  result=$(assertLessEqual -1 "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_two_strings() {
  result=$(assertLessEqual "a" "a")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}

test_assertLessEqual_two_empty_strings() {
  result=$(assertLessEqual "" "")  # (str => int) == 0
  result=$?

  local expected=1 # fail

  assertRaises ${result} ${expected}
}
