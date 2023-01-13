
class NucleusrvTB(object):
    def __init__(self, dut):
        # Some internal state
        self.dut = dut
        self.stopped = False
        