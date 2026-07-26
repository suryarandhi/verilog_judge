module fifo_sync_8x8(input clk, input rst, input write_en, input read_en, input [7:0] din, output reg [7:0] dout, output reg full, output reg empty);
  reg [7:0] mem [0:7];
  reg [3:0] count;
  reg [2:0] wr_ptr;
  reg [2:0] rd_ptr;
  integer i;
  always @(posedge clk) begin
    if (rst) begin dout <= 8'b0; full <= 1'b0; empty <= 1'b1; count <= 4'd0; wr_ptr <= 3'd0; rd_ptr <= 3'd0; for (i = 0; i < 8; i = i + 1) mem[i] <= 8'b0; end
    else begin if (write_en && !full) begin mem[wr_ptr] <= din; wr_ptr <= wr_ptr + 3'd1; count <= count + 4'd1; end if (read_en && !empty) begin dout <= mem[rd_ptr]; rd_ptr <= rd_ptr + 3'd1; count <= count - 4'd1; end full <= count == 4'd8; empty <= count == 4'd0; end
  end
endmodule
