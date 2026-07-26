module mc(A,B,greater,lower,equal)
input [7:0]A,B;
input clk;
output reg greater,lower,equal;
always@(*) begin
  if(A>B) begin
    greater=1;
    lower=0;
    equal=0;
  end
  else if(A==B) begin
    greater=0;
    lower=0;
    equal=1;
  end
  else begin
    greater=0;
    lower=1;
    equal=0;
  end
end
endmodule