`ifndef MUX_SV
`define MUX_SV

module mux (
    input  wire [1:0] in,
    input  wire sel,
    output wire out
);
    assign out = sel ? in[1] : in[0];
endmodule

`endif
