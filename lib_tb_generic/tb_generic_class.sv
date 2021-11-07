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

   // Struct for Command and number of Arg
   struct {      
      string cmd;
      int    arg_number;
   } cmd_struct;
   

   // == Task Decode Scenario Line ==
   task decod_scn_line(input string  line,                     // Current line to decod
		       input int  tb_module_cmd [string],      // Command of the Module (UART[..] , DATA_COLLECTOR[..] etc)
		       input int  alias_list[string],          // Associative array with ALIASES
		       input int  tb_module_cmd_list [string], // Associative Array with commands of current TB module

		       output logic  o_cmd_exist, // A flag that indicate s if the current command exists
		       output string o_alias,     // The return Alias
		       output string o_cmd,       // Decoded command
		       output int o_cmd_args[string]); // Args of the commands
      begin

	 // Internal Variables
	 int tb_module_cmd_len    = 0; // Len of tb_module_cmd
	 int line_length          = 0; // Length of the line
	 int pos_0                = 0; // Position of [ character
	 int pos_1                = 0; // Position of ] character
	 int first_space_position = 0; // First position of " " character
	 
	 int i; // Loop Index

	 string alias_str; // Extracted Alias of the line
	 
	 
	 // Get the length of the tb_module_cmd
	 tb_module_cmd_len = tb_module_cmd.len();

	 // Get the length of the line
	 line_length = line.len();
	 

	 
	 // Check if command exists
	 if(line.substr(0, tb_module_cmd_len - 1) == tb_module_cmd) begin

	    // Get alias between [] and check if alias exist	    
	    for(i = 0; i < line_length; i++) begin
	       if(line.getc(i) == "[") begin
		  pos_0 = i;		  
	       end
	       
	       if(line.getc(i) == "]") begin
		  pos_1 = i;		  
	       end	       
	    end

	    // Get Alias
	    alias_str = line.substr(pos_0 + 1, pos_1 - 1); // RM "[" and "]"

	    // Get First space position
	    first_space_position = pos_1 + 1;
	    
	    
	 end
	 
      end
   endtask // decod_scn_line
   
   // ===============================
endclass; // tb_generic_class

