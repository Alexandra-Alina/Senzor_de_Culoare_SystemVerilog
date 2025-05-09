`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV
  
   `include "./../apb_uvc/apb_defines.sv"
   `include "./../apb_uvc/apb_types.sv"
   `include "./../apb_uvc/apb_trans.sv"
class apb_sequencer extends uvm_sequencer;

    `uvm_component_utils(apb_sequencer)
  
    function new(string name, uvm_component parent);   
      super.new(name, parent);     
    endfunction
 
endclass: apb_sequencer

`endif