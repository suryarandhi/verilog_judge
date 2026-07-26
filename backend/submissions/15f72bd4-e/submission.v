module sign_extender(input [7:0] a, output [15:0] y);
 assign y = { a[0],a[0],a[0],a[0],a[0],a[0],a[0],a[7:0]};

endmodule