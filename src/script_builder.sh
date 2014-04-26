#!/bin/sh
#
# unittest.sh builder.
#
# Insert contents of files to template file and saves it as "unittest.sh".
#
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


template_file="unittest.template.sh"
output_file="unittest.sh"

insert_pattern='^#[ ]*insert.*file:.*<\(.*\)>.*$'
first_level_comments='^#.*$'

# read template line by line
while IFS= read -r line; do
  # write line only if not matched
  ( printf '%s' "${line}" | grep -v "${insert_pattern}" )
  # if line matched then insert file
  if [ "$?" -ne 0 ]; then
    # get name of file to insert
    found_file=$(printf '%s' "${line}" | sed "s/${insert_pattern}/\1/")
    # remove first level comments
    #   and write insert file or nothing (if no file)
    grep -v "${first_level_comments}" "${found_file}" 2> /dev/null
  fi
done < "${template_file}" > "${output_file}"  # save to output file
