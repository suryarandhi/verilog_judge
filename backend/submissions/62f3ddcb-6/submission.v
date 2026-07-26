module pulse_stretcher(input clk, input rst, input pulse_in, output reg pulse_out);
  always @(*) begin
      pulse_out = 1'b0;
    end
endmodule
