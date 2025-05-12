class registers_seq extends apb_base_seq;

  `uvm_object_utils(registers_seq)

  bit [4:0] addr [3:0] = {'h0, 'h2, 'h4, 'h6, 'h8, 'hC, 'h10, 'h12};

  function new(string name="registers_seq");
    super.new(name);
  endfunction:new
  
  virtual task body();
    // read default values
    foreach (addr[i]) begin
      `uvm_do_with(req, { req.access == APB_READ;
                          req.addr   == addr[i];})
    end

    // write random values
    foreach (addr[i]) begin
      `uvm_do_with(req, { req.access == APB_WRITE;
                          req.addr   == addr[i];
                          req.data   == $urandom_range(0, 255);})
    end

    // read back values
    foreach (addr[i]) begin
      `uvm_do_with(req, { req.access == APB_READ;
                          req.addr   == addr[i];})
    end
    #200ns;
  endtask:body

endclass:registers_seq

class test_registers extends test_base;

  `uvm_component_utils(test_registers)

  function new(string name="test_registers", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,"env.apb_mst_agnt.apb_seqr.run_phase", "default_sequence", registers_seq::get_type());

    `uvm_info(get_type_name(), $sformatf("Start test_registers"), UVM_LOW)
  endfunction:build_phase

endclass:test_registers