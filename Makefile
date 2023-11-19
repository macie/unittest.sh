.POSIX:
.SUFFIXES:

LINT=shellcheck
TEST=./unittest

# MAIN TARGETS

all: test check

clean:
	@echo '# Delete distributed files: rm -rf ./dist' >&2
	@rm -rf ./dist

info:
	@printf '# OS info: '
	@uname -rsv;
	@printf '# Development dependencies:\n'
	@echo; $(LINT) -V
	@echo; $(TEST) -v

check: $(LINT)
	@printf '# Static analysis: $(LINT) unittest tests/*.sh\n' >&2
	@$(LINT) unittest tests/*.sh
	
test:
	@echo '# Unit tests: $(TEST)' >&2
	@$(TEST)

install:
	@echo '# Install in /usr/local/bin' >&2
	@mkdir -p /usr/local/bin
	@cp unittest /usr/local/bin/

dist: unittest
	@echo '# Create release artifacts in ./dist' >&2
	@mkdir -p ./dist
	@cp unittest ./dist/unittest

	@echo '# Create checksum' >&2
	@cd ./dist; sha256sum unittest >./unittest.sha256sum

release:
	@echo '# Update local branch' >&2
	@git pull --rebase
	@echo '# Create new release tag' >&2
	@PREV_VER_TAG=$$(git tag | grep "^v" | sed 's/^v//' | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -1); \
		CURRENT_VER=$$(./unittest -v 2>&1 | cut -d' ' -f2); \
		if [ "$$PREV_VER_TAG" = "$$CURRENT_VER" ]; then \
			echo "ERROR: unittest is in the same version as previous release ($$PREV_VER_TAG). Aborting"; \
			exit 1; \
		fi; \
		printf 'Choose new version number (calver) for release [%s]: ' "$${CURRENT_VER:=23.11}"; \
		read -r VERSION; \
		if [ -z "$$VERSION" ]; then \
			VERSION="$$CURRENT_VER"; \
		fi; \
		git tag "v$$VERSION"; \
		git push --tags

# HELPERS

$(LINT):
	@printf '# $@ installation path: ' >&2
	@command -v $@ >&2 || { echo 'ERROR: Cannot find $@' >&2; exit 1; }
