//                              -*- Mode: Verilog -*-
// Filename        : tb_check_level_class.sv
// Description     : Class of Level Checker Testbench Module
// Author          : Linux-JP
// Created On      : Mon Nov 15 20:38:11 2021
// Last Modified By: Linux-JP
// Last Modified On: Mon Nov 15 20:38:11 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

class tb_check_level_class #(
			     parameter CHECK_SIZE  = 5,
			     parameter CHECK_WIDTH = 32
			     );
   
   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   
   // == Virtual I/F ==
   virtual check_level_intf    #(CHECK_SIZE, CHECK_WIDTH)   check_level_vif;
   // =================

   // == VARIABLES ==
   alias_list_t check_level_alias_list; // List of Alias  
   // ===============

   // == CONSTRUCTOR ==
   function new(virtual check_level_intf #(CHECK_SIZE, CHECK_WIDTH) check_level_nif);
      this.check_level_vif = check_level_nif; // Init Interface
   endfunction // new   
   // =================

   // Commands
   // CHK[ALIAS] (0x30 ERROR)
   // CHK[ALIAS] (30 OK)


   // Sel Check Level Command
   task sel_check_level_command(input string i_cmd,
				input string i_alias,
				input string i_args);
      begin

	 case(i_cmd)
	   "CHK": begin
	      check_level(i_alias, i_args);	      
	   end

	   default: $display("Error: wrong CHECK Level Command : %s", i_cmd);	   
	 endcase // case (i_cmd)
	 
      end
   endtask; // sel_check_level_command
   

   // Check Level tasl
   task check_level (
		     input string i_alias,
		     input string i_args// [`ARGS_NB]
   );
      begin
	 // Internal Variables
	 int i                 = 0; // Loop index
	 int space_position    = 0; // Space position between args	 
	 int 	check_value    = 0; //

	 string check_value_str;    // Check value string format
	 string check_type_str;     // Check type string format (ERROR - OK etc)
	 
	 
	 
	 // // ASSOCIATIVE ARRAY
         // int 	 s_alias_array [string];
         // reg [CHECK_WIDTH - 1 : 0]     s_check_value;
         // string 		       s_str;     
         // int 			       s_str_len;

	 
	 
	 // INIT ALIAS
	 /*for (int i = 0; i < CHECK_SIZE; i++) begin
	   s_alias_array[this.check_level_vif.check_alias[i]] = i;
         end*/

	 $display("Run CHK[%s] (%s) ... - %t", i_alias, i_args, $time);
	 	 
	 // == Get " " position in args ==
	 for(i = 0 ; i < i_args.len() ; i ++) begin
	    if(i_args.getc(i) == " ") begin
	       space_position = i; // Assume that only 1 space position is in the string	       
	    end	    	    
	 end

	 check_value_str = i_args.substr(0, space_position - 1);                // Get Check Value string
	 check_type_str  = i_args.substr(space_position + 1, i_args.len() - 1);	// Get Type check
	 
	 // Get Check value - Case with "0x" value
	 if({check_value_str.getc(0), check_value_str.getc(1)} == "0x") begin
	    check_value_str = check_value_str.substr(2, check_value_str.len() - 1); // Remove "0x"
	    check_value = check_value_str.atohex();                                 // Set Correct HEX Value	    
	 end
	 else begin
	    check_value = check_value_str.atoi; // String to int	    
	 end

	 // Case : 0x at the beginning of the Args
	 // if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
	 //   s_str_len     = i_args[2].len(); // Find Length		  
         //   s_str         = i_args[2].substr(2, s_str_len - 1); // Remove 0x
         //   s_check_value = s_str.atohex(); // Set Correct Hex value
	 // end
	 // // DECIMAL ARGS
	 // else begin
         //   s_check_value = s_str.atoi;
		  
	 // end // else: !if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x")

	 // Alias was already check before in cutom sequencer
	 if(check_type_str == "OK") begin
	    if(this.check_level_vif.check_signals[this.check_level_alias_list[i_alias]] == check_value) begin
	       $display("CHECK %s = 0x%x - Expected : 0x%x => OK", i_alias, this.check_level_vif.check_signals[this.check_level_alias_list[i_alias]], check_value);
	    end
	    else begin
	       $display("Error: %s = 0x%x - Expected : 0x%x", i_alias, this.check_level_vif.check_signals[this.check_level_alias_list[i_alias]], check_value);
	    end
	 end
	 else if(check_type_str == "ERROR") begin
	    if(this.check_level_vif.check_signals[this.check_level_alias_list[i_alias]] != check_value) begin
               $display("CHECK %s != 0x%x  => OK", i_alias,  check_value);
		     
	     end
	     else begin
               $display("Error: %s = 0x%x", i_alias, check_value);
	     end
	 end
	 else begin
	    $display("Error: check_type_str of CHECK command not defined");
	 end
	 $display("");

	 
	 // // Test if ALIAS Name Exist else Error
      // 	 if(s_alias_array.exists(i_args[1])) begin
      // 	 // CHECK VALUE
      // 	 // OK Expected
      // 	   if(i_args[3] == "OK") begin

      //        if(this.check_level_vif.check_signals[s_alias_array[i_args[1]]] == s_check_value) begin
      //          $display("CHECK %s = 0x%x - Expected : 0x%x => OK", i_args[1], this.check_level_vif.check_signals[s_alias_array[i_args[1]]], s_check_value);
		     
      // 	     end
      // 	     else begin
      //          $display("Error: %s = 0x%x - Expected : 0x%x", i_args[1], this.check_level_vif.check_signals[s_alias_array[i_args[1]]], s_check_value);
      // 	     end		  
      // 	   end
      // 	   // ERROR Expected
      // 	   else if(i_args[3] == "ERROR") begin
		  
      //        if(this.check_level_vif.check_signals[s_alias_array[i_args[1]]] != s_check_value) begin
      //          $display("CHECK %s != 0x%x  => OK", i_args[1],  s_check_value);
		     
      // 	     end
      // 	     else begin
      //          $display("Error: %s = 0x%x", i_args[1], s_check_value);
      // 	     end
      // 	   end
      // 	   // Error no Expected state value
      // 	   else begin
      //        $display("Error: Args[3] of CHECK command not defined");
		  
      // 	   end // else: !if(i_args[3] == "ERROR")
	       
      // 	 end // if (s_alias_array.exists(i_args[1]))
      // 	 else begin
      //      $display("Error: %s alias doesn't exists", i_args[1]);
		  
      // 	 end // else: !if(s_alias_array.exists(i_args[1]))
	 	 
      // end

      // $display("");
      end
      
   endtask // check_level


   // Add Alias function to class and to Interface
   function void ADD_CHECK_LEVEL_ALIAS(string alias_str, int alias_index);
      this.check_level_alias_list[alias_str] = alias_index;  
   endfunction

   
endclass // tb_check_level_class
