module synchronous_clear_counter(input clk, input rst, input clear, output reg [3:0] count);
  always @(posedge clk) begin
    if (rst || clear) count <= 4'd0;
    else count <= count + 4'd1;
  end
endmodule
