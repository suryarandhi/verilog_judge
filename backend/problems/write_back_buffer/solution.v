module write_back_buffer(input clk, input rst, input wr_en, input [3:0] addr, input [7:0] data_in, input rd_en, input [3:0] rd_addr, output reg [7:0] data_out, output reg pending);
  reg [7:0] mem [0:15];
  integer i;
  always @(posedge clk) begin
    if (rst) begin data_out <= 8'b0; pending <= 1'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end
    else begin if (wr_en) begin mem[addr] <= data_in; pending <= 1'b1; end else pending <= 1'b0; if (rd_en) data_out <= mem[rd_addr]; end
  end
endmodule
