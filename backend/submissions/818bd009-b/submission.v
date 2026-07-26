module priority_encoder_8to3(input [7:0] in, output reg [2:0] code, output valid);
  assign valid = 1'b0;
  always @(*) begin
      code = 3'b0;
    end
endmodule
