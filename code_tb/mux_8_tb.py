
import cocotb
from cocotb.triggers import Timer
import random

@cocotb.test()
async def mux_8_tb_func(dut):

    N = 8
    out_expect = 0

    in_param    = 0
    shift       = (1 << (1 << N)) // 1000
    shift_0     = shift
    shift_flag  = True

    in_values_checked = 0

    while in_param < (1 << (1 << N)):

        in_values_checked += 1

        for sel in range(1 << N):

            getattr(dut, "in").value = in_param
            dut.sel.value = sel

            bit_mask = 1

            for i in range(N - 1, -1, -1):
                if (sel & (1 << i)):
                    bit_mask <<= (1 << (N - 1 - i))

            out_expect = 1 if (in_param & bit_mask) else 0
            
            await Timer(N, units="ns")

            assert (
                dut.out.value == out_expect
            ), (
                f"N={N} "
                f"in_param={in_param} "
                f"sel={sel} "
                f"out_expect={out_expect} "
                f"out={dut.out.value}"
            )

        in_param += shift

        if (shift_flag): shift += random.randint(1, 2)
        else: shift = shift_0

        shift_flag = not shift_flag
    
    cocotb.log.info (
        f"\"in\" values cheched: "
        f"{in_values_checked} "
        f"/ {1 << (1 << N)}"
    )
