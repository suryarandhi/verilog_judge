module comparator_unsigned(input [7:0] a, input [7:0] b, output reg gt, output reg eq, output reg lt);
  // Write your code here
  always@(*) begin
    if(a>b) begin
    gt=1;
    eq=0;
    lt=0;
    end
    else if(a==b) begin
    eq=1;
    gt=0;
    lt=0;
    end
    else begin
    gt=0;
    eq=0;
    lt=1;
  end
  end
  
endmodule