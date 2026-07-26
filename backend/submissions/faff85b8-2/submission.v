module gated_d_latch(
    input en,
    input d,
    output reg q
);

always @(*) begin
    if(en)
        q = d;
    else
        q = q;   // hold previous value
end

endmodule