# Default to verilator
SIM ?= verilator

CWD=$(shell pwd)

TOPLEVEL_LANG ?=verilog


ifeq (,$(wildcard ${WORKSPACE}/cocotb/examples/dff/hdl/dff.v))
$(error env var WORKSPACE does not point to a valid dir or CoCoTB has not been cloned!)
endif

VERILOG_SOURCES =${WORKSPACE}/cocotb/examples/dff/hdl/dff.v


TOPLEVEL = dff
MODULE := tb_top
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

CUSTOM_SIM_DEPS=$(CWD)/Makefile

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace-fst --trace-structs
endif

ifeq ($(SIM),questa)
    SIM_ARGS=-t 1ps
endif

ifneq ($(filter $(SIM),ius xcelium),)
    SIM_ARGS += -v93
endif

include $(shell cocotb-config --makefiles)/Makefile.sim
