module compare_select(input [7:0] a, input [7:0] b, input sel, output reg [7:0] y);
  always @(*) begin
    y = sel ? ((a > b) ? a : b) : ((a < b) ? a : b);
  end
endmodule
