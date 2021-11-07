//                              -*- Mode: Verilog -*-
// Filename        : tb_generic_class.sv
// Description     : Class for Generic Testbench
// Author          : Linux-JP
// Created On      : Sun Nov  7 13:15:05 2021
// Last Modified By: Linux-JP
// Last Modified On: Sun Nov  7 13:15:05 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_generic_class;

   // == Task Decode Scenario Line ==
   task decod_scn_line(input string line,
		       input int     tb_module_cmd_list [string],

		       output logic  o_cmd_exist,
		       output string o_alias,
		       output string o_cmd,
		       output string o_cmd_args);
      begin
	 
      end
   endtask // decod_scn_line
   
   // ===============================
endclass; // tb_generic_class

