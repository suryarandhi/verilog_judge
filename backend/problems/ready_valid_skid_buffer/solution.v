module ready_valid_skid_buffer(input clk, input reset, input in_valid, input [7:0] in_data, input out_ready, output in_ready, output reg out_valid, output reg [7:0] out_data);
  assign in_ready = !out_valid || out_ready;
  always @(posedge clk) begin
    if (reset) begin out_valid <= 1'b0; out_data <= 8'b0; end
    else if (in_ready) begin out_valid <= in_valid; if (in_valid) out_data <= in_data; end
  end
endmodule
