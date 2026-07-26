module gated_d_latch(
    input en,
    input d,
    output reg q = 0
);

always @(*) begin
    if(en)
        q = d;
    else
        q = q;   // hold previous value
end

endmodule