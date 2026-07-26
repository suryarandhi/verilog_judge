module serial_frame_detector(input clk, input rst, input serial_in, output reg frame_valid);
  reg [3:0] count;
  always @(posedge clk) begin
    if (rst) begin count <= 4'd0; frame_valid <= 1'b0; end
    else begin
      frame_valid <= 1'b0;
      if (count == 4'd0) count <= serial_in ? 4'd0 : 4'd1;
      else if (count == 4'd9) begin frame_valid <= serial_in; count <= 4'd0; end
      else count <= count + 4'd1;
    end
  end
endmodule
