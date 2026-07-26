module up_down_counter(input clk, input rst, input dir, output reg [3:0] count);
  always @(posedge clk) begin
    if (rst) count <= 4'd0;
    else if (dir) count <= count + 4'd1;
    else count <= count - 4'd1;
  end
endmodule
