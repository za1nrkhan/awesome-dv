import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.regression import TestFactory

from NucleusrvTB import *

async def run_test(dut):
    cocotb.fork(Clock(dut.clock, 10, units='ns').start(start_high=False))
    tb = NucleusrvTB(dut)
    
    clkedge = RisingEdge(dut.clock)

    await tb.reset(40)
    
    # Run the test for 100 clock cycles after reset
    for _ in range(100):
        await clkedge

    tb.stopped = True

# Register the test.
factory = TestFactory(run_test)
factory.generate_tests()