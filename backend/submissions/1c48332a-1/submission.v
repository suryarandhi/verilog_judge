module byte_swap_32(input [31:0] data_in, output [31:0] data_out);
  // Write your code here
  assign data_out = data_in[31:0];
endmodule