module mux_2to1(input [7:0] a, input [7:0] b, input [2:0]sel, output [7:0] y);
  // Write your code here
always@(*) begin
  if(case)
  y<=b;
  else
  y<=a;
end
endmodule