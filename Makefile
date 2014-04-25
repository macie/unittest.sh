# Makefile for unittest.sh
#
# https://github.com/macie/unittest.sh
#
# Copyright (c) 2014 Maciej Żok <maciek.zok@gmail.com>
# MIT License (http://opensource.org/licenses/MIT)


SOURCE_DIR = "./src"
BUILD_DIR = "./build"

build:
	cp -r "$(SOURCE_DIR)" "$(BUILD_DIR)"
	cd "$(BUILD_DIR)"; \
		sh script_builder.sh
	cp "$(BUILD_DIR)/unittest.sh" unittest.sh
	rm -rf "$(BUILD_DIR)"

test:
	unittest.sh "$(SOURCE_DIR)"

deploy:
	test && create && git push

.SILENT:
.PHONY: build
