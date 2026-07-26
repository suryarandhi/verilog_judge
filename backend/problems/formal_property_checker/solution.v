module formal_property_checker(input [7:0] value, input permit, output reg violation);
  always @(*) begin
    violation = !permit && value > 8'd200;
  end
endmodule
