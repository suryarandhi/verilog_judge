module regfile_8x8(input clk, input reset, input we, input [2:0] waddr, input [7:0] wdata, input [2:0] raddr1, input [2:0] raddr2, output [7:0] rdata1, output [7:0] rdata2);
  reg [7:0] regs [0:7];
  integer i;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 8; i = i + 1) regs[i] <= 8'b0;
    end else if (we) begin
      regs[waddr] <= wdata;
    end
  end
  assign rdata1 = regs[raddr1];
  assign rdata2 = regs[raddr2];
endmodule
