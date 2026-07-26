module address_incrementer(input [15:0] addr, input incr, output [15:0] next_addr);
  assign next_addr = incr ? addr + 16'd1 : addr;
endmodule
