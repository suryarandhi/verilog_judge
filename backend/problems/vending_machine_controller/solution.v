module vending_machine_controller(input clk, input rst, input coin5, input coin10, output reg dispense);
  reg [4:0] credit;
  always @(posedge clk) begin
    if (rst) begin credit <= 5'd0; dispense <= 1'b0; end
    else begin
      dispense <= 1'b0;
      if (credit + (coin5 ? 5'd5 : 5'd0) + (coin10 ? 5'd10 : 5'd0) >= 5'd15) begin credit <= 5'd0; dispense <= 1'b1; end
      else credit <= credit + (coin5 ? 5'd5 : 5'd0) + (coin10 ? 5'd10 : 5'd0);
    end
  end
endmodule
