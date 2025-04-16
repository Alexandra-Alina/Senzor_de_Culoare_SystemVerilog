`ifndef I2C_INTERFACE_SV
`define I2C_INTERFACE_SV

interface i2c_interface (input clk, input rst_n);

  // Signals
  triand scl; // serial clock
  triand sda; // serial data
  
  reg stable_assertion_enable;

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

  // Assertions

    initial forever begin
    @(posedge scl);
    //@(negedge clk);
    stable_assertion_enable = 1'b1;
     @(negedge scl);
    stable_assertion_enable = 1'b0;
    //@(posedge clk);
  end
  

  // Signals are never X or Z
  assert property (@(posedge clk) disable iff (!rst_n) !$isunknown(scl))
    else $error("I2C Interface: !!! scl is unknown !!!");
  assert property (@(posedge clk) disable iff (!rst_n) !$isunknown(sda))
    else $error("I2C Interface: !!! sda is unknown !!!");

  // SDA doesn't change when SCL is HIGH 

 assert property (@(clk) disable iff (!rst_n) stable_assertion_enable |-> $stable(sda))
    else $error("I2C Interface: !!! SDA changed when SCL high!!!");


  assert property (@(posedge clk) disable iff (!rst_n)
   $fell(scl) |-> ##[0:10000] $rose(scl);
    else $error("I2C Interface: !!! scl is unknown !!!");

    //scl toggle intre start si stop

endinterface:i2c_interface

`endif 
