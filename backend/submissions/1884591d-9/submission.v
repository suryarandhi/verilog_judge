module shift_register_8bit(input clk, input rst, input [7:0]serial_in, output reg [7:0] q);
  // Write your code here
  always@(posedge clk) begin
  if (rst) begin
    q<=8'b00000000;
  end
    else begin
      q<={serial_in[6:1],serial_in[0]};
    end
  end



endmodule