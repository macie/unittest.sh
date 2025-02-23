# unittest

[![Quality check status](https://github.com/macie/unittest.sh/actions/workflows/check.yml/badge.svg)](https://github.com/macie/unittest.sh/actions/workflows/check.yml)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/7005/badge)](https://www.bestpractices.dev/projects/7005)
[![License](https://img.shields.io/github/license/macie/unittest.sh)](https://tldrlegal.com/license/mit-license)

_Unittest is the standard test runner._

<img alt="unittest showcase" src="./examples/unittest.gif" width="870" />

It follows the Unix philosophy with a modern touch, so it is:

- easy to use: readable elm-inspired error messages & colourized output (if applicable)
- easy to package: POSIX-compliant & MIT license
- easy to extend: with pipelines & standard Unix tools
- easy to replace: tests can be run manually (see: _[Brief theory of shell testing](#brief-theory-of-shell-testing)_).

Its simplicity makes it useful not only for testing shell scripts but also for black-box testing of commands written
in any language.

## Usage

With a basic call, it searches inside `tests/` directory for `test_*.sh` files with `test_*` functions:

```bash
$ unittest
PASS	tests/test_usage.sh:test_invalid_params_msg
PASS	tests/test_regression.sh:test_issue8
...
```

The result is reported to stdout. Non-zero exit code indicates, that some tests have failed. To pass,
each test should exit with 0 code.

In addition to `test_*` functions, you can also define functions named:

- `xtest_*` - will be reported as SKIP (without error)
- `before_each` and `after_each` - test preparation/cleanup code executed before/after each test function
- `before_all` and `after_all` - test preparation/cleanup code executed once per file, before/after all test functions.

Tests can call the `test` function, which extends the [test](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html)
command with a readable error report (to stderr):

```bash
$ unittest
...
PASS	tests/test_number_assertions.sh:test_lessequal_mixed2

-- FAILED TEST --------------------------------- test_output.sh:test_status_pass

I expected:

    test 0 -eq 10

to be true, but the result was false.

FAIL	tests/test_output.sh:test_status_pass
PASS	tests/test_output.sh:test_status_fail
...
```

For example, tests see files inside the [tests directory](./tests).

## Installation

>The instruction is for Linux. On different OSes, you may need to use different
>commands

1. Download [latest stable release from GitHub](https://github.com/macie/unittest.sh/releases/latest):

    ```bash
    curl -SLO https://github.com/macie/unittest.sh/releases/latest/download/unittest
    ```

2. (OPTIONAL) Verify downloading with:

    - [sha256sum](https://en.wikipedia.org/wiki/Sha1sum) - for integrity check
    - [signify](https://en.wikipedia.org/wiki/Signify_(OpenBSD)) - for authorship verification
    - [openssl](https://en.wikipedia.org/wiki/OpenSSL) - for secure timestamp verification

    ```bash
    curl -sSLO 'https://github.com/macie/unittest.sh/releases/latest/download/unittest.sha256sum{.sig,.sig.tsr}'

    # Verify integrity
    tail -n 1 unittest.sha256sum.sig | sha256sum --check

    # Verify authorship
    printf 'untrusted comment: unittest release key\nRWSjEUoB1VL59SwTiImjz+RkrG6rA0w9+j5VsG2GZIPRwpGlE+9CjA6C\n' >unittest-release_key.pub
    signify -V -e -p unittest-release_key.pub -x unittest.sha256sum.sig -m '/dev/null'

    # Verify timestamp
    curl -sSLO 'https://www.certum.pl/CTNCA.pem'
    openssl ts -reply -text -in unittest.sha256sum.sig.tsr 2>/dev/null | grep -e 'Time stamp' -e 'TSA'
    ```

3. Set execute permission:

    ```bash
    chmod +x unittest
    ```

4. Move to directory from `PATH` environment variable:

    ```bash
    mv unittest /usr/local/bin/
    ```

### Development version

```bash
git clone git@github.com:macie/unittest.sh.git
cd unittest.sh
make && make install
```

## Development

Use `make` (GNU or BSD):

- `make` - run checks
- `make test` - run test
- `make check` - perform static code analysis
- `make build` - build `unittest`
- `make install` - install in `/usr/local/bin`
- `make dist` - prepare for distributing
- `make dist-verify` - verify distributed artifacts
- `make clean` - remove distributed artifacts
- `make release` - tag latest commit as a new release
- `make release-key` - generate new key for release signing
- `make info` - print system info (useful for debugging).

### Versioning

_unittest_ is versioned according to the scheme `YY.0M.MICRO` ([calendar versioning](https://calver.org/)). Releases are tagged in Git.

### Reproducible builds

```bash
VERSION=25.02

# Download and build release
git clone --depth 1 --branch "v$VERSION" 'https://github.com/macie/unittest.sh.git'
cd unittest.sh
make dist

# Validate build against remote hash
cd ./dist
curl -sSL -o 'remote.sha256sum.sig' "https://github.com/macie/unittest.sh/releases/download/v${VERSION}/unittest.sha256sum.sig"
tail -n 1 unittest.sha256sum.sig | sha256sum --check
```

## Alternatives

Robert Lehmann created a list of [the most popular shell testing tools](https://github.com/lehmannro/assert.sh#related-projects).
The main difference between them and this project: _unittest_ is idiomatic to Unix. It uses only POSIX commands
and standard output in a simple format. So the result can be easily transformed or extended.

The only comparable alternative is to run tests manually (as described below).

### Brief theory of shell testing

From its beginning, Unix is test-friendly. The simplest shell test is based on exit codes:

```bash
$ command && echo PASS || echo FAIL
PASS
```

Commands which don't crash by default are relatively common. Many practical tests verify what command do (with
a little help from standard Unix tools):

```bash
$ [ -n "$(command)" ] && echo PASS || echo FAIL
PASS
$ command | grep 'expected output' && echo PASS || echo FAIL
PASS
```

Tests for further usage can be wrapped by function inside shell script:

```bash
$ cat <<EOF >test_command.sh
test_run() {
    command
}

test_output() {
    command | grep 'expected output'
}
EOF
```

The exit code of the function is the same as the exit code of the last command in the function, so after sourcing we can use them as before:

```bash
$ . test_command.sh
$ test_output && echo PASS || echo FAIL
PASS
```

Finally, all tests from a file can be run with some `grep` and loop. And this is basically `unittest`.
