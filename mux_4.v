module mux_4(In0, In1, In2, In3, SEL_Bus, Out);
parameter WIDTH = 1;

input [WIDTH-1 :0] In0, In1, In2, In3;
input [1 : 0] SEL_Bus;
output reg [WIDTH-1 :0] Out;

always@(*) begin
    case(SEL_Bus)
        4'd0: Out = In0;
        4'd1: Out = In1;
        4'd2: Out = In2;
        4'd3: Out = In3;
    endcase
end


endmodule