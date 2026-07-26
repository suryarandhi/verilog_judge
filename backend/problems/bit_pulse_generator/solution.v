module bit_pulse_generator(input clk, input rst, input in_bit, output reg pulse);
  reg prev;
  always @(posedge clk) begin
    if (rst) begin prev <= 1'b0; pulse <= 1'b0; end
    else begin pulse <= in_bit & ~prev; prev <= in_bit; end
  end
endmodule
