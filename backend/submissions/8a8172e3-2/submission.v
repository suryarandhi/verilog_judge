module barrel_shifter_32(input [31:0] data_in, input [4:0] shamt, input dir, output [31:0] data_out);
  assign data_out = dir ? (data_in >> shamt) : (data_in << shamt);
endmodule
