# This Makefile intended to be POSIX-compliant (2024 edition).
#
# More info: <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/make.html>
#
# SPDX-FileCopyrightText: 2014 Maciej Żok <https://github.com/macie/unittest.sh>
# SPDX-License-Identifier: MIT
.POSIX:
.SUFFIXES:


#
# PUBLIC MACROS
#

CLI = unittest
CURL = curl
DESTDIR = ./dist
LINT = shellcheck
OPENSSL = openssl
RELEASE_KEY_FILE = ./unittest-release_key.sec
SHA256 = sha256sum
SIGN = signify-openbsd
TEST = ./unittest
TIMESTAMP_SERVER = 'http://time.certum.pl'
TIMESTAMP_CACERT = 'https://www.certum.pl/CTNCA.pem'


#
# INTERNAL MACROS
#

CLI_CURRENT_VER_TAG   = $$(git tag --points-at HEAD | grep '^v' | sed 's/^v//' | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -1)
CLI_LATEST_VERSION    = $$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')
CLI_PSEUDOVERSION     = $$(VER="$(CLI_LATEST_VERSION)"; echo "$${VER:-23.11}")-$$(TZ=UTC git --no-pager show --quiet --abbrev=12 --date='format-local:%Y%m%d%H%M%S' --format='%cd-%h')
CLI_VERSION           = $$(VER="$(CLI_CURRENT_VER_TAG)"; echo "$${VER:-$(CLI_PSEUDOVERSION)}")

RELEASE_KEY = 'RWSjEUoB1VL59SwTiImjz+RkrG6rA0w9+j5VsG2GZIPRwpGlE+9CjA6C'

#
# DEVELOPMENT TASKS
#

.PHONY: all
all: test check

.PHONY: clean
clean:
	@echo '# Delete build directory: rm -rf $(DESTDIR)' >&2
	@rm -rf "$(DESTDIR)"

.PHONY: info
info:
	@echo '# OS info: '
	@uname -rsv;
	@echo '# Development dependencies:'
	@echo; $(CURL) -V || true
	@echo; $(LINT) -V || true
	@echo; $(OPENSSL) -v || true
	@echo; $(SIGN) || true
	@echo; $(TEST) -v || true
	@echo '# Environment variables:'
	@env || true

.PHONY: check
check: $(LINT)
	@echo '# Static analysis: $(LINT) $(CLI) ./tests/*.sh' >&2
	@$(LINT) $(CLI) ./tests/*.sh

.PHONY: test
test:
	@echo '# Unit tests: $(TEST)' >&2
	@$(TEST)

.PHONY: build
build:
	@echo '# Copy CLI to $(DESTDIR)/$(CLI)' >&2
	@mkdir -p "$(DESTDIR)"; cp "$(CLI)" "$(DESTDIR)/"
	@echo '# Update version number to $(CLI_VERSION)' >&2
	@sed -i 's/^\(readonly UT_VERSION *=\).*/\1"'$(CLI_VERSION)'"/' "$(DESTDIR)/$(CLI)"

.PHONY: install
install: build
	@echo '# Install in /usr/local/bin' >&2
	@mkdir -p '/usr/local/bin'
	@cp "$(DESTDIR)/$(CLI)" '/usr/local/bin/'

.PHONY: dist
dist: build $(CURL) $(OPENSSL) $(SHA256) $(SIGN)
	@echo '# Create hash' >&2
	@cd "$(DESTDIR)"; $(SHA256) "$(CLI)" > "$(CLI).sha256sum"
	@echo '# Sign and embed hash' >&2
	@$(SIGN) -S -e -x '$(DESTDIR)/$(CLI).sha256sum.sig' -s '$(RELEASE_KEY_FILE)' -m '$(DESTDIR)/$(CLI).sha256sum'
	@echo '# Remove unused hash file' >&2
	@rm -f "$(DESTDIR)/$(CLI).sha256sum"
	@echo '# Create timestamp' >&2
	@$(OPENSSL) ts -query -sha256 -cert -data '$(DESTDIR)/$(CLI).sha256sum.sig' | \
		$(CURL) --data-binary @- --header 'Content-Type: application/timestamp-query' --silent --location --show-error '$(TIMESTAMP_SERVER)' >'$(DESTDIR)/$(CLI).sha256sum.sig.tsr'

.PHONY: dist-verify
dist-verify: $(CURL) $(OPENSSL) $(SHA256) $(SIGN)
	@echo '# Verify hash' >&2
	@cd '$(DESTDIR)'; tail -n 1 '$(CLI).sha256sum.sig' | $(SHA256) --check
	@echo '# Verify signature' >&2
	@printf 'untrusted comment: generated pubkey\n$(RELEASE_KEY)\n' >'$(CLI)-release_key.pub'; $(SIGN) -V -e -p '$(CLI)-release_key.pub' -x '$(DESTDIR)/$(CLI).sha256sum.sig' -m '/dev/null'
	@echo '# Verify timestamp' >&2
	@$(CURL) -silent --location --show-error '$(TIMESTAMP_CACERT)' >'timestamp.pem'
	@$(OPENSSL) ts -reply -text -in dist/unittest.sha256sum.sig.tsr 2>/dev/null | grep -e 'Time stamp' -e 'TSA'
	@$(OPENSSL) ts -verify -in '$(DESTDIR)/$(CLI).sha256sum.sig.tsr' -data '$(DESTDIR)/$(CLI).sha256sum.sig' -CAfile 'timestamp.pem' 2>/dev/null

.PHONY: release
release:
	@echo '# Update local branch' >&2
	@git pull --rebase
	@echo '# Create new CLI release tag' >&2
	@VER="$(CLI_LATEST_VERSION)"; printf 'Choose new version number for CLI (calver; >%s): ' "$${VER:-23.11}"
	@read -r NEW_VERSION; \
		git tag "v$$NEW_VERSION"; \
		git push --tags

.PHONY: release-key
release-key: $(SIGN)
	@echo '# Generate new release key' >&2
	@$(SIGN) -G -n -c "github.com/macie/unittest.sh release key (generated at: $$(date -u '+%Y-%m-%dT%H:%M:%SZ'))" -p 'unittest-release_key.pub' -s '$(RELEASE_KEY_FILE)'

#
# DEPENDENCIES
#

$(CURL) $(LINT) $(OPENSSL) $(SHA256) $(SIGN):
	@printf '# $@ installation path: ' >&2
	@command -v $@ >&2 || { echo 'ERROR: Cannot find $@' >&2; exit 1; }
