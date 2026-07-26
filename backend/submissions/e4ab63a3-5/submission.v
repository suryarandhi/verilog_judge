module synchronous_clear_counter(input clk, input rst, input clear, output reg [3:0] count);
  // Write your code here
always@(posedge clk or posedge rst) begin
if (rst) begin
count<=4'b0000;
end else begin
if(clear) 
count<=4'b0000;
else
count<=count+1;
end
end
endmodule