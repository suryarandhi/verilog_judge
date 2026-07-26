module priority_encoder_4to2(input [3:0] in, output reg [1:0] code, output reg valid);
  always @(*) begin
    valid = |in;
    if (in[3]) code = 2'd3;
    else if (in[2]) code = 2'd2;
    else if (in[1]) code = 2'd1;
    else code = 2'd0;
  end
endmodule
