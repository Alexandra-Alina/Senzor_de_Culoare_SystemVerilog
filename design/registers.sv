module registers #(
  parameter REG_WIDTH   = 16,
  parameter DATA_WIDTH  = 32,
  parameter ADDR_WIDTH  = 5
) (
  input                         clk               , //
  input                         rst_n             , //  
  input       [DATA_WIDTH -1:0] pwdata            , //
  input       [ADDR_WIDTH -1:0] paddr             , //
  input                         p_valid_wr        , //
  input       [REG_WIDTH -1:0]  clear_data        , //
  input       [REG_WIDTH -1:0]  red_data          , //
  input       [REG_WIDTH -1:0]  green_data        , //
  input       [REG_WIDTH -1:0]  blue_data         , //
  input       [REG_WIDTH -1:0]  infrared_data     , //
  input                         nack              , //
  input                         bsy               , //
  output reg  [REG_WIDTH -1:0]  reg_config        , //
  output reg  [REG_WIDTH -1:0]  reg_clear_ch      , //
  output reg  [REG_WIDTH -1:0]  reg_red_ch        , //
  output reg  [REG_WIDTH -1:0]  reg_green_ch      , //
  output reg  [REG_WIDTH -1:0]  reg_blue_ch       , //
  output reg  [REG_WIDTH -1:0]  reg_infrared_ch   , //
  output reg  [REG_WIDTH -1:0]  reg_seed          , //
  output reg  [REG_WIDTH -1:0]  reg_status          //
);

// ----------------
// Local parameters
// ----------------
localparam ADDR_CONFIG      = 5'h00;
localparam ADDR_CLEAR_CH    = 5'h02;
localparam ADDR_RED_CH      = 5'h04;
localparam ADDR_GREEN_CH    = 5'h06;
localparam ADDR_BLUE_CH     = 5'h08;
localparam ADDR_INFRARED_CH = 5'h0C;
localparam ADDR_SEED        = 5'h10;

wire [2:0]  status_fields;
wire        shutdown; 

assign shutdown = ~reg_config[0];

assign status_fields = {(nack),       // bit[2] - NACK from I2C
                        (bsy),        // bit[1] - BUSY on I2C Bus
                        (shutdown)};  // bit[0] - ON/OFF
// CONFIG REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)                                reg_config <= {{(REG_WIDTH-1){1'b0}}, 1'b1};  else 
  if(p_valid_wr && (paddr == ADDR_CONFIG))  reg_config <= pwdata[15:0];
end

// SEED REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)                              reg_seed <= {REG_WIDTH{1'b0}};  else 
  if(p_valid_wr && (paddr == ADDR_SEED))  reg_seed <= pwdata[15:0];
end

// CLEAR COLOR REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)          reg_clear_ch <= {REG_WIDTH{1'b0}};                    else
  if(~reg_config[1])  reg_clear_ch <= {REG_WIDTH{1'b0}};                    else
  if(~reg_config[6])  reg_clear_ch <= {clear_data[7:0], clear_data[15:8]};  else
                      reg_clear_ch <= clear_data;
end

// RED COLOR REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)          reg_red_ch <= {REG_WIDTH{1'b0}};                else
  if(~reg_config[2])  reg_red_ch <= {REG_WIDTH{1'b0}};                else
  if(~reg_config[6])  reg_red_ch <= {red_data[7:0], red_data[15:8]};  else
                      reg_red_ch <= red_data;
end

// GREEN COLOR REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)          reg_green_ch <= {REG_WIDTH{1'b0}};                    else
  if(~reg_config[3])  reg_green_ch <= {REG_WIDTH{1'b0}};                    else
  if(~reg_config[6])  reg_green_ch <= {green_data[7:0], green_data[15:8]};  else
                      reg_green_ch <= green_data;
end

// BLUE COLOR REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)          reg_blue_ch <= {REG_WIDTH{1'b0}};                 else
  if(~reg_config[4])  reg_blue_ch <= {REG_WIDTH{1'b0}};                 else
  if(~reg_config[6])  reg_blue_ch <= {blue_data[7:0], blue_data[15:8]}; else
                      reg_blue_ch <= blue_data;
end

// INFRARED REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)          reg_infrared_ch <= {REG_WIDTH{1'b0}};                         else
  if(~reg_config[5])  reg_infrared_ch <= {REG_WIDTH{1'b0}};                         else
  if(~reg_config[6])  reg_infrared_ch <= {infrared_data[7:0], infrared_data[15:8]}; else
                      reg_infrared_ch <= infrared_data;
end

// STATUS REGISTER
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)            reg_status      <= {REG_WIDTH{1'b0}};                 else
  if(|status_fields)    reg_status[2:0] <= reg_status[2:0] | status_fields;
end

endmodule