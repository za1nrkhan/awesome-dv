import cocotb
from cocotb.clock import Clock

async def run_test(dut, numbers=None):
    """Test sum(numbers)/n"""

    DATA_WIDTH = int(dut.DATA_WIDTH.value)
    BUS_WIDTH = int(dut.BUS_WIDTH.value)

    dut._log.info('Detected DATA_WIDTH = %d, BUS_WIDTH = %d' %
                        (DATA_WIDTH, BUS_WIDTH))
    
    cocotb.fork(Clock(dut.clk, 100, units='ns').start())