//                              -*- Mode: Verilog -*-
// Filename        : tb_data_collector_class.sv
// Description     : CLASS for data_collector module
// Author          : Linux-JP
// Created On      : Sun Nov  7 12:50:43 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov  7 12:50:43 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_data_collector_class #(
				parameter G_NB_COLLECTOR = 2,
				parameter G_DATA_WIDTH   = 32
				);

   // == Struct ==
   // Struct for Command and number of Arg
   struct {      
      string cmd;
      int    arg_number;
   } cmd_struct;
   // ============

   // == INFOS. ==
   string tb_module_cmd; // Name of Testbench Module to be use in scenario
   
   // Associative array of DATA_COLLECTOR Commands
   int 	  DATA_COLLECTOR_CMD_ARRAY [string];

   cmd_struct init_cmd;
   cmd_struct start_cmd;
   cmd_struct stop_cmd;
   cmd_struct close_cmd;   
   // ============

   // == VIRTUAL I/F ==
   // DATA_COLLECTOR interface
   virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_WIDTH) data_collector_vif;   
   // =================

   // == Interface passed in Virtual I/F ==
   function new(virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_WIDTH) data_collector_nif);
      this.data_collector_vif = data_collector_nif; // New Virtual Interface
      this.tb_module_cmd = "DATA_COLLECTOR";

      // List of Command of DATA_COLLECTOR
      this.DATA_COLLECTOR_CMD_ARRAY = '{
					"INIT"  : 0,
					"START" : 1,
					"STOP"  : 2,
					"CLOSE" : 3
					};

      this.init_cmd.cmd = "INIT";
      this.init_cmd.arg_number = 2;
      
   endfunction // new   
   // =====================================

   // == LIST of DATA COLLECTOR COMMANDS ==
   // DATA_COLLECTOR[alias] INIT(i, File) // Init collect file for alias index i

   // DATA_COLLECTOR[alias] START(i)      // Start collect file for alias index i

   // DATA_COLLECTOR[alias] STOP(i)       // Stop collect file for alias index i

   // DATA_COLLECTOR[alias] CLOSE(i)      // Close collect file for alias index i
   // =====================================


   // == ADD ALIAS in Associative Array ==
   function void DATA_COLLECTOR_TB_ADD_ALIAS(string ALIAS, int alias_index);
      this.data_collector_vif.data_collector_alias[ALIAS] = alias_index;
   endfunction // DATA_COLLECTOR_TB_ADD_ALIAS   
   // ====================================
   
endclass // tb_data_collector_class
