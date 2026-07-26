module shared_register_file(input clk, input rst, input write_en, input [2:0] write_addr, input [7:0] write_data, input [2:0] read_addr_a, input [2:0] read_addr_b, output [7:0] read_data_a, output [7:0] read_data_b);
  assign read_data_a = 8'b0;
  assign read_data_b = 8'b0;
endmodule
