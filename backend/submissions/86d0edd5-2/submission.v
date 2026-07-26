module buggy_register_debug(input clk, input rst, input en, input [7:0] d, output reg [7:0] q);
  always @(*) begin
      q = 8'b0;
    end
endmodule
