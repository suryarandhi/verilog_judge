module priority_encoder_4to2(input [3:0] in, output reg [1:0] code, output reg valid);
  // Write your code here
   always@(*) begin
    casex(in)
    3'b1???: code = 2'b11;
    3'b01??: code = 2'b10;
    3'b001?: code = 2'b01;
    3'b0001: code = 2'b00;
    default : code = 2'b??;

    endcase
   end

endmodule