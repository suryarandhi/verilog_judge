module population_count(input [7:0] a, output reg [3:0] count);
  // Write your code here
  integer i;


  always@(*) begin 
        count=0;
        for(i=0;i<8;i=i+1) begin
        if (a[i]) begin
          count = count+1'b1;
        end
        end
      end


endmodule