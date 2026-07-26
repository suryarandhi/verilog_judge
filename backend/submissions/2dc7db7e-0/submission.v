module handshake_controller(input clk, input rst, input req, output reg ack);
  always @(*) begin
      ack = 1'b0;
    end
endmodule
