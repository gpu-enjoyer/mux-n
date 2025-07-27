
MAKEFLAGS += -s

all: clrscr clean install run_mux_tb run_mux_n_tb

clrscr:
	[ -t 1 ] && clear || true

clean:
	rm -rf \
		sim_build \
		code_tb/__pycache__ \
		results.xml

install:
	[ ! -d .venv ] && \
	uv venv && \
	uv pip install cocotb || \
	true

run_mux_tb:
	. .venv/bin/activate && \
	$(MAKE) -f internal/config_mux_tb.mk

NN = 0 1 2 3 5 8
run_mux_n_tb:
	for N_VAL in $(NN); do \
		. .venv/bin/activate && \
		$(MAKE) -f internal/config_mux_n_tb.mk N=$$N_VAL; \
	done

uninstall: clean
	rm -rf .venv
