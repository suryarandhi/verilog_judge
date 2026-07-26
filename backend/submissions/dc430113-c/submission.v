module serial_to_parallel_register(input clk, input rst, input serial_in, input load, output reg [7:0] q);
  always @(*) begin
      q = 8'b0;
    end
endmodule
