
JASPER ?= jg

.PHONY: formal clean

formal:
	$(JASPER) -batch -tcl jasper/run_jasper.tcl

clean:
	rm -rf jasper_work
	rm -rf jgproject
	rm -rf *.log
