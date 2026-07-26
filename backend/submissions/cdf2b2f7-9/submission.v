module d_flipflop_sync_reset(input clk, input rst, input d, output reg q);
  always @(*) begin
      q = 1'b0;
    end
endmodule
