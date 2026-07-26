module comparator_unsigned(input [7:0] a, input [7:0] b, output gt, output eq, output lt);
  // Write your code here
  always@(*) begin
    if(a>b)
    gt==1;
    eq==0;
    lt==0;
    if(a==b)
    eq==1;
    gt==o;
    lt==0;
    else
    gt==0;
    eq==0;
    lt==1;
  end
endmodule