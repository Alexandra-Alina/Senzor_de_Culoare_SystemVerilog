`ifndef TEST_REGISTERS_SV
`define TEST_REGISTERS_SV



`include "./../environment.sv"
`include "./../apb_uvc/apb_seq_lib.sv"


class test_registers extends test_base;

  `uvm_component_utils(test_registers)
  

  registers_seq apb_registers_seq;
  environment env;


  function new(string name="test_registers", uvm_component parent);
    super.new(name, parent);
  endfunction:new


  virtual function void build_phase(uvm_phase phase);
    //super.build_phase(phase);

  //  uvm_config_db #(uvm_object_wrapper)::set(this,"env.apb_mst_agnt.apb_seqr.run_phase", "default_sequence", registers_seq::get_type());
    env = environment::type_id::create("env", this);
    apb_registers_seq =  registers_seq::type_id::create("apb_registers_seq");
    
    
    `uvm_info(get_type_name(), $sformatf("Start test_registers"), UVM_LOW)
  endfunction:build_phase

  virtual task run_phase(uvm_phase phase);
    //super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("TEST_REGISTER", "real execution begins", UVM_NONE);
      begin
     `ifdef DEBUG
        $display("va incepe sa ruleze secventa: fast_switch_seq pentru agentul activ agent_buton");
      `endif; 
     	apb_registers_seq.start(env.apb_mst_agnt.apb_seqr);
      `ifdef DEBUG
        $display("s-a terminat de rulat secventa pentru agentul activ agent_buton");
      `endif;
      end


   // apb_registers_seq.start(env.apb_mst_agnt.apb_seqr);

    #10000
    phase.drop_objection(this);
    endtask

  virtual function void report_phase(uvm_phase phase);
   // uvm_report_server svr;
    super.report_phase(phase);
  //  $display("STDOUT: Valorile de coverage obtinute pentru senzor sunt: %3.2f%% ",  		   env.apb_mst_agnt.apb_cov.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru buton sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.agent_buton_din_mediu.monitor_agent_buton_inst0.colector_coverage_buton_inst.buton_cg.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru actuator sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.agent_actuator_din_mediu.monitor_agent_actuator_inst0.coverage_actuator_inst.actuator_cg.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru scorboard sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.IO_scorboard.colector_coverage_scoreboard.date_procesate_cg.get_inst_coverage());

      
    // svr = uvm_report_server::get_server();
 
    // //se numara cate erori si cate atentionari (WARNINGs) au fost pe parcursul testului; daca a existat macar una, inseamna ca testul a picat, si trebuie reparat
    // $display("numar erori: %0d \nnumar warninguri: %0d",svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR), svr.get_severity_count(UVM_WARNING));
    // if(svr.get_severity_count(UVM_FATAL) +
    //    svr.get_severity_count(UVM_ERROR)>0 +
    //    svr.get_severity_count(UVM_WARNING) > 0) 
    // begin
    //   `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    //  	`uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
    //  	`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    // end else begin
    //   `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    //   `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
    //   `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    // end
    
    // //se da directiva ca testul sa se incheie
    // $finish();
  endfunction 

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction:end_of_elaboration_phase

endclass:test_registers


`endif 