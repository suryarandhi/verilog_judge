module banked_register_file(input clk, input rst, input write_en, input bank_sel, input [2:0] write_addr, input [7:0] write_data, input [2:0] read_addr_a, input [2:0] read_addr_b, output [7:0] read_data_a, output [7:0] read_data_b);
  reg [7:0] bank0 [0:7];
  reg [7:0] bank1 [0:7];
  integer i;
  always @(posedge clk) begin
    if (rst) begin for (i = 0; i < 8; i = i + 1) begin bank0[i] <= 8'b0; bank1[i] <= 8'b0; end end
    else if (write_en) begin if (bank_sel) bank1[write_addr] <= write_data; else bank0[write_addr] <= write_data; end
  end
  assign read_data_a = bank_sel ? bank1[read_addr_a] : bank0[read_addr_a];
  assign read_data_b = bank_sel ? bank1[read_addr_b] : bank0[read_addr_b];
endmodule
