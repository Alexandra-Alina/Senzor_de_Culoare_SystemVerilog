`ifndef I2C_TRANS_SV
`define I2C_TRANS_SV
  
class i2c_trans #(I2C_AW=7,I2C_DW=8) extends uvm_sequence_item;
  
  rand bit [I2C_AW-1:0]     addr        ;    
  rand i2c_access_kind_t    access      ;       
  rand int                  nr_words    ; 
  rand bit [I2C_DW-1:0]     data [$:255];   
  rand i2c_resp_kind_t      addr_resp   ;   
  rand i2c_resp_kind_t      data_resp   ; 
  
  `uvm_object_utils_begin(i2c_trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_enum(i2c_access_kind_t, access, UVM_ALL_ON)
    `uvm_field_int(nr_words, UVM_ALL_ON)
    `uvm_field_queue_int(data, UVM_ALL_ON)
    `uvm_field_enum(i2c_resp_kind_t, addr_resp, UVM_ALL_ON)
    `uvm_field_enum(i2c_resp_kind_t, data_resp, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint data_order_c {solve nr_words before data;}
  constraint nr_words_c {nr_words == 5;}
  constraint data_c {data.size() == nr_words;}

  function new (string name = "i2c_trans");
    super.new(name);
  endfunction
  
endclass:i2c_trans

`endif
