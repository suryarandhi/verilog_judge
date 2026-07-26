module mealy_1011_detector(input clk, input reset, input din, output reg detected);
  reg [1:0] state;
  always @(posedge clk) begin
    if (reset) begin state <= 2'd0; detected <= 1'b0; end
    else begin
      detected <= 1'b0;
      case (state)
        2'd0: state <= din ? 2'd1 : 2'd0;
        2'd1: state <= din ? 2'd1 : 2'd2;
        2'd2: state <= din ? 2'd3 : 2'd0;
        default: begin detected <= din; state <= din ? 2'd1 : 2'd2; end
      endcase
    end
  end
endmodule
