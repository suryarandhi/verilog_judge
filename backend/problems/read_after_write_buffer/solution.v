module read_after_write_buffer(input clk, input rst, input wr_en, input [3:0] addr, input [7:0] data_in, input rd_en, input [3:0] rd_addr, output reg [7:0] data_out);
  reg [7:0] mem [0:15];
  integer i;
  always @(posedge clk) begin
    if (rst) begin data_out <= 8'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end
    else begin if (wr_en) mem[addr] <= data_in; if (rd_en) data_out <= (wr_en && addr == rd_addr) ? data_in : mem[rd_addr]; end
  end
endmodule
