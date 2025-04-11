`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)

  apb_driver                    apb_drv  ;
  uvm_sequencer #(apb_trans)    apb_seqr ;
  apb_monitor                   apb_mon  ;
 
  local int is_active = 1;  //0 inseamna agent pasiv; 1 inseamna agent activ

  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

           
    apb_mon = apb_monitor::type_id::create("apb_mon", this);

    if(is_active == UVM_ACTIVE) begin
      apb_drv  = apb_driver::type_id::create("apb_drv", this);
      apb_seqr = uvm_sequencer#(apb_trans)::type_id::create("apb_seqr", this);
    end
  endfunction:build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(is_active == UVM_ACTIVE) begin
      apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
    end
  endfunction:connect_phase
  
endclass:apb_agent

`endif