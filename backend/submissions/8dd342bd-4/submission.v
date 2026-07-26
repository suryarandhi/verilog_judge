module mealy_1011_detector(input clk, input reset, input din, output reg detected);
  always @(*) begin
      detected = 1'b0;
    end
endmodule
