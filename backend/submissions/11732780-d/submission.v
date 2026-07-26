module find_bug_priority_encoder(input [7:0] in, output reg [2:0] code, output reg valid);
  always @(*) begin
      code = 3'b0;
      valid = 1'b0;
    end
endmodule
