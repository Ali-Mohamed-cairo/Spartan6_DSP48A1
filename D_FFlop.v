`define ASYNC     0
`define SYNC      1
module D_FFlop(
    D, rstn, clk_EN, clk, Q
);
parameter RST_TYPE = `SYNC,
          WIDTH    = 1;
input [WIDTH-1 :0] D;
input rstn, clk_EN, clk;
output reg [WIDTH-1 :0] Q;

generate if(RST_TYPE == `ASYNC) begin
        always @(posedge clk or negedge rstn)
        begin
            if(clk_EN) begin 
                if(rstn)
                    Q <= 0;
                else
                    Q <= D;
            end
        end
    end
    else begin
       always @(posedge clk)
        begin
            if(clk_EN) begin
                if(rstn)
                    Q <= 0;
                else
                    Q <= D;
            end
        end 
    end

endgenerate
endmodule