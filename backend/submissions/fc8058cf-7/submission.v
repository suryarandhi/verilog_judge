module mux_2to1(input [7:0] a, input [7:0] b, input [3:0]sel, output [7:0] y);
  // Write your code here
  always@(*) begin
  case(sel)
  sel= 3'b000:y=8'b00000001;
  sel= 3'b001:y=8'b00000010;
  sel= 3'b010:y=8'000000100;
  sel= 3'b011:y=8'b00001000;
  sel= 3'b100:y=8'b00010000;
  sel= 3'b101:y=8'b00100000;
  sel= 3'b110:y=8'b01000000;
  sel= 3'b111:y=8'b10000000;
  default:8'bx;
  endcase
  end
endmodule