from cocotb_bus.drivers import BitDriver
from cocotb_bus.drivers.avalon import AvalonSTPkts as AvalonSTDriver
from cocotb_bus.drivers.avalon import AvalonMaster

from cocotb_bus.monitors.avalon import AvalonSTPkts as AvalonSTMonitor

from cocotb_bus.scoreboard import Scoreboard

class EndianSwapperTB(object):

    def __init__(self, dut):
        self.dut = dut
        self.stream_in = AvalonSTDriver(dut, "stream_in", dut.clk)
        self.backpressure = BitDriver(self.dut.stream_out_ready, self.dut.clk)
        self.stream_out = AvalonSTMonitor(dut, "stream_out", dut.clk)
        self.csr = AvalonMaster(dut, "csr", dut.clk)

        self.expected_out = []

        self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.stream_out, self.expected_out)

        # Reconstruct the input transactions from the pins and send them to our 'model'
        self.stream_in_recovered = AvalonSTMonitor(dut, "stream_in", dut.clk, callback=self.model)

    def model(self, transaction):
        """Model the DUT based on the input transaction"""
        self.expected_out.append(transaction)
        self.pkts_sent += 1