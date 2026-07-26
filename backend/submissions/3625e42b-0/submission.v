module priority_encoder_4to2(input [3:0] in, output reg [1:0] y, output reg valid);
  always @(*) begin
    valid = |in;
    if (in[3]) begin
      y = 2'b11;
    end else if (in[2]) begin
      y = 2'b10;
    end else if (in[1]) begin
      y = 2'b01;
    end else begin
      y = 2'b00;
    end
  end
endmodule
