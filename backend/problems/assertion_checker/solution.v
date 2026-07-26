module assertion_checker(input [3:0] value, output reg fault);
  always @(*) begin
    fault = value > 4'd12;
  end
endmodule
