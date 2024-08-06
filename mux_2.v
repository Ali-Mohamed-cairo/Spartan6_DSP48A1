module mux_2(In0, In1, SEL, Out);
parameter WIDTH = 1;

input [WIDTH-1 :0] In0, In1;
input SEL;
output reg [WIDTH-1 :0] Out;

always@(*) begin
    case(SEL)
        1'd0: Out = In0;
        1'd1: Out = In1;
    endcase
end


endmodule