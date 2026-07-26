module single_port_ram_16x8(input clk, input rst, input wr_en, input [3:0] addr, input [7:0] din, output reg [7:0] dout);
  reg [7:0] mem [0:15];
  integer i;
  always @(posedge clk) begin
    if (rst) begin dout <= 8'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end
    else begin if (wr_en) mem[addr] <= din; dout <= mem[addr]; end
  end
endmodule
