module serial_to_parallel_register(input clk, input rst, input serial_in, input load, output reg [7:0] q);
  always @(posedge clk) begin
    if (rst) q <= 8'b0;
    else if (load) q <= {q[6:0], serial_in};
  end
endmodule
