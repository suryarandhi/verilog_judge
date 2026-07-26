module majority_gate(input a, input b, input c, output reg y);
  // Write your code here
  always@(*) begin
    if((a==1&b==1&c==0) | (a==0&b==1&c==1) | (a==1&b==0&c==1) | (a==1&b==1&c==1))
    y<=1;
    else
    y<=0;
  end 
endmodule