JASPER ?= jg

.PHONY: formal xprop all clean

formal:
	$(JASPER) -batch -tcl jasper/run_jasper.tcl

xprop:
	$(JASPER) -batch -tcl jasper/run_jasper_xprop.tcl

all: formal xprop

clean:
	rm -rf jasper_work jgproject
	rm -f *.log
