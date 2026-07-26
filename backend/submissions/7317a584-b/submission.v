module ready_valid_skid_buffer(input clk, input reset, input in_valid, input [7:0] in_data, input out_ready, output in_ready, output reg out_valid, output reg [7:0] out_data);
  assign in_ready = 1'b0;
  always @(*) begin
      out_valid = 1'b0;
      out_data = 8'b0;
    end
endmodule
