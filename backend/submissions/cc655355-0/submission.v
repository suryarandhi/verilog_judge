module threshold_detector(
    input [7:0] a,
    output reg above_threshold
);

always @(*) begin
    if(a > 100)
        above_threshold = 1;
    else
        above_threshold = 0;
end

endmodule