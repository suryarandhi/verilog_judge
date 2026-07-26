module d_flipflop_sync_reset(input clk, input rst, input d, output reg q);
  // Write your code here
always@(posedge clk) begin
  if(rst)
  q<=0;
  else
  q<=d;
end
endmodule