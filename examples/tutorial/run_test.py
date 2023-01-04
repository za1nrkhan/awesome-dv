import cocotb

from cocotb.clock import Clock

from EndianSwapperTB import *

async def run_test(dut, data_in=None, config_coroutine=None, 
                idle_inserter=None, 
                backpressure_inserter=None):

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    tb = EndianSwapperTB(dut)

    await tb.reset()
    dut.stream_out_ready <= 1

    # Start off any optional coroutines
    if config_coroutine is not None:
        cocotb.fork(config_coroutine(tb.csr))
    if idle_inserter is not None:
        tb.stream_in.set_valid_generator(idle_inserter())
    if backpressure_inserter is not None:
        tb.backpressure.start(backpressure_inserter())

    # Send in the packets
    for transaction in data_in():
        await tb.stream_in.send(transaction)

    # Wait at least 2 cycles where output ready is low before ending the test
    for i in range(2):
        await RisingEdge(dut.clk)
        while not dut.stream_out_ready.value:
            await RisingEdge(dut.clk)

    pkt_count = await tb.csr.read(1)

    assert pkt_count.integer == tb.pkts_sent, "DUT recorded %d packets but tb counted %d" % (pkt_count.integer, tb.pkts_sent)
    dut._log.info("DUT correctly counted %d packets" % pkt_count.integer)

    raise tb.scoreboard.result