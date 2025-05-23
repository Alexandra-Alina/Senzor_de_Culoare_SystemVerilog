`ifndef __scoreboard_coverage_collector
`define __scoreboard_coverage_collector

`include "uvm_macros.svh"
import uvm_pkg::*;

//aceasta clasa este folosita pentru a se vedea cate combinatii de intrari au fost trimise DUT-ului; aceasta clasa este doar de model, si probabil va fi modificata, deoarece in general nu ne intereseaza sa obtinem in simulare toate combinatiile posibile de intrari ale unui DUT
class coverage_scoreboard extends uvm_component;
  
  //componenta se adauga in baza de date
  `uvm_component_utils(coverage_scoreboard)
  
  //se declara pointerul catre monitorul care da datele asupra carora se vor face masuratorile de coverage
  scoreboard p_scoreboard;
  
  covergroup config_register; // Verifica registrul de configurare
    option.per_instance = 1;
    
    // Coverpoint reg_config 
    coverpoint p_scoreboard.reg_config[15:14]; // FREQ     00 -> 100KHz, 01 -> 400KHz, 10 -> 1Mhz,  11 -> 3.4Mhz  
    coverpoint p_scoreboard.reg_config[13:7]{  // ADDR
      bins minimum_address = {0};
      bins maximum_address = {7'b1111111};
      bins some_addresses[3] = {[1:$]};
    }
    coverpoint p_scoreboard.reg_config[6]; // ENDIAN       0 -> Little Endian, 1 -> Big Endian
    coverpoint p_scoreboard.reg_config[5]; // INFRARED_ON  1 -> Power On, 0 -> Power Off (default)
    coverpoint p_scoreboard.reg_config[4]; // BLUE_ON      1 -> Power On, 0 -> Power Off (default)
    coverpoint p_scoreboard.reg_config[3]; // GREEN_ON     1 -> Power On, 0 -> Power Off (default)
    coverpoint p_scoreboard.reg_config[2]; // RED_ON       1 -> Power On, 0 -> Power Off (default)
    coverpoint p_scoreboard.reg_config[1]; // CLEAR_ON     1 -> Power On, 0 -> Power Off (default)
    coverpoint p_scoreboard.reg_config[0]; // SD           1 -> Power On, 0 -> Power Off (default)

    // Coverpoint clear_ch
    coverpoint p_scoreboard.reg_clear_ch[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Adrese de interes
    }

    // Coverpoint red_ch
    coverpoint p_scoreboard.reg_red_ch[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Valori de interes
    }

    // Coverpoint green_ch
    coverpoint p_scoreboard.reg_green_ch[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Valori de interes
    }

    // Coverpoint blue_ch
    coverpoint p_scoreboard.reg_blue_ch[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Valori de interes
    }
    
    // Coverpoint infrared_ch
    coverpoint p_scoreboard.reg_infrared_ch[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Valori de interes
    }

    // Coverpoint seed
    coverpoint p_scoreboard.reg_seed[15:0]{
      bins minimum_value = {0};
      bins maximum_value = {16'b1111111111111111};
      bins some_values[3] = {[1:$]}; // Valori de interes
    }
   
   // Coverpoint status   
    coverpoint p_scoreboard.reg_status[2]; // NACK     0 -> ACK, 1 -> NACK          
    coverpoint p_scoreboard.reg_status[1]; // BSY      0 -> Available, 1 -> Busy
    coverpoint p_scoreboard.reg_status[0]; // STATUS   0 -> Off, 1 -> On

  endgroup
  
function new(string name, uvm_component parent);
    super.new(name, parent);
    $cast(p_scoreboard, parent);
    config_register = new();
endfunction
  
endclass
`endif