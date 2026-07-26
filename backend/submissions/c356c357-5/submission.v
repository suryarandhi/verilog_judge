module conditional_incrementer(input [7:0] a, input enable, output  reg[7:0] y);
 always@(*) begin
 if(enable)
 y = a+1;
 else
 y=a;
 end
endmodule