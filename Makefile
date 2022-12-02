.PHONY: all check clean install

requirements_inputs = $(wildcard *.in)
requirements_outputs := $(requirements_inputs:.in=.txt)

install: $(requirements_outputs)
ifeq (, $(shell which pip-sync))
	pip install -r $(requirements_outputs)
else
	pip-sync  $(requirements_outputs)
endif


%.txt: %.in
	pip-compile -v --output-file $@ $<

test.txt: base.txt

check:
	@which pip-compile > /dev/null

clean: check
	rm *.txt
