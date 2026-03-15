VCS ?= vcs
VERDI_HOME ?= /nfs/tools/synopsys/verdi/R-2020.12-SP1
NOVAS_PLI := $(VERDI_HOME)/share/PLI/VCS/LINUX64

all: simv

simv: counter.v tb_counter.v
	$(VCS) -full64 -sverilog -debug_access+all -kdb \
		-P $(NOVAS_PLI)/novas.tab $(NOVAS_PLI)/pli.a \
		counter.v tb_counter.v -o simv

run: simv
	./simv -l simv.log

clean:
	rm -rf simv simv.daidir csrc ucli.key *.log *.fsdb novas* DVEfiles
