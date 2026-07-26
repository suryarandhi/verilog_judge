module shift_register_8bit(input clk, input rst, input serial_in, output reg [7:0] q);
  always @(*) begin
      q = 8'b0;
    end
endmodule
