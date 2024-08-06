module mux_2(IN_Bus, SEL_Bus, Out);
parameter SEL_BUS_WIDTH = 1;
localparam IN_BUS_WIDTH = 2**SEL_BUS_WIDTH;

input [IN_BUS_WIDTH-1  : 0] IN_Bus;
input [SEL_BUS_WIDTH-1 : 0] SEL_Bus;
output Out;

/*genvar i;

always@(*) begin
    case(SEL_Bus)
        generate for(i = 0; i < IN_BUS_WIDTH; i=i+1) 
            i: Out = IN_Bus[i];
        endgenerate
    endcase
end*/


endmodule