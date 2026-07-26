module one_hot_to_binary(input [7:0] one_hot, output reg [2:0] code, output valid);
  assign valid = 1'b0;
  always @(*) begin
      code = 3'b0;
    end
endmodule
