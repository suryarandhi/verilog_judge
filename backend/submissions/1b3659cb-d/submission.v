module dual_port_ram(input clk, input wr_en, input [3:0] wr_addr, input [7:0] wr_data, input [3:0] rd_addr, output reg [7:0] rd_data);
  always @(*) begin
      rd_data = 8'b0;
    end
endmodule
