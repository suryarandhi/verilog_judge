module absolute_value_unit(input signed [7:0] a, output reg [7:0] y);
  // Write your code here
  always@(*) begin 
    if (a > 8'b00000000) begin
      y<=a;
    end
    else begin
      y<=-(a);
    end
  end 

endmodule