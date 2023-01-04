import random
import warnings

with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    from cocotb.generators.byte import random_data, get_bytes

def random_packet_sizes(min_size=1, max_size=150, npackets=10):
    """random string data of a random length"""
    for i in range(npackets):
        yield get_bytes(random.randint(min_size, max_size), random_data())

async def randomly_switch_config(csr):
    """Twiddle the byteswapping config register"""
    while True:
        await csr.write(0, random.randint(0, 1))

