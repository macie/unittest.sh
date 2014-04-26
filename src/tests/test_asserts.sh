#!/bin/sh

# import tested script
. "../unittest.sh"

#
#  assertEqual
#

test_assertEqual_equal_ints() {
  result_value=$(ut_assert__assertEqual 0 0)
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertEqual_unequal_ints() {
  result_value=$(ut_assert__assertEqual 0 1)
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertEqual_equal_str() {
  result_value=$(ut_assert__assertEqual "a" "a")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertEqual_unequal_str() {
  result_value=$(ut_assert__assertEqual "a" "A")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertEqual_int_and_str() {
  result_value=$(ut_assert__assertEqual 1 "a")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertEqual_int_and_empty_str() {
  result_value=$(ut_assert__assertEqual 0 "")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}


#
#  assertNotEqual
#

test_assertNotEqual_equal_ints() {
  result_value=$(ut_assert__assertNotEqual 0 0)
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertNotEqual_unequal_ints() {
  result_value=$(ut_assert__assertNotEqual 0 1)
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertNotEqual_equal_str() {
  result_value=$(ut_assert__assertNotEqual "a" "a")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertNotEqual_unequal_str() {
  result_value=$(ut_assert__assertNotEqual "a" "A")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertNotEqual_int_and_str() {
  result_value=$(ut_assert__assertNotEqual 1 "a")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertNotEqual_int_and_empty_str() {
  result_value=$(ut_assert__assertNotEqual 0 "")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}


#
#  assertTrue
#

test_assertTrue_empty_str() {
  result_value=$(ut_assert__assertTrue "")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_str() {
  result_value=$(ut_assert__assertTrue "test")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_zero() {
  result_value=$(ut_assert__assertTrue 0)
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_small_negative_int() {
  result_value=$(ut_assert__assertTrue -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_large_negative_int() {
  result_value=$(ut_assert__assertTrue -1000)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_small_positive_int() {
  result_value=$(ut_assert__assertTrue 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertTrue_large_positive_int() {
  result_value=$(ut_assert__assertTrue 1000)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}


#
#  assertFalse
#

test_assertFalse_empty_str() {
  result_value=$(ut_assert__assertFalse "")
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_str() {
  result_value=$(ut_assert__assertFalse "test")
  result_value=$?

  expected_value=1  # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_zero() {
  result_value=$(ut_assert__assertFalse 0)
  result_value=$?

  expected_value=0  # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_small_negative_int() {
  result_value=$(ut_assert__assertFalse -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_large_negative_int() {
  result_value=$(ut_assert__assertFalse -1000)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_small_positive_int() {
  result_value=$(ut_assert__assertFalse 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertFalse_large_positive_int() {
  result_value=$(ut_assert__assertFalse 1000)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}


#
#  assertRaises
#

test_assertRaises_pass() {
  func_return_code=0
  result_value=$(ut_assert__assertRaises ${func_return_code} 0)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertRaises_error() {
  func_return_code=1
  result_value=$(ut_assert__assertRaises ${func_return_code} 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertRaises_empty_string() {
  result_value=$(ut_assert__assertRaises "" 0)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertRaises_string() {
  result_value=$(ut_assert__assertRaises "a" 0)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertRaises_two_empty_strings() {
  result_value=$(ut_assert__assertRaises "" "")
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}


#
#  assertGreater
#

test_assertGreater_positives() {
  result_value=$(ut_assert__assertGreater 1 0)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_positives_not_greater() {
  result_value=$(ut_assert__assertGreater 0 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_positives_equal() {
  result_value=$(ut_assert__assertGreater 1 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_negatives() {
  result_value=$(ut_assert__assertGreater -1 -2)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_negatives_not_greater() {
  result_value=$(ut_assert__assertGreater -2 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_negatives_equal() {
  result_value=$(ut_assert__assertGreater -1 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_mixed() {
  result_value=$(ut_assert__assertGreater 1 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_mixed_not_greater() {
  result_value=$(ut_assert__assertGreater -1 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_string() {
  result_value=$(ut_assert__assertGreater "a" -1)  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_than_string() {
  result_value=$(ut_assert__assertGreater 1 "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_two_strings() {
  result_value=$(ut_assert__assertGreater "a" "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreater_two_empty_strings() {
  result_value=$(ut_assert__assertGreater "" "")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

#
#  assertGreaterEqual
#

test_assertGreaterEqual_positives() {
  result_value=$(ut_assert__assertGreaterEqual 1 0)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_positives_not_greater() {
  result_value=$(ut_assert__assertGreaterEqual 0 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_positives_equal() {
  result_value=$(ut_assert__assertGreaterEqual 1 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_negatives() {
  result_value=$(ut_assert__assertGreaterEqual -1 -2)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_negatives_not_greater() {
  result_value=$(ut_assert__assertGreaterEqual -2 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_negatives_equal() {
  result_value=$(ut_assert__assertGreaterEqual -1 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_mixed() {
  result_value=$(ut_assert__assertGreaterEqual 1 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_mixed_not_greater() {
  result_value=$(ut_assert__assertGreaterEqual -1 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_string() {
  result_value=$(ut_assert__assertGreaterEqual "a" -1)  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_than_string() {
  result_value=$(ut_assert__assertGreaterEqual 1 "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_two_strings() {
  result_value=$(ut_assert__assertGreaterEqual "a" "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertGreaterEqual_two_empty_strings() {
  result_value=$(ut_assert__assertGreaterEqual "" "")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}


#
#  assertLess
#

test_assertLess_positives() {
  result_value=$(ut_assert__assertLess 0 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_positives_not_less() {
  result_value=$(ut_assert__assertLess 1 0)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_positives_equal() {
  result_value=$(ut_assert__assertLess 1 1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_negatives() {
  result_value=$(ut_assert__assertLess -2 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_negatives_not_less() {
  result_value=$(ut_assert__assertLess -1 -2)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_negatives_equal() {
  result_value=$(ut_assert__assertLess -1 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_mixed() {
  result_value=$(ut_assert__assertLess -1 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_mixed_not_less() {
  result_value=$(ut_assert__assertLess 1 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_string() {
  result_value=$(ut_assert__assertLess "a" 1)  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_than_string() {
  result_value=$(ut_assert__assertLess -1 "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_two_strings() {
  result_value=$(ut_assert__assertLess "a" "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLess_two_empty_strings() {
  result_value=$(ut_assert__assertLess "" "")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}


#
#  assertLessEqual
#

test_assertLessEqual_positives() {
  result_value=$(ut_assert__assertLessEqual 0 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_positives_not_less() {
  result_value=$(ut_assert__assertLessEqual 1 0)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_positives_equal() {
  result_value=$(ut_assert__assertLessEqual 1 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_negatives() {
  result_value=$(ut_assert__assertLessEqual -2 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_negatives_not_less() {
  result_value=$(ut_assert__assertLessEqual -1 -2)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_negatives_equal() {
  result_value=$(ut_assert__assertLessEqual -1 -1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_mixed() {
  result_value=$(ut_assert__assertLessEqual -1 1)
  result_value=$?

  expected_value=0 # pass

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_mixed_not_less() {
  result_value=$(ut_assert__assertLessEqual 1 -1)
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_string() {
  result_value=$(ut_assert__assertLessEqual "a" 1)  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_than_string() {
  result_value=$(ut_assert__assertLessEqual -1 "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_two_strings() {
  result_value=$(ut_assert__assertLessEqual "a" "a")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}

test_assertLessEqual_two_empty_strings() {
  result_value=$(ut_assert__assertLessEqual "" "")  # (str => int) == 0
  result_value=$?

  expected_value=1 # fail

  assertRaises ${result_value} ${expected_value}
}
