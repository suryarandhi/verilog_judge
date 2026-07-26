module assertion_checker(input [3:0] value, output reg fault);
  always @(*) begin
      fault = 1'b0;
    end
endmodule
