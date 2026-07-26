module bit_pulse_generator(input clk, input rst, input in_bit, output reg pulse);
  always @(*) begin
      pulse = 1'b0;
    end
endmodule
