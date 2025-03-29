`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment #(APB_AW=32,APB_DW=32,I2C_AW=7,I2C_DW=8) extends uvm_env;

  `uvm_component_utils(environment #(APB_AW,APB_DW,I2C_AW,I2C_DW))

  apb_agent #(APB_AW,APB_DW) apb_mst_agnt;
  i2c_agent #(I2C_AW,I2C_DW) i2c_slv_agnt;
  bit [I2C_AW-1:0] i2c_address;


  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // create APB agent
    apb_mst_agnt = apb_agent#(APB_AW,APB_DW)::type_id::create("apb_mst_agnt", this);
    // create I2C agent
    i2c_slv_agnt = i2c_agent#(I2C_AW,I2C_DW)::type_id::create("i2c_slv_agnt", this);
    i2c_address = $random;
    uvm_config_db#(uvm_bitstream_t)::set(this, "i2c_slv_agnt.i2c_address", "i2c_address", i2c_address);
  endfunction:build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction:connect_phase

endclass:environment

`endif