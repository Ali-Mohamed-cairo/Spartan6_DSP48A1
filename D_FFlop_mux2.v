`define ASYNC     0
`define SYNC      1
module D_FFlop_mux2(In, SEL_M, rstn_M, clk_EN_M, clk_M, Out_mux);
parameter RST_TYPE_M = `SYNC,
          WIDTH_M    = 1;

input [WIDTH_M-1 : 0] In;
input rstn_M, clk_EN_M, clk_M;
input SEL_M;
output [WIDTH_M-1 : 0] Out_mux;

wire [WIDTH_M-1 : 0] DFFlop_Out;

//Modules instantiation
D_FFlop #(.RST_TYPE(RST_TYPE_M), .WIDTH(WIDTH_M)) DFF(
    .D(In), .rstn(rstn_M), .clk_EN(clk_EN_M), .clk(clk_M), .Q(DFFlop_Out)
);

mux_2 #(.WIDTH(WIDTH_M)) MUX(
    .In0(In), .In1(DFFlop_Out), .SEL(SEL_M), .Out(Out_mux)
);



endmodule