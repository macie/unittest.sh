#!/bin/sh
#
# Tests for ut_assertions.
#

# import tested script
. "../ut_portability.sh"


#
#  ut_portable__get_date
#

test_get_date_seconds() {
  test_milisec_resolution=0
  result_value="$(ut_portable__get_date ${test_milisec_resolution})"

  dot_in_result=$(echo "${result_value}" |grep ".")

  assertFalse "${dot_in_result}"
}

test_get_date_miliseconds() {
  test_milisec_resolution=1
  result_value="$(ut_portable__get_date ${test_milisec_resolution})"

  dot_in_result=$(echo "${result_value}" |grep ".")

  assertTrue "${dot_in_result}"
}

test_get_date_empty() {
  result_value="$(ut_portable__get_date)"

  dot_in_result=$(echo "${result_value}" |grep ".")

  assertFalse "${dot_in_result}"
}


#
#  ut_portable__elapsed_time
#

test_elapsed_time_sec() {
  test_starttime="19.123"
  test_stoptime="21.890"
  test_milisec_resolution=0
  result_value=$(ut_portable__elapsed_time "${test_starttime}" \
                                           "${test_stoptime}" \
                                           "${test_milisec_resolution}")

  expected_value="less than 3"

  asertEqual "${result_value}" "${expected_value}"
}

test_elapsed_time_milisec() {
  test_starttime="9.030"
  test_stoptime="10.343"
  test_milisec_resolution=0
  result_value=$(ut_portable__elapsed_time "${test_starttime}" \
                                           "${test_stoptime}" \
                                           "${test_milisec_resolution}")

  expected_value="1.313"

  asertEqual "${result_value}" "${expected_value}"
}

test_elapsed_time_empty() {
  test_starttime="1"
  test_stoptime="2"
  result_value=$(ut_portable__elapsed_time "${test_starttime}" \
                                           "${test_stoptime}")

  expected_value="less than 2"

  asertEqual "${result_value}" "${expected_value}"
}

test_elapsed_time_sec_equal() {
  test_starttime="1"
  test_stoptime="1"
  test_milisec_resolution=0
  result_value=$(ut_portable__elapsed_time "${test_starttime}" \
                                           "${test_stoptime}" \
                                           "${test_milisec_resolution}")

  expected_value="less than 1"

  asertEqual "${result_value}" "${expected_value}"
}

test_elapsed_time_milisec_borrowing() {
  test_starttime="1.999"
  test_stoptime="2.001"
  test_milisec_resolution=1
  result_value=$(ut_portable__elapsed_time "${test_starttime}" \
                                           "${test_stoptime}" \
                                           "${test_milisec_resolution}")

  expected_value="0.002"

  asertEqual "${result_value}" "${expected_value}"
}
