module absolute_difference(input [7:0] a, input [7:0] b, output reg [7:0] diff);
  // Write your code here
  always@(*) begin
    if (a==b) begin
      diff<=8'b00000000;
    end
    else if (a>b) begin
      diff <= a-b;
    end
    else begin
      diff <= b-a;
    end 
  end

endmodule