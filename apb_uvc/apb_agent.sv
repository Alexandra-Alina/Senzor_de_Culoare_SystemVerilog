`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent #(APB_AW=32,APB_DW=32) extends uvm_agent;

  // apb_agent_kind_t agent_kind;
  // `uvm_component_utils_begin(apb_agent #(APB_AW,APB_DW))
  //   `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  //   `uvm_field_enum(apb_agent_kind_t, agent_kind, UVM_ALL_ON)
  // `uvm_component_utils_end

  `uvm_component_utils(apb_agent #(APB_AW,APB_DW))

  apb_driver   #(APB_AW,APB_DW)                 apb_drv  ;
  uvm_sequencer #(apb_trans#(APB_AW,APB_DW))    apb_seqr ;
  apb_monitor  #(APB_AW,APB_DW)                 apb_mon  ;
 
  local int is_active = 1;  //0 inseamna agent pasiv; 1 inseamna agent activ

  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

  //    if (!uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active", is_active))
  //	    `uvm_fatal(get_type_name(), {"Agent type must be set for: ",get_full_name(),""})
 
           
    apb_mon = apb_monitor#(APB_AW,APB_DW)::type_id::create("apb_mon", this);

    if(is_active == UVM_ACTIVE) begin
      apb_drv  = apb_driver#(APB_AW,APB_DW)::type_id::create("apb_drv", this);
      apb_seqr = uvm_sequencer#(apb_trans#(APB_AW,APB_DW))::type_id::create("apb_seqr", this);
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