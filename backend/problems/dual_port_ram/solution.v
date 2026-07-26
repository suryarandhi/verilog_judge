module dual_port_ram(input clk, input wr_en, input [3:0] wr_addr, input [7:0] wr_data, input [3:0] rd_addr, output reg [7:0] rd_data);
  reg [7:0] mem [0:15];
  integer i;
  initial begin for (i = 0; i < 16; i = i + 1) mem[i] = 8'b0; end
  always @(posedge clk) begin
    if (wr_en) mem[wr_addr] <= wr_data;
    rd_data <= mem[rd_addr];
  end
endmodule
