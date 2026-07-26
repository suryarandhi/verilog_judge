module saturating_subtractor(input signed [7:0] a, input signed [7:0] b, output reg signed [7:0] y);
  reg signed [8:0] tmp;
  always @(*) begin
    tmp = a - b;
    if (tmp > 9'sd127) y = 8'sd127;
    else if (tmp < -9'sd128) y = -8'sd128;
    else y = tmp[7:0];
  end
endmodule
