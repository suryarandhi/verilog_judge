module synchronous_clear_counter(input clk, input rst, input clear, output reg [3:0] count);
  // Write your code here
always@(posedge clk) begin
if (rst)
count<=4'b0000;
else
count<=count+1;
end
endmodule