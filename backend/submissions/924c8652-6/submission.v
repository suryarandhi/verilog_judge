module address_incrementer(input [15:0] addr, input incr, output reg [15:0] next_addr);
  // Write your code here
  always@(*) begin
    if(incr)
    next_addr = addr+1;
    else
    next_addr = addr;
  end

endmodule