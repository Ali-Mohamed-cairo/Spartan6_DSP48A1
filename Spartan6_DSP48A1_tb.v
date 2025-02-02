`define NO_REG                  0
`define REG                     1
`define CARRYIN_PARAM           0
`define OPMODE5_PARAM           1
`define DIRECT                  0
`define CASCADE                 1
`define ASYNC                   0
`define SYNC                    1
module Sparatan6_DPS48A1_tb();
//Signals declaration
parameter [0:0] A0REG_tb = `REG, A1REG_tb = `REG,
                B0REG_tb = `REG, B1REG_tb = `REG,
                CREG_tb = `REG, DREG_tb = `REG, MREG_tb = `REG,
                PREG_tb = `REG, CARRYINREG_tb = `REG,
                CARRYOUTREG_tb = `REG, OPMODEREG_tb = `REG,
                CARRYINSEL_tb = `OPMODE5_PARAM, B_INPUT_tb = `DIRECT, RSTTYPE_tb = `DIRECT;

reg [17:0] A_tb, B_tb, BCIN_tb, D_tb;
reg [47:0] C_tb;
reg [7:0] OPMODE_tb;
reg CARRYIN_tb, CEA_tb, CEB_tb, CEC_tb, CECARRYIN_tb, CED_tb, CEM_tb, CEOPMODE_tb, CEP_tb, /*Clock Enable Input Ports*/
      RSTA_tb, RSTB_tb, RSTC_tb, RSTCARRYIN_tb, RSTD_tb, RSTM_tb, RSTOPMODE_tb, RSTP_tb, /*Reset Input Ports:*/
      CLK_tb;
reg [47:0] PCIN_tb;
/*Operation outputs*/
wire [35:0] M_tb;
wire [47:0] P_tb;
wire [47:0] PCOUT_tb;
wire [17:0] BCOUT_tb;
wire CARRYOUT_tb; 
wire CARRYOUTF_tb;


//Module instantiation
Spartan6_DSP48A1 DSP(
    .A(A_tb), .B(B_tb), .BCIN(BCIN_tb), .C(C_tb), .D(D_tb), .CARRYIN(CARRYIN_tb), .PCIN(PCIN_tb), .OPMODE(OPMODE_tb),   /*Operation Inputs*/
    .CEA(CEA_tb), .CEB(CEB_tb), .CEC(CEC_tb), .CECARRYIN(CECARRYIN_tb), .CED(CED_tb), .CEM(CEM_tb), .CEOPMODE(CEOPMODE_tb), .CEP(CEP_tb), /*Clock Enable Input Ports*/
    .RSTA(RSTA_tb), .RSTB(RSTB_tb), .RSTC(RSTC_tb), .RSTCARRYIN(RSTCARRYIN_tb), .RSTD(RSTD_tb), .RSTM(RSTM_tb), .RSTOPMODE(RSTOPMODE_tb), .RSTP(RSTP_tb), /*Reset Input Ports:*/
    .CLK(CLK_tb), .M(M_tb), .P(P_tb), .CARRYOUT(CARRYOUT_tb), .CARRYOUTF(CARRYOUTF_tb), .BCOUT(BCOUT_tb), .PCOUT(PCOUT_tb)   /*Operation Outputs*/
);

initial begin
      CLK_tb = 1;
      forever #1 CLK_tb =~ CLK_tb;
end

initial begin
      //Reset the system
      CEA_tb = 1; CEB_tb = 1; CEC_tb = 1; CECARRYIN_tb = 1; CED_tb = 1; CEM_tb = 1; CEOPMODE_tb = 1; CEP_tb = 1; /*Clock Enable Input Ports*/
      RSTA_tb = 1; RSTB_tb = 1; RSTC_tb = 1; RSTCARRYIN_tb = 1; RSTD_tb = 1; RSTM_tb = 1; RSTOPMODE_tb = 1; RSTP_tb = 1;
      A_tb = 2; B_tb = 15; BCIN_tb = 55; D_tb = 78;
      CARRYIN_tb = 1;
      C_tb = 92;
      OPMODE_tb = 8'h6D;
      PCIN_tb = 15;
      @(negedge CLK_tb);
      RSTA_tb = 0; RSTB_tb = 0; RSTC_tb = 0; RSTCARRYIN_tb = 0; RSTD_tb = 0; RSTM_tb = 0; RSTOPMODE_tb = 0; RSTP_tb = 0;
      //Output value is ignored
      @(negedge CLK_tb);
      A_tb = 11; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      //Output value is ignored
      @(negedge CLK_tb);
      A_tb = 3; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      //Output value is ignored
      @(negedge CLK_tb);
      A_tb = 11; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      C_tb = 92;
      OPMODE_tb = 8'hB7;
      PCIN_tb = 115;
      //Output value is 219
      @(negedge CLK_tb);
      A_tb = 10; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      C_tb = 920;
      OPMODE_tb = 8'hAA;
      PCIN_tb = 15;
      //Output value is 14
      @(negedge CLK_tb);
      A_tb = 11; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      C_tb = 92;
      OPMODE_tb = 8'h58;
      PCIN_tb = 15;
      //Output value is 0
      @(negedge CLK_tb);
      A_tb = 11; B_tb = 42; BCIN_tb = 87; D_tb = 100;
      C_tb = 92;
      OPMODE_tb = 8'hED;
      PCIN_tb = 15;
      //Output value is 1
      @(negedge CLK_tb);
      //Output value is 339
      $stop;
end

endmodule