module debounce_filter(input clk, input rst, input noisy, output reg clean);
  always @(*) begin
      clean = 1'b0;
    end
endmodule
