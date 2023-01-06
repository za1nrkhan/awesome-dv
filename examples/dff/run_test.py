import cocotb

from DFF_TB import *

from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue

async def run_test(dut):
    """Setup testbench and run a test."""

    cocotb.fork(Clock(dut.c, 10, 'us').start(start_high=False))

    tb = DFF_TB(dut, init_val=BinaryValue(0))

    clkedge = RisingEdge(dut.c)

    # Apply random input data by input_gen via BitDriver for 100 clock cycles.
    tb.start()
    for _ in range(100):
        await clkedge

    # Stop generation of input data. One more clock cycle is needed to capture
    # the resulting output of the DUT.
    tb.stop()
    await clkedge

    # Print result of scoreboard.
    raise tb.scoreboard.result
    