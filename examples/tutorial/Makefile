# Default to verilator
SIM ?= verilator

# Default to verilog
TOPLEVEL_LANG ?= verilog

ifeq (,$(wildcard ${WORKSPACE}/cocotb/examples/endian_swapper/hdl/endian_swapper.sv))
$(error env var WORKSPACE does not point to a valid dir or CoCoTB has not been cloned!)
endif

VERILOG_SOURCES = ${WORKSPACE}/cocotb/examples/endian_swapper/hdl/endian_swapper.sv
TOPLEVEL = endian_swapper_sv

MODULE := tb_top

include $(shell cocotb-config --makefiles)/Makefile.sim

# Stuff below is useful for profiling
# Need gprof2dot from https://github.com/jrfonseca/gprof2dot
test_profile.pstat: sim

callgraph.svg: test_profile.pstat
	gprof2dot -f pstats $< | dot -Tsvg -o $@

.PHONY: profile
profile:
	COCOTB_ENABLE_PROFILING=1 $(MAKE) callgraph.svg


clean::
	-rm -rf test_profile.pstat
	-rm -rf callgraph.svg
