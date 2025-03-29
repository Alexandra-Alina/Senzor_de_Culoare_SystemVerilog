`ifndef I2C_AGENT_SV
`define I2C_AGENT_SV

class i2c_agent #(I2C_AW=7,I2C_DW=8) extends uvm_agent;

  bit [I2C_AW-1:0] i2c_address;

  `uvm_component_utils(i2c_agent #(I2C_AW,I2C_DW))

  i2c_driver    #(I2C_AW,I2C_DW) i2c_drv ;
  i2c_monitor   #(I2C_AW,I2C_DW) i2c_mon;

  function new(string name = "i2c_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(uvm_bitstream_t)::get(this,"","i2c_address", i2c_address))
	    `uvm_fatal(get_type_name(), {"Agent address must be set for: ",get_full_name(),""})
           
    i2c_mon = i2c_monitor#(I2C_AW,I2C_DW)::type_id::create("i2c_mon", this);
    i2c_drv  = i2c_driver#(I2C_AW,I2C_DW)::type_id::create("i2c_drv", this);
  endfunction:build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    i2c_drv.address = i2c_address;
  endfunction:connect_phase

endclass:i2c_agent

`endif