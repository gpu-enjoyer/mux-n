
// gbfv6t55y

`ifndef MUX_N_SV
`define MUX_N_SV

// base multiplexer module
`include "code/mux.sv"

// Verilog linter requires indexing
//  in reverse order

module mux_n #(parameter int unsigned N = 3)
(
    input  wire [(1<<N)-1:0] in,  // 2^N
    input  wire [N-1:0]      sel, // N
    output wire              out  // 1
);

localparam int InW    = 1<<N;        // input width

localparam int OutW   = 1<<(N-1);    // the widest level output width

localparam int OutWW  = (N-1)*OutW;  // width of all lvls outputs array
wire [OutWW-1:0] Out;                // stores the outputs of all lvls

// Out size is excessive
//  (Verilog limitations for working with parametric module)

// degenerate case
if (N == 0)
    assign out = in;

// basic case
else if (N == 1)
    mux m (.in(in), .sel(sel), .out(out));

// N > 1
else for (genvar lvl = 0; lvl < N; ++lvl)
begin: gen_lvls

    if (lvl == 0)
    begin: gen_lvl_first // first lvl

        for (genvar mux_i = 0; mux_i < OutW; ++mux_i)

            mux first (
                .in(
                    // in [ 2 bits ] -> base mux
                    in[ InW-1 -(mux_i<<1) -: 2 ]
                ),
                .sel(
                    sel[N-1]
                ),
                .out(
                    Out[ OutWW-1 -mux_i ]
                )
            );

    end // gen_lvl_first

    else if (lvl == N-1)
    begin: gen_lvl_last // last lvl

        mux last(
            .in(
                // Out [ previous lvl 2 bits ] -> base mux
                Out[ (OutW-1) -: 2 ]
            ),
            .sel(
                sel[0]
            ),
            .out(
                out
            )
        );

    end // gen_lvl_last

    else
    begin: gen_lvl // any other lvl

        for (genvar mux_i = 0; mux_i < (OutW>>lvl); ++mux_i)
            mux m (
                .in(
                    // Out [ previous lvl 2 bits ] -> base mux
                    Out[ OutWW-1 -OutW*(lvl-1) -(mux_i<<1) -: 2]
                ),
                .sel(
                    sel[N-1 -lvl]
                ),
                .out(
                    Out[ OutWW-1 -OutW*lvl -mux_i ]
                )
            );

    end // gen_lvl

end // gen_lvls

endmodule
`endif
