module register_2bit(input clk, input reset, input load, input [1:0] d, output reg [1:0] q);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 2'b0;
    end else if (load) begin
      q <= d;
    end
  end
endmodule
