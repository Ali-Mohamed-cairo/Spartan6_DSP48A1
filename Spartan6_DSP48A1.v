`define NO_REG                  0
`define REG                     1
`define CARRYIN_PARAM           0
`define OPMODE5_PARAM           1
`define DIRECT                  0
`define CASCADE                 1
`define ASYNC                   0
`define SYNC                    1
module Spartan6_DSP48A1(
    A, B, BCIN, C, D, CARRYIN, PCIN, OPMODE,   /*Operation Inputs*/
    CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, /*Clock Enable Input Ports*/
    RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP, /*Reset Input Ports:*/
    CLK, M, P, CARRYOUT, CARRYOUTF, BCOUT, PCOUT   /*Operation Outputs*/
);
parameter [0:0] A0REG = `REG, A1REG = `REG,
                B0REG = `REG, B1REG = `REG,
                CREG = `REG, DREG = `REG, MREG = `REG,
                PREG = `REG, CARRYINREG = `REG,
                CARRYOUTREG = `REG, OPMODEREG = `REG,
                CARRYINSEL = `OPMODE5_PARAM, B_INPUT = `DIRECT, RSTTYPE = `DIRECT;

input [17:0] A, B, BCIN, D;
input [47:0] C;
input [7:0] OPMODE;
input CARRYIN, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, /*Clock Enable Input Ports*/
      RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP, /*Reset Input Ports:*/
      CLK;
input [47:0] PCIN;
/*Operation outputs*/
output [35:0] M;
output [47:0] P;
output reg [47:0] PCOUT;
output [17:0] BCOUT;
output CARRYOUT; 
output reg CARRYOUTF;

wire [7:0] OPMODE_REG_Out;

wire [17:0] A0_Reg_Out, A1_Reg_Out, B0_Reg_In, B0_Reg_Out, B1_Reg_In_mux_2_Out, D_REG_Out;
reg  [17:0] Pre_Add_Sub_Out;

wire [47:0] C_REG_Out, X_Mux_Out, Z_Mux_Out;

wire [35:0] M_REG_Out;
reg  [35:0] Multiplier_Out;

wire CYI_Reg_In, CYI_Reg_Out;

reg CYO_Reg_In; 

reg [47:0] Post_Add_Sub_Out;

genvar i;

//Modules instantiations
/*OPMODE register*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(8)) OPMODE_REG(
    .In(OPMODE), .SEL_M(OPMODEREG), .rstn_M(RSTOPMODE), .clk_EN_M(CEOPMODE), .clk_M(CLK), .Out_mux(OPMODE_REG_Out)
);

/*A Input*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(18)) A0_REG(
    .In(A), .SEL_M(A0REG), .rstn_M(RSTA), .clk_EN_M(CEA), .clk_M(CLK), .Out_mux(A0_Reg_Out)
);

D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(18)) A1_REG(
    .In(A0_Reg_Out), .SEL_M(A1REG), .rstn_M(RSTA), .clk_EN_M(CEA), .clk_M(CLK), .Out_mux(A1_Reg_Out)
);

/*B Input*/
mux_2 #(.WIDTH(18)) B0_In_mux_2(.In0(B), .In1(BCIN), .SEL(B_INPUT), .Out(B0_Reg_In));

D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(18)) B0_REG(
    .In(B0_Reg_In), .SEL_M(B0REG), .rstn_M(RSTB), .clk_EN_M(CEB), .clk_M(CLK), .Out_mux(B0_Reg_Out)
);

mux_2 #(.WIDTH(18)) B1_Reg_In_mux_2(.In0(Pre_Add_Sub_Out), .In1(B0_Reg_Out), .SEL(OPMODE_REG_Out[4]), .Out(B1_Reg_In_mux_2_Out));

D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(18)) B1_REG(
    .In(B1_Reg_In_mux_2_Out), .SEL_M(B1REG), .rstn_M(RSTB), .clk_EN_M(CEB), .clk_M(CLK), .Out_mux(BCOUT)
);

/*C Input*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(48)) C_REG(
    .In(C), .SEL_M(CREG), .rstn_M(RSTC), .clk_EN_M(CEC), .clk_M(CLK), .Out_mux(C_REG_Out)
);

/*D Input*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(18)) D_REG(
    .In(D), .SEL_M(DREG), .rstn_M(RSTD), .clk_EN_M(CED), .clk_M(CLK), .Out_mux(D_REG_Out)
);

/*M register(Multiplier register)*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(36)) M_REG(
    .In(Multiplier_Out), .SEL_M(MREG), .rstn_M(RSTM), .clk_EN_M(CEM), .clk_M(CLK), .Out_mux(M_REG_Out)
);
generate for(i = 0; i < 36; i=i+1) begin
        buf M_buffer(M[i], M_REG_Out[i]);
    end
endgenerate

/*CYI register*/
mux_2 CarryIn_Sel_Mux2(.In0(OPMODE_REG_Out[5]), .In1(CARRYIN), .SEL(CARRYINSEL), .Out(CYI_Reg_In));

D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(1)) CYI_REG(
    .In(CYI_Reg_In), .SEL_M(CARRYINREG), .rstn_M(RSTCARRYIN), .clk_EN_M(CECARRYIN), .clk_M(CLK), .Out_mux(CYI_Reg_Out)
);

/*X multiplexier*/
mux_4 #(.WIDTH(48)) X_Mux_4(
    .In0(48'h000000), .In1({13'b0,M_REG_Out}), .In2(P), .In3({3'b0,D[11:0], A[17:0],B[17:0]}), .SEL_Bus(OPMODE_REG_Out[1:0]), .Out(X_Mux_Out)
);

/*Z multiplexier*/
mux_4 #(.WIDTH(48)) Z_Mux_4(
    .In0(48'h000000), .In1(PCIN), .In2(P), .In3(C_REG_Out), .SEL_Bus(OPMODE_REG_Out[3:2]), .Out(Z_Mux_Out)
);

/*CYO register*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(1)) CYO_REG(
    .In(CYO_Reg_In), .SEL_M(CARRYOUTREG), .rstn_M(RSTCARRYIN), .clk_EN_M(CECARRYIN), .clk_M(CLK), .Out_mux(CARRYOUT)
);

/*P register*/
D_FFlop_mux2 #(.RST_TYPE_M(RSTTYPE), .WIDTH_M(48)) P_REG(
    .In(Post_Add_Sub_Out), .SEL_M(PREG), .rstn_M(RSTP), .clk_EN_M(CEP), .clk_M(CLK), .Out_mux(P)
);

//Core code

/*Pre-Adder/Subractor*/
always @(*) begin
    case(OPMODE_REG_Out[6]) 
    1'b0: Pre_Add_Sub_Out = D_REG_Out + B0_Reg_Out;
    1'b1: Pre_Add_Sub_Out = D_REG_Out - B0_Reg_Out;
    endcase
end

/*Multiplier*/
always @(*) begin
    Multiplier_Out = BCOUT * A1_Reg_Out;
end

/*Post-Adder/Subractor*/
always @(*) begin
    case(OPMODE_REG_Out[7]) 
    1'b0: {CYO_Reg_In, Post_Add_Sub_Out} = Z_Mux_Out + X_Mux_Out + CYI_Reg_Out;
    1'b1: {CYO_Reg_In, Post_Add_Sub_Out} = Z_Mux_Out - (X_Mux_Out + CYI_Reg_Out);
    endcase
end

/*Concatination*/
always @(*) begin
    PCOUT = P;
    CARRYOUTF = CARRYOUT;
end

endmodule