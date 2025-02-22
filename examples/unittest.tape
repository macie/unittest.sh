# Source code of `unittest.gif`. Uses: <https://github.com/charmbracelet/vhs>
#
# To create `unittest.gif`:
#
#     vhs <unittest.tape
#
# SPDX-FileCopyrightText: 2025 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT

Output unittest.gif

Set FontSize 15
Set FontFamily "Courier"
Set LineHeight 1.2
Set Theme "Dark+"
Set Padding 20
Set Width 870
Set Height 370

Hide
Set TypingSpeed 0ms
Type "PS1='\033[0;37m$ \033[0m'"
Enter
Type 'TEMP_DIR=$(mktemp -d)'
Enter
Type 'mkdir ${TEMP_DIR}/tests'
Enter
Type 'cp ./test_*.sh "${TEMP_DIR}/tests"'
Enter
Type 'cp ../unittest "$TEMP_DIR"'
Enter
Type 'PATH="${TEMP_DIR}:$PATH"'
Enter
Type "cd $TEMP_DIR"
Enter
Type "clear"
Enter
Set TypingSpeed 45ms
Show

Sleep 1s
Type "# run all tests from ./tests dir"
Sleep 2s
Enter
Type@75ms "unittest"
Sleep 0.3s
Enter
Sleep 6.3s
Type "clear"
Sleep 0.9s
Enter

Sleep 1s
Type "# run specific test file"
Sleep 0.9s
Enter
Type@75ms "unittest tests/test_successful.sh"
Sleep 0.6s
Enter
Sleep 2.7s
Type@60ms "clear"
Sleep 0.9s
Enter

Sleep 1s
Type "# show failed tests only"
Sleep 0.9s
Enter
Type@75ms "CLICOLOR_FORCE=1 unittest | grep 'FAIL'"
Sleep 0.3s
Enter
Sleep 4.5s
Type "clear"
Sleep 1.8s
Enter

Sleep 1s
Type "# show results in compact format"
Sleep 0.9s
Enter
Type@75ms "unittest 2>/dev/null | \"
Sleep 0.3s
Enter
Type@90ms `  awk '/PASS/{printf "."} /FAIL/{printf "F"} /SKIP/{printf "s"} END{print ""}`
Sleep 0.3s
Enter
Type "'"
Sleep 0.9s
Enter
Sleep 5.4s
Type "clear"
Sleep 0.6s
Enter
