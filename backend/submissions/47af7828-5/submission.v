module majority_gate(input a, input b, input c, output reg y);
  // Write your code here
  always@(*) begin
    if ((a & b) | (b & c) | (a & c))
    y<=1;
    else
    y<=0;
  end 
endmodule