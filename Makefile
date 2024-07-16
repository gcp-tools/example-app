SHELL := /bin/bash

ifeq ($(ENV_EXPORTED),)
	ifneq ("$(wildcard .env)","")
		sinclude .env
		export $(shell [ -f .env ] && sed 's/=.*//' .env)
		export ENV_EXPORTED=true
	endif
endif

sp :=
sp += # add space
shell-sort = $(shell echo -e $(subst $(sp),'\n',$2) | sort $1 --key=1,1 -)


print.en%: ##   print.env~~ print environment variables
print.env:
	env | sort

help_linebreak: ##     ~~

hel%: ##   help~~ show this help message
	@echo "usage: make [target] ..."
	@#echo ""
	@#echo "targets:"
	@grep -Eh '^.+:\ ##\ .+' $(call shell-sort,, $(filter-out %.env, $(MAKEFILE_LIST))) | cut -d ' ' -f '3-' | column -t -s '~~'

help_linebreak: ##     ~~

include ./scripts/make/tsc.mk
include ./scripts/make/cdktf.mk
include ./scripts/make/seq.mk
