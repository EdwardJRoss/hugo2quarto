.PHONY: all check clean install

requirements_inputs = $(wildcard *.in)
requirements_outputs := $(requirements_inputs:.in=.txt)

install: $(requirements_outputs)
ifeq (, $(shell which pip-sync))
	pip install $(addprefix -r ,$(requirements_outputs))
else
	pip-sync  $(requirements_outputs)
endif

%.txt: %.in
	pip-compile -v --output-file $@ $<

check:
	@which pip-compile > /dev/null

clean: check
	rm *.txt
