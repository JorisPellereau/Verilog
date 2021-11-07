//                              -*- Mode: Verilog -*-
// Filename        : data_collector.sv
// Description     : Data collector
// Author          : Linux-JP
// Created On      : Sun Nov  7 11:40:39 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov  7 11:40:39 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

interface data_collector_intf #(
				parameter G_NB_COLLECTOR = 2,
				parameter G_DATA_WIDTH   = 32
				);

   logic  clk [G_NB_COLLECTOR - 1 : 0];

   logic  s_init_file [G_NB_COLLECTOR - 1 : 0];    // Open file command
   logic  s_file_is_init [G_NB_COLLECTOR - 1 : 0]; // File is init
   
   logic  s_close_file [G_NB_COLLECTOR - 1 : 0];  // Close file
   
   logic  s_start_collect [G_NB_COLLECTOR - 1 : 0];
   logic  s_stop_collect [G_NB_COLLECTOR - 1 : 0];

   // ALIASES
   int 				  data_collector_alias [string];
   
   int    s_file [G_NB_COLLECTOR - 1 : 0];

   string  s_file_and_path [G_NB_COLLECTOR - 1 : 0];
   
endinterface // data_collector_intf

   
module data_collector #(
			parameter G_NB_COLLECTOR = 2,
			parameter G_DATA_WIDTH   = 32
			)
   (
    input  clk [G_NB_COLLECTOR - 1 : 0],
    input  rst_n [G_NB_COLLECTOR - 1 : 0],

    input [G_DATA_WIDTH - 1 : 0] i_data [G_NB_COLLECTOR - 1 : 0],

    // DATA COLECTOR INTERFACE
    data_collector_intf data_collector_if
    );

   genvar 			   i;
   
   // == Init File management ==
   // Manage open file
   generate
      for(i = 0 ; i < G_NB_COLLECTOR ; i++) begin : g_init_file_mngt 
	 // Wait on Rising Edge of Init File command
	 always @(posedge data_collector_if.s_init_file[i]) begin
	    data_collector_if.s_file[i] = $fopen(data_collector_if.s_file_and_path[i], "w"); // Create and overwrite if it exists	    
	 end	
      end
   endgenerate

   // Manage closing file
   generate
      for(i = 0 ; i < G_NB_COLLECTOR ; i++) begin : g_close_file_mngt
	 // Wait on Rising Edge of Init File command
	 always @(posedge data_collector_if.s_close_file[i]) begin
	    $fclose(data_collector_if.s_file[i]); // Close file 
	 end	
      end
   endgenerate   
   // =============================


   // == Write in file Management ==
   
   // ==============================

endmodule // data_collector

