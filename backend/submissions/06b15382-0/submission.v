module serial_frame_detector(input clk, input rst, input serial_in, output reg frame_valid);
  always @(*) begin
      frame_valid = 1'b0;
    end
endmodule
