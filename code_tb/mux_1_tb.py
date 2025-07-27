
import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def mux_1_tb_func(dut):

    N = 1
    out_expect = 0

    for in_param in range(1 << (1 << N)):
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
