import warnings

from cocotb_bus.drivers import BitDriver
from cocotb_bus.scoreboard import Scoreboard

from BitMonitor import * 
from input_gen import *


class DFF_TB(object):
    def __init__(self, dut, init_val):
        """
        Setup the testbench.

        *init_val* signifies the ``BinaryValue`` which must be captured by the
        output monitor with the first rising clock edge.
        This must match the initial state of the D flip-flop in RTL.
        """
        # Some internal state
        self.dut = dut
        self.stopped = False

        # Create input driver and output monitor
        self.input_drv = BitDriver(signal=dut.d, clk=dut.c, generator=input_gen())
        self.output_mon = BitMonitor(name="output", signal=dut.q, clk=dut.c)

        # Create a scoreboard on the outputs
        self.expected_output = [init_val]  # a list with init_val as the first element
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.output_mon, self.expected_output)

        # Use the input monitor to reconstruct the transactions from the pins
        # and send them to our 'model' of the design.
        self.input_mon = BitMonitor(name="input", signal=dut.d, clk=dut.c,
                                    callback=self.model)

    def model(self, transaction):
        """Model the DUT based on the input *transaction*.

        For a D flip-flop, what goes in at ``d`` comes out on ``q``,
        so the value on ``d`` (put into *transaction* by our ``input_mon``)
        can be used as expected output without change.
        Thus we can directly append *transaction* to the ``expected_output`` list,
        except for the very last clock cycle of the simulation
        (that is, after ``stop()`` has been called).
        """
        if not self.stopped:
            self.expected_output.append(transaction)

    def start(self):
        """Start generating input data."""
        self.input_drv.start()

    def stop(self):
        """Stop generating input data.

        Also stop generation of expected output transactions.
        One more clock cycle must be executed afterwards so that the output of
        the D flip-flop can be checked.
        """
        self.input_drv.stop()
        self.stopped = True
