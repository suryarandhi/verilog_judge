module circular_buffer(input clk, input rst, input push, input pop, input [7:0] din, output reg [7:0] dout, output reg full, output reg empty);
  reg [7:0] mem [0:3];
  reg [2:0] count;
  reg [1:0] head;
  reg [1:0] tail;
  integer i;
  always @(posedge clk) begin
    if (rst) begin dout <= 8'b0; full <= 1'b0; empty <= 1'b1; count <= 3'd0; head <= 2'd0; tail <= 2'd0; for (i = 0; i < 4; i = i + 1) mem[i] <= 8'b0; end
    else begin if (push && !full) begin mem[tail] <= din; tail <= tail + 2'd1; count <= count + 3'd1; end if (pop && !empty) begin dout <= mem[head]; head <= head + 2'd1; count <= count - 3'd1; end full <= count == 3'd4; empty <= count == 3'd0; end
  end
endmodule
