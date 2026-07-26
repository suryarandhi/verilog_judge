module johnson_counter_4bit(
    input clk,
    input rst,
    output reg [3:0] q
);

always @(posedge clk) begin
    if(rst)
        q <= 4'b0000;
    else begin
        q[3] <= ~q[0];
        q[2] <= q[3];
        q[1] <= q[2];
        q[0] <= q[1];
    end
end

endmodule