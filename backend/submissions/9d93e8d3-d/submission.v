module johnson_counter_4bit(input clk, input rst,output reg [3:0] q);

  // Write your code here
  always@(posedge clk) begin
    if(rst)
    q<=4'b0000;
    else  begin
    q[3] <= q[2];
    q[2] <= q[1];
    q[1] <= q[0];
    q[0] <= ~q[3];
    end 
    end
    
  endmodule