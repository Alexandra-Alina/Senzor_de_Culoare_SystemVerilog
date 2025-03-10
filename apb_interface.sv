ifndef APB_INTERFACE_SV
define APB_INTERFACE_SV

interface apb_interface #(APB_AW=32,APB_DW=32) (input clk, input rst_n);

  // Signals
  wire [APB_AW-1:0] paddr   ; // address bus
  wire              psel    ; // select 
  wire              penable ; // enable
  wire              pwrite  ; // write/read selector
  wire [APB_DW-1:0] pwdata  ; // data from Master
  wire [APB_DW-1:0] prdata  ; // data from Slave
  wire              pready  ; // acknowledge
  wire              pslverr ; // error

  // Clocking blocks
  // Driver
  clocking m_cb @(posedge clk);
    output paddr   ; 
    output psel    ;
    output penable ;
    output pwrite  ; 
    output pwdata  ;
    input  prdata  ;
    input  pready  ; 
    input  pslverr ;
  endclocking: m_cb

  // Monitor
  clocking mon_cb @(posedge clk);
    input paddr   ;
    input psel    ;
    input penable ;
    input pwrite  ; 
    input pwdata  ;
    input prdata  ;
    input pready  ; 
    input pslverr ;
  endclocking: mon_cb

endinterface:apb_interface

`endif