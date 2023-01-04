import logging
import warnings

import cocotb

from cocotb_bus.drivers import BitDriver
from cocotb_bus.drivers.avalon import AvalonSTPkts as AvalonSTDriver
from cocotb_bus.drivers.avalon import AvalonMaster

from cocotb_bus.monitors.avalon import AvalonSTPkts as AvalonSTMonitor

from cocotb_bus.scoreboard import Scoreboard

from cocotb.triggers import Timer, RisingEdge, ReadOnly

class EndianSwapperTB(object):

    def __init__(self, dut, debug=False):
        self.dut = dut
        self.stream_in = AvalonSTDriver(dut, "stream_in", dut.clk)
        self.backpressure = BitDriver(self.dut.stream_out_ready, self.dut.clk)
        self.stream_out = AvalonSTMonitor(dut, "stream_out", dut.clk,
                                          config={'firstSymbolInHighOrderBits':
                                                  True})
        self.csr = AvalonMaster(dut, "csr", dut.clk)

        cocotb.fork(stream_out_config_setter(dut, self.stream_out,
                                             self.stream_in))

        # Create a scoreboard on the stream_out bus
        self.pkts_sent = 0
        self.expected_output = []
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.stream_out, self.expected_output)

        # Reconstruct the input transactions from the pins
        # and send them to our 'model'
        self.stream_in_recovered = AvalonSTMonitor(dut, "stream_in", dut.clk,
                                                   callback=self.model)

        # Set verbosity on our various interfaces
        level = logging.DEBUG if debug else logging.WARNING
        self.stream_in.log.setLevel(level)
        self.stream_in_recovered.log.setLevel(level)

    def model(self, transaction):
        """Model the DUT based on the input transaction"""
        self.expected_output.append(transaction)
        self.pkts_sent += 1
    
    async def reset(self, duration=20):
        self.dut._log.debug("Resetting DUT")
        self.dut.reset_n <= 0
        self.stream_in.bus.valid <= 0
        await Timer(duration, units='ns')
        await RisingEdge(self.dut.clk)
        self.dut.reset_n <= 1
        self.dut._log.debug("Out of reset")


async def stream_out_config_setter(dut, stream_out, stream_in):
    """Coroutine to monitor the DUT configuration at the start
       of each packet transfer and set the endianness of the
       output stream accordingly"""
    edge = RisingEdge(dut.stream_in_startofpacket)
    ro = ReadOnly()
    while True:
        await edge
        await ro
        if dut.byteswapping.value:
            stream_out.config['firstSymbolInHighOrderBits'] = \
                not stream_in.config['firstSymbolInHighOrderBits']
        else:
            stream_out.config['firstSymbolInHighOrderBits'] = \
                stream_in.config['firstSymbolInHighOrderBits']