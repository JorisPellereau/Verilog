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

   // == VIRTUAL I/F ==
   // DATA_COLLECTOR interface
   virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_WIDTH) data_collector_vif;   
   // =================

   // == Interface passed in Virtual I/F ==
   function new(virtual data_collector_intf #(G_NB_COLLECTOR, G_DATA_WIDTH) data_collector_nif);
      this.data_collector_vif = data_collector_nif; // New Virtual Interface      
   endfunction // new   
   // =====================================

   // == LIST of DATA COLLECTOR COMMANDS ==
   // DATA_COLLECTOR[alias] INIT(i, File) // Init collect file for alias index i

   // DATA_COLLECTOR[alias] START(i)      // Start collect file for alias index i

   // DATA_COLLECTOR[alias] STOP(i)       // Stop collect file for alias index i

   // DATA_COLLECTOR[alias] CLOSE(i)      // Close collect file for alias index i
   // =====================================

   // Associative array of DATA_COLLECTOR Commands
   int DATA_COLLECTOR_CMD_ARRAY [string] = '{
					     "INIT"  : 0,
					     "START" : 1,
					     "STOP"  : 2,
					     "CLOSE" : 3
					     };
   
endclass // tb_data_collector_class
