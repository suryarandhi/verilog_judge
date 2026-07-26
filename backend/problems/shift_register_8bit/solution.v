module shift_register_8bit(input clk, input rst, input serial_in, output reg [7:0] q);
  always @(posedge clk) begin
    if (rst) q <= 8'b0;
    else q <= {q[6:0], serial_in};
  end
endmodule
