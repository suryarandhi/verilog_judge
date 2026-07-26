module register_4bit(input clk, input reset, input load, input [3:0] d, output reg [3:0] q);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 4'b0;
    end else if (load) begin
      q <= d;
    end
  end
endmodule
