from cocotb_bus.monitors import Monitor

from cocotb.triggers import RisingEdge

class BitMonitor(Monitor):
    """Observe a single-bit input or output of the DUT."""

    def __init__(self, name, signal, clk, callback=None, event=None):
        self.name = name
        self.signal = signal
        self.clk = clk
        Monitor.__init__(self, callback, event)

    async def _monitor_recv(self):
        clkedge = RisingEdge(self.clk)

        while True:
            # Capture signal at rising edge of clock
            await clkedge
            vec = self.signal.value
            self._recv(vec)