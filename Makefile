SHELL := /bin/bash

name = $(shell echo $(f) | cut -d . -f 1)

build:
	@ cabal build > /dev/null

compile: build
	@ cat $(f) \
	| ./dist-newstyle/build/x86_64-linux/ghc-9.6.2/traintruck-0.1.0.0/x/traintruck/build/traintruck/traintruck \
	> $(name).S
	@ nasm -felf64 $(name).S
	@ ld $(name).o -o $(name)
	@ rm -rf $(name).S $(name).o

run: compile
	@ ./$(name)

.PHONY: build compile run
