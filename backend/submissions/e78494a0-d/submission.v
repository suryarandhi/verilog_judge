module vending_machine_controller(input clk, input rst, input coin5, input coin10, output reg dispense);
  always @(*) begin
      dispense = 1'b0;
    end
endmodule
