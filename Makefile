ERLC_OPTS := -o ebin
SRCFILES := $(shell find src -type f -name '*.erl')
MODULES := $(shell echo $(SRCFILES) | sed -E 's/.*\/([^/]+)\.erl/\1/g')        
BASEDIR = $(shell basename $(PWD))

all: compile script

compile: $(patsubst src/%.erl,ebin/%.beam,$(SRCFILES))

script: compile
	@zip .tiberius.zip ebin/* $(wildcard src/*.erl) > /dev/null
	@echo '#!/usr/bin/env escript' > tiberius
	@echo '%%! -pa tiberius/ebin' >> tiberius
	@cat .tiberius.zip >> tiberius
	@rm .tiberius.zip
	@chmod +x tiberius
	@echo Script 'tiberius' is now in your root

MOD = $(shell echo %)

ebin/%.beam: force
	@mkdir -p ebin
	@if [ $(wildcard src/$*.erl) -nt $@ ]; then \
		echo '>> erlc $(ERLC_OPTS) $(wildcard src/$*.erl)'; \
		erlc $(ERLC_OPTS) $(wildcard src/$*.erl); \
	fi

force: ;
