module register_file_8x8_2r1w(input clk, input rst, input write_en, input [2:0] write_addr, input [7:0] write_data, input [2:0] read_addr_a, input [2:0] read_addr_b, output [7:0] read_data_a, output [7:0] read_data_b);
  reg [7:0] regs [0:7];
  integer i;
  always @(posedge clk) begin
    if (rst) begin for (i = 0; i < 8; i = i + 1) regs[i] <= 8'b0; end
    else if (write_en) regs[write_addr] <= write_data;
  end
  assign read_data_a = regs[read_addr_a];
  assign read_data_b = regs[read_addr_b];
endmodule
