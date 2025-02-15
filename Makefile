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

CLI     = unittest
DESTDIR = ./dist
LINT    = shellcheck
TEST    = ./unittest


#
# INTERNAL MACROS
#

CLI_CURRENT_VER_TAG   = $$(git tag --points-at HEAD | grep '^v' | sed 's/^v//' | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -1)
CLI_LATEST_VERSION    = $$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')
CLI_PSEUDOVERSION     = $$(VER="$(CLI_LATEST_VERSION)"; echo "$${VER:-23.11}")-$$(TZ=UTC git --no-pager show --quiet --abbrev=12 --date='format-local:%Y%m%d%H%M%S' --format='%cd-%h')
CLI_VERSION           = $$(VER="$(CLI_CURRENT_VER_TAG)"; echo "$${VER:-$(CLI_PSEUDOVERSION)}")


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
	@echo; $(LINT) -V || true
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

.PHONY: install
install: dist
	@echo '# Install in /usr/local/bin' >&2
	@mkdir -p '/usr/local/bin'
	@cp "$(DESTDIR)/$(CLI)" '/usr/local/bin/'

.PHONY: dist
dist:
	@echo '# Copy CLI to $(DESTDIR)/$(CLI)' >&2
	@mkdir -p "$(DESTDIR)"; cp "$(CLI)" "$(DESTDIR)/"
	@echo '# Update version number to $(CLI_VERSION)' >&2
	@sed -i 's/^\(readonly UT_VERSION *=\).*/\1"'$(CLI_VERSION)'"/' "$(DESTDIR)/$(CLI)"
	@echo '# Create checksum' >&2
	@cd "$(DESTDIR)"; sha256sum "$(CLI)" > "$(CLI).sha256sum"

.PHONY: release
release:
	@echo '# Update local branch' >&2
	@git pull --rebase
	@echo '# Create new CLI release tag' >&2
	@VER="$(CLI_LATEST_VERSION)"; printf 'Choose new version number for CLI (calver; >%s): ' "$${VER:-23.11}"
	@read -r NEW_VERSION; \
		git tag "v$$NEW_VERSION"; \
		git push --tags


#
# DEPENDENCIES
#

$(LINT):
	@printf '# $@ installation path: ' >&2
	@command -v $@ >&2 || { echo 'ERROR: Cannot find $@' >&2; exit 1; }
