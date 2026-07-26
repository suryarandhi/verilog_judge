module signed_mag_compare(input [7:0] a, input [7:0] b, output reg gt, output reg eq, output reg lt);
  always @(*) begin
    gt = 0; eq = 0; lt = 0;
    if (a == b) eq = 1;
    else if (a[7] != b[7]) gt = ~a[7];
    else if (a[7] == 1'b0) gt = a[6:0] > b[6:0];
    else gt = a[6:0] < b[6:0];
    if (!gt && !eq) lt = 1;
  end
endmodule
