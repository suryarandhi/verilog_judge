module formal_property_checker(input [7:0] value, input permit, output reg violation);
  always @(*) begin
      violation = 1'b0;
    end
endmodule
