
MODULE           = code_tb.mux_tb
SIM_BUILD        = sim_build/mux
VERILOG_SOURCES  = code/mux.sv
TOPLEVEL         = mux

include $(shell uv run -- cocotb-config --makefiles)/Makefile.sim
