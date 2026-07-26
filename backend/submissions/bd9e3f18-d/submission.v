module d_flipflop_sync_reset(input clk, input rst, input d, output reg q);

always @(negedge  clk)
begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end

endmodule