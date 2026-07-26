module signed_magnitude_selector(input signed [7:0] a, input signed [7:0] b, input sel, output reg signed [7:0] y, output reg negative);
  reg signed [7:0] aa;
  reg signed [7:0] bb;
  always @(*) begin
    aa = a[7] ? -a : a;
    bb = b[7] ? -b : b;
    if (sel) y = (aa >= bb) ? a : b;
    else y = (a >= b) ? a : b;
    negative = y[7];
  end
endmodule
