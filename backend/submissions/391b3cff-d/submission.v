module gray_counter_3bit(
    input clk,
    input reset,
    output reg [2:0] gray
);

reg [2:0] bin;
reg [2:0] next_bin;

always @(posedge clk) begin
    if (reset) begin
        bin  <= 3'b000;
        gray <= 3'b000;
    end
    else begin
        next_bin = bin + 1'b1;

        bin <= next_bin;

        gray[2] <= next_bin[2];
        gray[1] <= next_bin[2] ^ next_bin[1];
        gray[0] <= next_bin[1] ^ next_bin[0];
    end
end

endmodule