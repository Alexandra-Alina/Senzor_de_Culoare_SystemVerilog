`ifndef TEST_BASE_SV
`define TEST_BASE_SV

//se includ fisierele la care testul trebuie sa aiba acces
`include "./../environment.sv"
`include "./../apb_uvc/apb_seq_lib.sv"
//`include "./../secventa_senzor_temperatura.sv"


class test_base extends uvm_test;
  `uvm_component_utils(test_base)
  
  //se declara constructorul testului
  function new(string name = "test_base", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  environment env;
  
  apb_5_packets apb_5_packets_seq;
  
  //  function void start_of_simulation_phase(uvm_phase phase);
  //   super.start_of_simulation_phase(phase);
  //   this.print();
  //   uvm_top.print_topology();
  // endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = environment::type_id::create("env", this);
    
    //Se creaza secventele de date de intrare (in cazul de fata avem doar o secventa, deoarece avem doar un agent activ), dandu-se apoi valori aleatoare campurilor declarate cu cuvantul cheie "rand" din interiorul clasei "secventa_intrari"
    
    apb_5_packets_seq =  apb_5_packets::type_id::create("apb_5_packets_seq");
    apb_5_packets_seq.randomize();
    
    // buton_apasari_frecvente_seq =  secventa_apasari_buton_frecvente::type_id::create("buton_apasari_frecvente_seq");
    // buton_apasari_frecvente_seq.randomize();
    
    // fast_switch_seq = secventa_switch_fast::type_id::create("fast_switch_seq");
    // fast_switch_seq.randomize();
    
    // apasari_buton_seq = secventa_apasari_buton::type_id::create("apasari_buton_seq");
    // apasari_buton_seq.randomize();
    
    // senzor_temperatura_seq = secventa_senzor_temperatura::type_id::create("senzor_temperatura_seq");
    // senzor_temperatura_seq.randomize();
    
    // senzor_umiditate_seq =  secventa_senzor_umiditate ::type_id::create("senzor_umiditate_seq");
    // senzor_umiditate_seq.randomize();
    
    // senzor_rand_seq = secventa_senzor_rand::type_id::create("senzor_rand_seq");
    // senzor_rand_seq.randomize();
    
    // senzor_val_limita_seq = secventa_senzor_val_limita::type_id::create("senzor_val_limita_seq");
    // senzor_val_limita_seq.randomize();
    
    // senzor_intens_luminoasa_seq = secventa_senzor_intens_luminoasa::type_id::create("senzor_intens_luminoasa_seq");
    // senzor_intens_luminoasa_seq.randomize();
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);

    //se apeleaza functia run_phase din clasa parinte
    super.run_phase(phase);
    
    //se activeaza un martor ("obiectie") ca am inceput o activitate; pana cand nu se termina activitatea, simulatorul va sti ca nu trebuie sa intrerupe faza "run" din rularea testului; de aceea trebuie sa avem grija ca la sfarsitul acestei functii sa dezactivam martorul de activitate
    phase.raise_objection(this);
    
    //se aserteaza semnalele de reset din interfete
    // apply_reset();
    `uvm_info("TEST_BASE", "real execution begins", UVM_NONE);
    
    //in bulca fork join se pot porni in paralel secventele mediului de verificare

      begin
     `ifdef DEBUG
        $display("va incepe sa ruleze secventa: fast_switch_seq pentru agentul activ agent_buton");
      `endif; 
     	apb_5_packets_seq.start(env.apb_mst_agnt.apb_seqr);
      `ifdef DEBUG
        $display("s-a terminat de rulat secventa pentru agentul activ agent_buton");
      `endif;
      end
      
      
    //dupa ce s-au terminat secventele care trimit stimuli DUT-ului, toate semnalele de intrare se pun in 0
  //   @(posedge vif_sensor_dut.clk_i);
  //   vif_sensor_dut.temperature_i <= 0;
  //   vif_sensor_dut.humidity_i <= 0;
  //   vif_sensor_dut.luminous_intensity_i <= 0;
  //   vif_sensor_dut.valid_i <= 0;
  //  // vif_sensor_dut.ready_o <= 0;
  //   vif_button_dut.enable_i <= 0;
     #10000//se mai asteapta 100 de unitati de timp inainte sa se dezactiveze martorul de activitate, actiune care va permite simulatorului sa incheie activitatea
	//se dezactiveaza martorul 
    phase.drop_objection(this);
    endtask
  
  //traficul de pe interfete este resetat
  // virtual task apply_reset();
  //   vif_sensor_dut.reset_n <= 1;
  //   vif_sensor_dut.temperature_i <= 0;
  //   vif_sensor_dut.humidity_i <= 0;
  //   vif_sensor_dut.luminous_intensity_i <= 0;
  //   vif_sensor_dut.valid_i <= 0;
  //  // vif_sensor_dut.ready_o <= 0;
  //   vif_button_dut.enable_i <= 0;
  //   `ifdef DEBUG
  //   $display("am asertat resetul");
  //   `endif;
  //   repeat(15) @(posedge vif_sensor_dut.clk_i);
  //   vif_sensor_dut.reset_n <= 0;
  //   `ifdef DEBUG
  //   $display("%t am deasertat resetul", $time());
  //   `endif;
  // endtask
  
  //in aceasta faza, care se desfasoara dupa faza de run in care se intampla actiunea propriu-zisa in mediul de verificare, afisam valorile de coverage
  virtual function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
   // $display("STDOUT: Valorile de coverage obtinute pentru senzor sunt: %3.2f%% ",  		   env.scb.coverage_collector.config_register.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru buton sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.agent_buton_din_mediu.monitor_agent_buton_inst0.colector_coverage_buton_inst.buton_cg.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru actuator sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.agent_actuator_din_mediu.monitor_agent_actuator_inst0.coverage_actuator_inst.actuator_cg.get_inst_coverage());
    
    // $display("STDOUT: Valorile de coverage obtinute pentru scorboard sunt: %3.2f%% ",  		   mediu_de_verificare_ambient.IO_scorboard.colector_coverage_scoreboard.date_procesate_cg.get_inst_coverage());

      
    svr = uvm_report_server::get_server();
 
    //se numara cate erori si cate atentionari (WARNINGs) au fost pe parcursul testului; daca a existat macar una, inseamna ca testul a picat, si trebuie reparat
    $display("numar erori: %0d \nnumar warninguri: %0d",svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR), svr.get_severity_count(UVM_WARNING));
    if(svr.get_severity_count(UVM_FATAL) +
       svr.get_severity_count(UVM_ERROR)>0 +
       svr.get_severity_count(UVM_WARNING) > 0) 
    begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     	`uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     	`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end else begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    
    //se da directiva ca testul sa se incheie
    $finish();
  endfunction 

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction:end_of_elaboration_phase

endclass


`endif