module testbench;

// Localparameteres
localparam TEST_ADDR_WIDTH = 5;
localparam TEST_DATA_WIDTH = 32;

// System interface
wire                        clk       ; // System clock; used on th APB interface
wire                        rst_n     ; // System reset; Active low

// APB interface
wire                        psel      ; // Select; Indicates the start of the first transfer phase
wire                        penable   ; // Enable; Indicates the start of the second transfer phase
wire [TEST_ADDR_WIDTH -1:0] paddr     ; // Address
wire                        pwrite    ; // Write/Read enable
wire [TEST_DATA_WIDTH -1:0] pwdata    ; // Write data
wire                        pready    ; // Ready; Indicates that the Slave has completed the transfer
wire [TEST_DATA_WIDTH -1:0] prdata    ; // Read data
wire                        pslverr   ; // Slave error; Is asserted with pready if the Slave encountered an error during a transfer

// I2C interface
triand                      scl       ; // Serial clock
triand                      sda       ; // Serial data


clk_rst_generator #(
  .CLK_PERIOD(10)
) i_clk_rst_generator(
  .clk    (clk                ),
  .rst_n  (rst_n              )
);

senzor_top #(
  .ADDR_WIDTH(TEST_ADDR_WIDTH ),
  .DATA_WIDTH(TEST_DATA_WIDTH )
) DUT (
  .clk      (clk              ),
  .rst_n    (rst_n            ),
  .psel     (psel             ),
  .penable  (penable          ),
  .paddr    (paddr            ),
  .pwrite   (pwrite           ),
  .pwdata   (pwdata           ),
  .pready   (pready           ),
  .prdata   (prdata           ),
  .pslverr  (pslverr          ),
  .scl      (scl              ),
  .sda      (sda              )
);

endmodule