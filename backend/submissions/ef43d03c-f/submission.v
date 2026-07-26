module absolute_value_unit(
    input signed [7:0] a,
    output reg [7:0] y
);

always @(*) begin
    if (a[7] == 1'b1)
        y = ~a + 1'b1;   // 2's complement
    else
        y = a;
end

endmodule