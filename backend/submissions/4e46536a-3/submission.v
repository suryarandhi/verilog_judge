module mealy_1011_detector(input clk, input reset, input din, output reg detected);
  reg [1:0] state;
  localparam S0 = 2'd0, S1 = 2'd1, S10 = 2'd2, S101 = 2'd3;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      detected <= 1'b0;
    end else begin
      detected <= 1'b0;
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S1 : S10;
        S10: state <= din ? S101 : S0;
        S101: begin
          detected <= din;
          state <= din ? S1 : S10;
        end
      endcase
    end
  end
endmodule
