TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/verilog/dff.sv
TOPLEVEL = dff

MODULE=test_dff

include $(shell cocotb-config --makefiles)/Makefile.sim