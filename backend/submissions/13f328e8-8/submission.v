module johnson_counter_4bit(input clk, input rst,reg out,output reg [3:0] q);
  // Write your code here
  always@(posedge clk) begin
    if(rst)
    q<=4'b0;
    else begin
    out[1] = out[0];
    out[2] = out[1];
    out[3] = out[2];
    out[0] = ~out[3];
    end
    out=q;
  end
  endmodule