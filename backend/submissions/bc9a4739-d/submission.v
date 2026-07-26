module register_3bit(input clk, input reset, input load, input [2:0] d, output reg [2:0] q);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 3'b0;
    end else if (load) begin
      q <= d;
    end
  end
endmodule
