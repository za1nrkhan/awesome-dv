from cocotb.triggers import Timer, RisingEdge
class NucleusrvTB(object):
    def __init__(self, dut):
        # Some internal state
        self.dut = dut
        self.stopped = False

    async def reset(self, duration=20):
        self.dut._log.debug("Resetting DUT")
        self.dut.reset <= 1
        await Timer(duration, units='ns')
        await RisingEdge(self.dut.clock)
        self.dut.reset <= 0
        self.dut._log.debug("Out of reset")
        