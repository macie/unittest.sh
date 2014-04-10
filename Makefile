prepare:
	test -f "plugins/assert.sh" || ( \
		echo "-> fetching assert.sh..." && \
		curl -s -L -o plugins/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh \
	)

	test -f "plugins/stub.sh" || ( \
		echo "-> fetching stub.sh..." && \
		curl -s -L -o plugins/stub.sh \
			https://rawgithub.com/jimeh/stub.sh/v1.0.1/stub.sh \
	)

.SILENT:
.PHONY: prepare
