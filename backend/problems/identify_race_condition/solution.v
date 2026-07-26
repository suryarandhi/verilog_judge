module identify_race_condition(input clk, input rst, input a, input b, output reg [1:0] q);
  always @(posedge clk) begin
    if (rst) q <= 2'b00;
    else q <= {a, b};
  end
endmodule
