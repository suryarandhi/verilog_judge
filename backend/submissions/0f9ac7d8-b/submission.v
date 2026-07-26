module d_flipflop_sync_reset(input clk, input rst, input d, output reg q);
 always@(posedge clk or posedge reset) begin
 if(reset)
 q<=1'b0;
 else
 q<=d;
 end
endmodule