# Default to verilator
SIM ?= verilator

CWD=$(shell pwd)

TOPLEVEL_LANG ?=verilog

export PYTHONPATH := $(CWD)/../src:$(PYTHONPATH)

ifeq ($(SIM),icarus)
COMPILE_ARGS+=-I$(CWD)/../verilog/nucleusrv
else
COMPILE_ARGS+=+incdir+$(CWD)/../verilog/nucleusrv
endif

#DUT
VERILOG_SOURCES = $(CWD)/../verilog/nucleusrv/sram_top.v
VERILOG_SOURCES += $(CWD)/../verilog/nucleusrv/sram.v
VERILOG_SOURCES += $(CWD)/../verilog/nucleusrv/Top.v

#Test Bench
VERILOG_SOURCES += $(CWD)/../verilog/Core_top.sv

TOPLEVEL = Core_top

export TOPLEVEL_LANG
MODULE=tb_$(TOPLEVEL)

ifeq ($(SIM),verilator)
    EXTRA_ARGS += --trace-fst --trace-structs
endif

include $(shell cocotb-config --makefiles)/Makefile.sim