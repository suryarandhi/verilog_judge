module byte_swap_32(input [31:0] data_in, output [31:0] data_out);
  // Write your code here
  assign data_out = {data_in[7:0] , data_in[15:8] , data_in[23:16] , data_in[31:24]};
endmodule