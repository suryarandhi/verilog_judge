module saturating_accumulator(input clk, input rst, input en, input signed [7:0] d, output reg signed [7:0] q);
  reg signed [8:0] tmp;
  always @(posedge clk) begin
    if (rst) q <= 8'sd0;
    else if (en) begin
      tmp = q + d;
      if (tmp > 9'sd127) q <= 8'sd127;
      else if (tmp < -9'sd128) q <= -8'sd128;
      else q <= tmp[7:0];
    end
  end
endmodule
