module d_flipflop(input clk, input reset, input d, output reg q);
  // Write your code here
always@(*) begin
if(reset)
d<=0
else
d<=q
end
endmodule