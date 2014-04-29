#!/bin/sh
#
# Portable functions for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


if (date --version | grep "GNU" 1>/dev/null 2>&1); then
  readonly DATE_MSEC=1
else
  readonly DATE_MSEC=0
fi

ut_portable__get_date() {
  #
  # Get current date and time.
  #
  # Seconds since epoch: http://www.etalabs.net/sh_tricks.html
  #
  # Infix for local variables:
  #     ute8c__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (bool) - Miliseconds resolution. Default: 0.
  #
  # Returns:
  #     Miliseconds or seconds since epoch.
  #
  ute8c__milisec_resolution="${1:-0}"

  if [ "${ute8c__milisec_resolution}" -eq 1 ]; then
    ute8c__current_time=$(date -u "+%s.%3N")
  else
    ute8c__current_time=$(( $(date -u \
      "+((%Y-1600)*365+(%Y-1600)/4-(%Y-1600)/100+(%Y-1600)/400+%j-135140)*86400+%H*3600+%M*60+%S") ))
  fi
  printf "%s" "${ute8c__current_time}"
}

ut_portable__elapsed_time() {
  #
  # Calculates time.
  #
  # Infix for local variables:
  #     ut975__
  #
  # Globals:
  #     None.
  #
  # Arguments:
  #     $1 (int) - Start time.
  #     $2 (int) - End time.
  #     $3 (bool) - Miliseconds resolution. Default: 0.
  #
  # Returns:
  #     Runtime with miliseconds or seconds resolution.
  #
  ut975__start="$1"
  ut975__stop="$2"
  ut975__milisec_resolution="${3:-0}"

  ut975__runtime_sec=$(( ${ut975__stop%.*} - ${ut975__start%.*} ))

  if [ "${ut975__milisec_resolution}" -eq 1 ]; then
    ut975__runtime_milisec=$(( ${ut975__stop#*.} - ${ut975__start#*.} ))

    if [ "${ut975__runtime_milisec}" -lt 0 ]; then
      ut975__runtime_milisec=$(( 1000 + ut975__runtime_milisec ))
      ut975__runtime_sec=$(( ut975__runtime_sec - 1 ))
    fi

    ut975__runtime="${ut975__runtime_sec}.${ut975__runtime_milisec}"
  else
    ut975__runtime_sec=$(( ut975__runtime_sec + 1 ))
    ut975__runtime="less than ${ut975__runtime_sec}"
  fi

  printf '%s' "${ut975__runtime}"
}
