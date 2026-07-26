module pulse_stretcher(input clk, input rst, input pulse_in, output reg pulse_out);
  reg hold;
  always @(posedge clk) begin
    if (rst) begin pulse_out <= 1'b0; hold <= 1'b0; end
    else begin pulse_out <= pulse_in | hold; hold <= pulse_in; end
  end
endmodule
