module clk_generator (
  input       rst_n   ,
  output reg  clk_out
);

always @(negedge rst_n)
  if(~rst_n)  clk_out <= 1'b0;


always @(*) begin
  #1ns  clk_out <= ~clk_out; // 1GHz frequency
end

/*
always @(*) begin
  case(MODE)
    0:        #5us        clk <= ~clk;
    1:        #1.25us     clk <= ~clk;
    2:        #0.5us      clk <= ~clk;
    3:        #147.059ns  clk <= ~clk;
    default:  #5us        clk <= ~clk;  
  endcase
end
*/
endmodule