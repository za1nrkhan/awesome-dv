import random

def input_gen():
    """Generator for input data applied by BitDriver.

    Continually yield a tuple with the number of cycles to be on
    followed by the number of cycles to be off.
    """
    while True:
        yield random.randint(1, 5), random.randint(1, 5)
