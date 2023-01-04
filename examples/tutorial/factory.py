import warnings

from cocotb.regression import TestFactory

from run_test import *
from argument_lib import *

with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    from cocotb.generators.bit import wave, intermittent_single_cycles, random_50_percent

factory = TestFactory(run_test)

factory.add_option("data_in",              [random_packet_sizes])
factory.add_option("config_coroutine"      [None, randomly_switch_config])
factory.add_option("idle_inserter"         [None, wave, intermittent_single_cycles, random_50_percent])
factory.add_option("backpressure_inserter" [None, wave, intermittent_single_cycles, random_50_percent])

factory.generate_tests()