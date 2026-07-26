module population_count(input [7:0] a, output reg [3:0] count);
  integer i;
  always @(*) begin
    count = 4'd0;
    for (i = 0; i < 8; i = i + 1) count = count + a[i];
  end
endmodule
