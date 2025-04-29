module clk_divider (
  input       clk_in        , // 1GHz clock 
  input       rst_n         , // 
  input [1:0] clk_config    , //
  output reg  i2c_clk_out   , //
  output reg  sda_en          //
);

localparam DIV_100KHZ = 5000;
localparam DIV_400KHZ = 1250;
localparam DIV_1MHZ   = 500;
localparam DIV_3_4MHZ = 147;

reg [12:0]  counter;
reg [12:0]  divider_value;

always @(clk_config) begin
  case(clk_config)
    2'b00:    divider_value = DIV_100KHZ;
    2'b01:    divider_value = DIV_400KHZ;
    2'b10:    divider_value = DIV_1MHZ;
    2'b11:    divider_value = DIV_3_4MHZ;
    default:  divider_value = DIV_100KHZ;
  endcase
end

always @(posedge clk_in or negedge rst_n) begin
  if(~rst_n)                        counter <= 13'b0;           else
  if(counter == divider_value - 1)  counter <= 13'b0;           else
                                    counter <= counter + 1'b1;
end

always @(posedge clk_in or negedge rst_n) begin
  if(~rst_n)                        i2c_clk_out <= 1'b0;        else
  if(counter == divider_value - 1)  i2c_clk_out <= ~i2c_clk_out;
end

always @(posedge clk_in or negedge rst_n) begin
  if(~rst_n)                                          sda_en <= 1'b0; else
  if(sda_en)                                          sda_en <= 1'b0; else
  if(counter == (divider_value >> 1) & ~i2c_clk_out)  sda_en <= 1'b1;
end

endmodule