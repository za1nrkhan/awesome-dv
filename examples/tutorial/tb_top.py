from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from EndianSwapperTB import *

import cocotb.wavedrom

from factory import *

@cocotb.test()
async def wavedrom_test(dut):
    """
    Generate a JSON wavedrom diagram of a trace and save it to wavedrom.json
    """
    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    await RisingEdge(dut.clk)
    tb = EndianSwapperTB(dut)
    await tb.reset()

    with cocotb.wavedrom.trace(dut.reset_n, tb.csr.bus, clk=dut.clk) as waves:
        await RisingEdge(dut.clk)
        await tb.csr.read(0)
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        dut._log.info(waves.dumpj(header={'text':'WaveDrom example', 'tick':0}))
        waves.write('wavedrom.json', header={'tick':0}, config={'hscale':3})