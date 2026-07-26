module cache_line_buffer(input clk, input rst, input [1:0] index, input [7:0] tag, input [15:0] data_in, input write_en, output reg [15:0] data_out, output reg hit);
  reg [7:0] tags [0:3];
  reg [15:0] data [0:3];
  reg valid [0:3];
  integer i;
  always @(posedge clk) begin
    if (rst) begin data_out <= 16'b0; hit <= 1'b0; for (i = 0; i < 4; i = i + 1) begin tags[i] <= 8'b0; data[i] <= 16'b0; valid[i] <= 1'b0; end end
    else begin if (write_en) begin tags[index] <= tag; data[index] <= data_in; valid[index] <= 1'b1; end hit <= valid[index] && tags[index] == tag; data_out <= data[index]; end
  end
endmodule
