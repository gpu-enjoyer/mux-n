
import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def mux_tb(dut):

    # in [1:0]
    in_param = \
        [ 0b00, 0b01, 0b10, 0b11 ]
    
    out_expect = \
        [
            [0, 1, 0, 1], # sel = 0
            [0, 0, 1, 1]  # sel = 1
        ]

    for sel in range(2):

        for in_i in range(4):

            getattr(dut, "in").value = in_param[in_i]
            dut.sel.value = sel

            await Timer(1, units="ns")
            assert (
                dut.out.value == out_expect[sel][in_i]
            ), f"out = {dut.out.value}, out_expect = {out_expect[sel][in_i]}"
