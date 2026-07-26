module cache_line_buffer(input clk, input rst, input [1:0] index, input [7:0] tag, input [15:0] data_in, input write_en, output reg [15:0] data_out, output reg hit);
  always @(*) begin
      data_out = 16'b0;
      hit = 1'b0;
    end
endmodule
