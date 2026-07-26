module handshake_controller(input clk, input rst, input req, output reg ack);
  always @(posedge clk) begin
    if (rst) ack <= 1'b0;
    else if (req) ack <= 1'b1;
    else ack <= 1'b0;
  end
endmodule
