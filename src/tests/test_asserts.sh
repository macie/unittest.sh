#!/bin/sh
#
# Tests for ut_assertions.
#

# import tested script
. "../ut_assertions.sh"


#
#  assertEqual
#

test_assertEqual_equal_ints() {
  tested_command='ut_assert__assertEqual 0 0'

  assertRaises "${tested_command}"
}

test_assertEqual_unequal_ints() {
  tested_command='ut_assert__assertEqual 0 1'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertEqual_equal_str() {
  tested_command='ut_assert__assertEqual "a" "a"'

  assertRaises "${tested_command}"
}

test_assertEqual_unequal_str() {
  tested_command='ut_assert__assertEqual "a" "A"'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertEqual_int_and_str() {
  tested_command='ut_assert__assertEqual 1 "a"'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertEqual_int_and_empty_str() {
  tested_command='ut_assert__assertEqual 0 ""'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertNotEqual
#

test_assertNotEqual_equal_ints() {
  tested_command='ut_assert__assertNotEqual 0 0'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertNotEqual_unequal_ints() {
  tested_command='ut_assert__assertNotEqual 0 1'

  assertRaises "${tested_command}"
}

test_assertNotEqual_equal_str() {
  tested_command='ut_assert__assertNotEqual "a" "a"'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertNotEqual_unequal_str() {
  tested_command='ut_assert__assertNotEqual "a" "A"'

  assertRaises "${tested_command}"
}

test_assertNotEqual_int_and_str() {
  tested_command='ut_assert__assertNotEqual 1 "a"'

  assertRaises "${tested_command}"
}

test_assertNotEqual_int_and_empty_str() {
  tested_command='ut_assert__assertNotEqual 0 ""'

  assertRaises "${tested_command}"
}


#
#  assertTrue
#

test_assertTrue_empty_str() {
  tested_command='ut_assert__assertTrue ""'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertTrue_str() {
  tested_command='ut_assert__assertTrue "test"'

  assertRaises "${tested_command}"
}

test_assertTrue_zero() {
  tested_command='ut_assert__assertTrue 0'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertTrue_small_negative_int() {
  tested_command='ut_assert__assertTrue -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertTrue_large_negative_int() {
  tested_command='ut_assert__assertTrue -1000'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertTrue_small_positive_int() {
  tested_command='ut_assert__assertTrue 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertTrue_large_positive_int() {
  tested_command='ut_assert__assertTrue 1000'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertFalse
#

test_assertFalse_empty_str() {
  tested_command='ut_assert__assertFalse ""'

  assertRaises "${tested_command}"
}

test_assertFalse_str() {
  tested_command='ut_assert__assertFalse "test"'

  expected_retcode=1  # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertFalse_zero() {
  tested_command='ut_assert__assertFalse 0'

  assertRaises "${tested_command}"
}

test_assertFalse_small_negative_int() {
  tested_command='ut_assert__assertFalse -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertFalse_large_negative_int() {
  tested_command='ut_assert__assertFalse -1000'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertFalse_small_positive_int() {
  tested_command='ut_assert__assertFalse 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertFalse_large_positive_int() {
  tested_command='ut_assert__assertFalse 1000'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertRaises
#

test_assertRaises_pass() {
  tested_command='ut_assert__assertRaises true'

  assertRaises "${tested_command}"
}

test_assertRaises_error() {
  tested_command='ut_assert__assertRaises false'

  assertRaises "${tested_command}"
}

test_assertRaises_empty() {
  tested_command='ut_assert__assertRaises'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertRaises_empty_string() {
  tested_command='ut_assert__assertRaises ""'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertRaises_string() {
  tested_command='ut_assert__assertRaises "some test string"'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertRaises_two_empty_strings() {
  tested_command='ut_assert__assertRaises "" ""'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertGreater
#

test_assertGreater_positives() {
  tested_command='ut_assert__assertGreater 1 0'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_positives_not_greater() {
  tested_command='ut_assert__assertGreater 0 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_positives_equal() {
  tested_command='ut_assert__assertGreater 1 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_negatives() {
  tested_command='ut_assert__assertGreater -1 -2'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_negatives_not_greater() {
  tested_command='ut_assert__assertGreater -2 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_negatives_equal() {
  tested_command='ut_assert__assertGreater -1 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_mixed() {
  tested_command='ut_assert__assertGreater 1 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_mixed_not_greater() {
  tested_command='ut_assert__assertGreater -1 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_string() {
  tested_command='ut_assert__assertGreater "a" -1'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_than_string() {
  tested_command='ut_assert__assertGreater 1 "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_two_strings() {
  tested_command='ut_assert__assertGreater "a" "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreater_two_empty_strings() {
  tested_command='ut_assert__assertGreater "" ""'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

#
#  assertGreaterEqual
#

test_assertGreaterEqual_positives() {
  tested_command='ut_assert__assertGreaterEqual 1 0'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_positives_not_greater() {
  tested_command='ut_assert__assertGreaterEqual 0 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_positives_equal() {
  tested_command='ut_assert__assertGreaterEqual 1 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_negatives() {
  tested_command='ut_assert__assertGreaterEqual -1 -2'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_negatives_not_greater() {
  tested_command='ut_assert__assertGreaterEqual -2 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_negatives_equal() {
  tested_command='ut_assert__assertGreaterEqual -1 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_mixed() {
  tested_command='ut_assert__assertGreaterEqual 1 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_mixed_not_greater() {
  tested_command='ut_assert__assertGreaterEqual -1 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_string() {
  tested_command='ut_assert__assertGreaterEqual "a" -1'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_than_string() {
  tested_command='ut_assert__assertGreaterEqual 1 "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_two_strings() {
  tested_command='ut_assert__assertGreaterEqual "a" "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertGreaterEqual_two_empty_strings() {
  tested_command='ut_assert__assertGreaterEqual "" ""'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertLess
#

test_assertLess_positives() {
  tested_command='ut_assert__assertLess 0 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_positives_not_less() {
  tested_command='ut_assert__assertLess 1 0'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_positives_equal() {
  tested_command='ut_assert__assertLess 1 1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_negatives() {
  tested_command='ut_assert__assertLess -2 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_negatives_not_less() {
  tested_command='ut_assert__assertLess -1 -2'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_negatives_equal() {
  tested_command='ut_assert__assertLess -1 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_mixed() {
  tested_command='ut_assert__assertLess -1 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_mixed_not_less() {
  tested_command='ut_assert__assertLess 1 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_string() {
  tested_command='ut_assert__assertLess "a" 1'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_than_string() {
  tested_command='ut_assert__assertLess -1 "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_two_strings() {
  tested_command='ut_assert__assertLess "a" "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLess_two_empty_strings() {
  tested_command='ut_assert__assertLess "" ""'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}


#
#  assertLessEqual
#

test_assertLessEqual_positives() {
  tested_command='ut_assert__assertLessEqual 0 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_positives_not_less() {
  tested_command='ut_assert__assertLessEqual 1 0'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_positives_equal() {
  tested_command='ut_assert__assertLessEqual 1 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_negatives() {
  tested_command='ut_assert__assertLessEqual -2 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_negatives_not_less() {
  tested_command='ut_assert__assertLessEqual -1 -2'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_negatives_equal() {
  tested_command='ut_assert__assertLessEqual -1 -1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_mixed() {
  tested_command='ut_assert__assertLessEqual -1 1'

  expected_retcode=0 # pass

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_mixed_not_less() {
  tested_command='ut_assert__assertLessEqual 1 -1'

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_string() {
  tested_command='ut_assert__assertLessEqual "a" 1'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_than_string() {
  tested_command='ut_assert__assertLessEqual -1 "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_two_strings() {
  tested_command='ut_assert__assertLessEqual "a" "a"'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}

test_assertLessEqual_two_empty_strings() {
  tested_command='ut_assert__assertLessEqual "" ""'  # (str => int) == 0

  expected_retcode=1 # fail

  assertRaises "${tested_command}" "${expected_retcode}"
}
