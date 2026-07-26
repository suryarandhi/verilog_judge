module carry_generate_combiner(input [7:0] a, input [7:0] b, output g, output p);
reg [7:0] sum;
reg carry;

  // Write your code here
  assign {carry,sum} = a+b;
  assign p =a^b;
  if(carry) begin
    g=1'b1;
    end
    else begin 
      caryy = 1'b0;
    end


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                






endmodule