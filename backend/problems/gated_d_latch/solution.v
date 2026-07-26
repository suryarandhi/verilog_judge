module gated_d_latch(input en, input d, output reg q);
  initial q = 1'b0;
  always @(*) begin
    if (en) q = d;
  end
endmodule
