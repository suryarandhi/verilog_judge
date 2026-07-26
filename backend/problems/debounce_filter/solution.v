module debounce_filter(input clk, input rst, input noisy, output reg clean);
  reg [1:0] hist;
  always @(posedge clk) begin
    if (rst) begin hist <= 2'b00; clean <= 1'b0; end
    else begin hist <= {hist[0], noisy}; if (&{hist[0], noisy}) clean <= 1'b1; else if (~|{hist[0], noisy}) clean <= 1'b0; end
  end
endmodule
