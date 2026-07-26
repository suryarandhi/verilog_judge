module compare_select(input [7:0] a, input [7:0] b, input sel, output reg [7:0] y,max);
 your code here
always@(*) begin
if (a>b) begin
  max <= a;
  min <= b;
end else begin
  max = b;
  min = a;
end

if (sel) begin
      y<= max(a,b);
end else begin
    y<=min(a,b);
    end
  end


endmodule