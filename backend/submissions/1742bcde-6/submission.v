module sram_1kx8(input clk, input rst, input wr_en, input [9:0] addr, input [7:0] din, output reg [7:0] dout);
  always @(*) begin
      dout = 8'b0;
    end
endmodule
