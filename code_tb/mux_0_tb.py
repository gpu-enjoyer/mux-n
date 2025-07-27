
import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def mux_0_tb_func(dut):

    in_param = [0, 1]
    out_expect = [0, 1]

    for i in range(2):

        getattr(dut, "in").value = in_param[i]
        await Timer(1, units="ns")

        assert (
            dut.out.value == out_expect[i]
        ), (
            f"N=0 "
            f"in_param={in_param} "
            f"out_expect={out_expect} "
            f"out={dut.out.value}"
        )
