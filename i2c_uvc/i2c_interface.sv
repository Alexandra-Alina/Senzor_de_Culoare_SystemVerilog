`ifndef I2C_INTERFACE_SV
`define I2C_INTERFACE_SV

interface i2c_interface (input clk, input rst_n);

  // Signals
  triand scl; // serial clock
  triand sda; // serial data

  // Clocking blocks
  // Slave 
  clocking s_cb @(posedge clk);
    input scl;
    inout sda;
  endclocking:s_cb

  // Monitor 
  clocking mon_cb @(posedge clk);
    input scl;
    input sda;
  endclocking:mon_cb 

endinterface:i2c_interface

`endif 
