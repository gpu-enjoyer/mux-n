
// gbfv6t55y

`ifndef MUX_N_SV
`define MUX_N_SV
`include "code/mux.sv"

module mux_n #(parameter int unsigned N = 1)
(
    input  wire [(1<<N)-1:0] in,  // 2**N
    input  wire [N-1:0]      sel, // N
    output wire              out
);

localparam int InW    = 1<<N;
localparam int OutW   = 1<<(N-1);
localparam int OutWW  = (N-1)*OutW;

wire [OutWW-1:0] Out;

if (N == 0)
    assign out = in;

else if (N == 1)
    mux m (.in(in), .sel(sel), .out(out));

else for (genvar lvl = 0; lvl < N; ++lvl)
begin: gen_lvls

    if (lvl == 0)
    begin: gen_lvl_first

        for (genvar mux_i = 0; mux_i < OutW; ++mux_i)

            mux first (
                .in(
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
    begin: gen_lvl_last

        mux last(
            .in(
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
    begin: gen_lvl

        for (genvar mux_i = 0; mux_i < (OutW>>lvl); ++mux_i)
            mux m (
                .in(
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
