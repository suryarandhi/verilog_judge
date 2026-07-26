module single_port_ram_16x8(input clk, input rst, input wr_en, input [3:0] addr, input [7:0] din, output reg [7:0] dout);
  always @(*) begin
      dout = 8'b0;
    end
endmodule
