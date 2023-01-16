from cocotb.triggers import RisingEdge, ReadOnly

from cocotb_bus.monitors import BusMonitor

class StreamBusMonitor(BusMonitor):
    """Streaming bus monitor."""

    _signals = ["valid", "data"]

    async def _monitor_recv(self):
        """Watch the pins and reconstruct transactions."""

        while True:
            await RisingEdge(self.clock)
            await ReadOnly()
            if self.bus.valid.value:
                self._recv(int(self.bus.data.value))