module gated_d_latch(input en, input d, output reg q);
  // Write your code here
  always@(*) begin
  if(en)
  q=d;
  
  end
endmodule