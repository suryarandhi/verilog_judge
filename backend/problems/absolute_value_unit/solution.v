module absolute_value_unit(input signed [7:0] a, output reg [7:0] y);
  always @(*) begin
    y = a[7] ? (~a + 8'd1) : a;
  end
endmodule
