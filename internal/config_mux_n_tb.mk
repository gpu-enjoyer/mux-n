
N ?= 1

VERILOG_SOURCES  = code/mux_n.sv code/mux.sv
TOPLEVEL         = mux_n

MODULE           = code_tb.mux_$(N)_tb
SIM_BUILD        = sim_build/mux_$(N)
COMPILE_ARGS     += -Pmux_n.N=$(N)

include $(shell uv run -- cocotb-config --makefiles)/Makefile.sim
