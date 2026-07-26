module byte_swap_32(input [31:0] data_in, output [31:0] data_out);
  // Write your code here
  assign data_out = {data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7],data_in[8],data_in[9],data_in[10],data_in[11],data_in[12],data_in[13],data_in[14],data_in[15],data_in[16],data_in[17],data_in[18],data_in[19],data_in[20],data_in[21],data_in[22],data_in[23],data_in[24],data_in[25],data_in[26],data_in[27],data_in[28],data_in[29],data_in[30]};
endmodule