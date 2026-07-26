module gray_counter_3bit(input clk, input reset, output reg [2:0] gray);
  // Write your code here
  reg[2:0] bin;
    always@(posedge clk) begin
    if(reset) begin
      bin<=2'b000;
      gray  <= 2'b000;
      else begin
        bin = bin + 1'b1;
        gray[0] = bin[0];
        gray [1] = bin[0]  ^ bin[1];
        gray[2] = bin[1] ^ bin[2];
        gray[3] = bin[2]  ^ bin[3];
      end
    end


endmodule