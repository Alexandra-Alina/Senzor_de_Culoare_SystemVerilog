module senzor_top #(
parameter ADDR_WIDTH = 5,
parameter DATA_WIDTH = 32
)(
  // System interface
  input clk                               , // System clock; used on the APB interface
  input rst_n                             , // System reset; Active low

  // APB interface
  input                           psel    , // Select; Indicates the start of the first transfer phase
  input                           penable , // Enable; Indicates the start of the second transfer phase  
  input       [ADDR_WIDTH -1:0]   paddr   , // Address
  input                           pwrite  , // Write/Read enable
  input       [DATA_WIDTH -1:0]   pwdata  , // Write data
  output                          pready  , // Ready; Indicates that the Slave has completed the transfer
  output reg  [DATA_WIDTH -1:0]   prdata  , // Read data
  output                          pslverr   // Slave error; Is asserted together with pready if the Slave encountered an error during a transfer

  // I2C interface
  inout                           scl     , // Serial clock
  inout                           sda       // Serial data
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

// Registers
wire [15:0] reg_config;       // Registrul de configurare - R/W
                              // bit[15] - Reserved
                              // bit[14:8] - Adresa I2C a senzorului 
                              // bit[7] - Reserved
                              // bit[6] - Endianess
                              // bit[5] - Infrared_channel_on
                              // bit[4] - Blue_channel_on
                              // bit[3] - Green_channel_on
                              // bit[2] - Red_channel_on
                              // bit[1] - Clear_channel_on
                              // bit[0] - SD

wire [15:0] reg_clear_ch;     // Lumina alba - RO
wire [15:0] reg_red_ch;       // Culoarea rosu - RO
wire [15:0] reg_green_ch;     // Culoarea verde - RO
wire [15:0] reg_blue_ch;      // Culoarea albastra - RO
wire [15:0] reg_infrared_ch;  // Lumina infrarosie - RO
wire [15:0] reg_seed;         // Seed pentru LFSR - R/W


// Wires
wire p_valid_wr;

assign pready = psel & penable;
assign pslverr = pready && ((paddr > 5'h18) || (|paddr[1:0]));
assign p_valid_wr = psel & penable & pwrite & pready & ~reg_freeze;

always @(posedge clk) begin
  case (paddr)
    ADDR_CONFIG:      prdata <= {16'h0, reg_config};
    ADDR_CLEAR_CH:    prdata <= {16'h0, reg_clear_ch};
    ADDR_RED_CH:      prdata <= {16'h0, reg_red_ch};
    ADDR_GREEN_CH:    prdata <= {16'h0, reg_green_ch};
    ADDR_BLUE_CH:     prdata <= {16'h0, reg_blue_ch};
    ADDR_INFRARED_CH: prdata <= {16'h0, reg_infrared_ch}; 
    ADDR_SEED:        prdata <= {16'h0, reg_seed};
    default:          prdata <= 32'h0; 
  endcase
end
/*
registers #(

) i_registers(
  .clk(clk),
  .rst_n(rst_n),
  .pwdata(pwdata),
  .paddr(paddr),
  .p_valid_wr(p_valid_wr),
  .reg_config(reg_config),
  .reg_clear_ch(reg_clear_ch),
  .reg_red_ch(reg_red_ch),
  .reg_green_ch(reg_green_ch),
  .reg_blue_ch(reg_blue_ch),
  .reg_infrared_ch(reg_infrared_ch),
  .reg_seed(reg_seed)
);
*/


endmodule : senzor_top