module d_flipflop(input clk, input reset, input d, output reg q);
  // Write your code here
always@(posedge clk or posedge reset) begin
if(reset)
q<=0;
else
q<=d;
end
endmodule