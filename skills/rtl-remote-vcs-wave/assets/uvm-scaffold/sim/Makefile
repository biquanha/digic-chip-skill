VCS ?= vcs
VERDI_HOME ?= /nfs/tools/synopsys/verdi/R-2020.12-SP1
NOVAS_PLI := $(VERDI_HOME)/share/PLI/VCS/LINUX64

all: comp sim

comp:
	$(VCS) -full64 -sverilog -q -debug_access+all -ntb_opts uvm-1.1 -lca -kdb -timescale=1ns/1ps \
		-f rtl.list \
		-P $(NOVAS_PLI)/novas.tab $(NOVAS_PLI)/pli.a \
		-top tb_top ../tb/tb_top.sv -l vcs_compile.log

sim:
	./simv +UVM_TESTNAME=base_test -l sim.log

verdi:
	verdi --ssv -ssf tb.fsdb -simflow -simBin ./simv &

clean:
	rm -rf csrc simv simv.* *.fsdb *.log novas* ucli.key vc_hdrs.h DVEfiles
