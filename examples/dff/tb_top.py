from cocotb.regression import TestFactory
from run_test import *

# Register the test.
factory = TestFactory(run_test)
factory.generate_tests()