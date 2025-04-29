module control(
  input       clk,
  input       rst_n,
  input       clk_in,
  input       i2c_clk_out,
  output      i2c_scl,
  inout       i2c_sda,
  input [1:0]       clk_config,
  input       senzor_on,
  input [6:0] i2c_address,
  output reg  data_enable
);

localparam STATE_SIZE   = 4;
localparam ST_IDLE      = 0;
localparam ST_WAIT_1    = 1;
localparam ST_START_SDA = 2;
localparam ST_START_SCL = 3;
localparam ST_STOP      = 4;
localparam ST_ADDRESS   = 5;
localparam ST_DATA      = 6;
localparam ST_CHECK_RSP = 7;

localparam DIV_HDT_100KHZ = 4000;
localparam DIV_HDT_400KHZ = 600;
localparam DIV_HDT_1MHZ   = 260;
localparam DIV_HDT_3_4MHZ = 160;

reg [STATE_SIZE -1:0] c_state;
reg [STATE_SIZE -1:0] next_state;
reg [12:0]            counter;
reg [12:0]            divider_value;
reg                   i2c_scl_enable;
reg                   i2c_sda_enable;
reg                   sda_out;
wire                  reset_counter;

assign i2c_scl = (i2c_scl_enable) ? i2c_clk_out : 1'b1;
assign i2c_sda = (i2c_sda_enable) ? sda_out : 1'b1;
assign reset_counter = (counter == divider_value - 1);

always @(posedge clk_in or negedge rst_n) begin
  if(~rst_n)  c_state <= ST_IDLE;     else
              c_state <= next_state;
end

always @(clk_config) begin
  case(clk_config)
    2'b00:    divider_value = DIV_HDT_100KHZ;
    2'b01:    divider_value = DIV_HDT_400KHZ;
    2'b10:    divider_value = DIV_HDT_1MHZ;
    2'b11:    divider_value = DIV_HDT_3_4MHZ;
    default:  divider_value = DIV_HDT_100KHZ;
  endcase
end

always @(posedge clk_in or negedge rst_n) begin
  if(~rst_n)         counter <= 13'b0;           else
  if(reset_counter)  counter <= 13'b0;           else
                     counter <= counter + 1'b1;
end

always @(posedge clk_in or negedge rst_n) begin
  case(c_state)
    ST_IDLE: begin
      i2c_scl_enable <= 1'b0;
      i2c_sda_enable <= 1'b0;
      sda_out <= 1'b1;
      data_enable <= 1'b0;
      if(senzor_on) begin
        counter <= 13'b0;
        data_enable <= 1'b1;
        next_state <= ST_WAIT_1;
      end else begin
        next_state <= ST_IDLE;
      end
    end
    ST_WAIT_1: begin
      if(reset_counter) begin
        data_enable <= 1'b0;
        next_state <= ST_START_SDA;
      end else
        next_state <= ST_WAIT_1;
    end
    ST_START_SDA: begin
      if(reset_counter) begin
        i2c_sda_enable <= 1'b1;
        sda_out <= 1'b0;
        next_state <= ST_START_SCL;
      end else 
        next_state <= ST_START_SDA;
    end
    ST_START_SCL: begin
      if(reset_counter) begin
        i2c_scl_enable <= 1'b1;
        next_state <= ST_ADDRESS;
      end else
        next_state <= ST_START_SCL;
    end
    ST_ADDRESS: begin
      
    end
    ST_CHECK_RSP : begin
      
    end
    default: next_state <= ST_IDLE;
  endcase
end

endmodule