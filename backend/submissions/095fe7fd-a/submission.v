module shift_register_8bit(input clk, input rst, input serial_in, output reg [7:0] q);
  // Write your code here
  always@(posedge clk) begin
  if (rst) begin
    q<=8'b00000000;
  end
    else begin
      q<={q[7:1],serial_in[0]};
    end
  end



endmodule