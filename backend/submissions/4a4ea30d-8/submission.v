module gated_d_latch(input en, input d, output reg q);
  always @(*) begin
      q = 1'b0;
    end
endmodule
