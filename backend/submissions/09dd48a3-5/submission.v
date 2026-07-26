module priority_encoder_4to2(input [3:0] in, output reg [1:0] code, output reg valid);
  // Write your code here
   always@(*) begin
    casez(in)
    3'b1xxx: code = 2'b11;
    3'b01xx: code = 2'b10;
    3'b001x: code = 2'b01;
    3'b000x: code = 2'b00;
    endcase
   end

endmodule