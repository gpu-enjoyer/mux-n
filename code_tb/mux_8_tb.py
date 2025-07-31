
import cocotb
from cocotb.triggers import Timer
import random

@cocotb.test()
async def mux_8_tb_func(dut):

    N = 8                                  # number of multiplexer selectors
    out_expect = 0                         # expected output value

    in_param    = 0                        # input value

    shift       = (1 << (1 << N)) // 1000  # step change of input value
    shift_0     = shift                    # initial step value
    shift_flag  = True                     # random step change flag

    in_values_checked = 0                  # counter of checked values

    # main testing cycle
    while in_param < (1 << (1 << N)):

        in_values_checked += 1

        # checking all possible values of a selector
        for sel in range(1 << N):

            # setting input values
            getattr(dut, "in").value = in_param
            dut.sel.value = sel

            bit_mask = 1

            # calculate the bit mask for the expected value
            for i in range(N - 1, -1, -1):
                if (sel & (1 << i)):
                    bit_mask <<= (1 << (N - 1 - i))

            # expected value
            out_expect = 1 if (in_param & bit_mask) else 0
            
            # waiting for stabilization
            await Timer(N, units="ns")

            # checking the result
            assert (
                dut.out.value == out_expect
            ), (
                f"N={N} "
                f"in_param={in_param} "
                f"sel={sel} "
                f"out_expect={out_expect} "
                f"out={dut.out.value}"
            )

        # changing the input value with a variable step
        in_param += shift

        # random step change
        if (shift_flag): shift += random.randint(1, 2)
        else: shift = shift_0

        shift_flag = not shift_flag
    
    # logging the number of values checked
    cocotb.log.info (
        f"\"in\" values cheched: "
        f"{in_values_checked} "
        f"/ {1 << (1 << N)}"
    )
