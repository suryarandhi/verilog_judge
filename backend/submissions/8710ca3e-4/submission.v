module circular_buffer(input clk, input rst, input push, input pop, input [7:0] din, output reg [7:0] dout, output reg full, output reg empty);
  always @(*) begin
      dout = 8'b0;
      full = 1'b0;
      empty = 1'b0;
    end
endmodule
