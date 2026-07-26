module write_back_buffer(input clk, input rst, input wr_en, input [3:0] addr, input [7:0] data_in, input rd_en, input [3:0] rd_addr, output reg [7:0] data_out, output reg pending);
  always @(*) begin
      data_out = 8'b0;
      pending = 1'b0;
    end
endmodule
