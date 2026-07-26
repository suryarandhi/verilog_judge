module compare_select(input [7:0] a, input [7:0] b, input sel, output reg [7:0] y,max);
 your code here
always@(*) begin
if (a>b)
max <= a;
min <= b;
else 
max = b;
min = a;
  // Write

    if (sel) begin
    y<= max(a,b);
    end else begin
    y<=min(a,b);
    end
  end


endmodule