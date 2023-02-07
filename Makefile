.POSIX:
.SUFFIXES:

LINT=shellcheck
TEST=./unittest

# MAIN TARGETS

all: test check

debug:
	@printf '> OS info: '
	@uname -rsv;
	@printf '> Development dependencies:\n'
	@echo; $(LINT) -V
	@echo; $(TEST) -v

check: $(LINT)
	@printf '> Static analysis: $(LINT) unittest tests/*.sh' >&2
	@$(LINT) unittest tests/*.sh
	
test:
	@echo '> Unit tests: $(TEST)' >&2
	@$(TEST)

# HELPERS

$(LINT):
	@printf '> $@ installation path: ' >&2
	@command -v $@ >&2 || { echo 'ERROR: Cannot find $@' >&2; exit 1; }

