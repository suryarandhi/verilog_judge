module priority_encoder_4to2(input [3:0] in, output reg [1:0] code, output reg valid);
  // Write your code here
   always@(*) begin
    valid = 1;
    casez (in)

    4'b1???: code = 2'b11;
    4'b01??: code = 2'b10;
    4'b001?: code = 2'b01;
    4'b0001: code = 2'b00;
    default :begin
    code = 2'b00;
    valid = 0;
    end

    endcase
   end

endmodule