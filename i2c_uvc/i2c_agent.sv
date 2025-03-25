`ifndef I2C_AGENT_SV
`define I2C_AGENT_SV

class i2c_agent #(I2C_AW=7,I2C_DW=8) extends uvm_agent;

  i2c_config i2c_cfg;

  `uvm_component_utils(i2c_agent #(I2C_AW,I2C_DW))

  i2c_monitor #(I2C_AW,I2C_DW) i2c_mon;

  function new(string name = "i2c_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(i2c_config)::get(this,"","i2c_cfg", i2c_cfg))
	    `uvm_fatal(get_type_name(), {"Agent configuration must be set for: ",get_full_name(),""})
           
    i2c_mon = i2c_monitor#(I2C_AW,I2C_DW)::type_id::create("i2c_mon", this);
  endfunction:build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction:connect_phase

endclass:i2c_agent

`endif