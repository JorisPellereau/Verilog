//                              -*- Mode: Verilog -*-
// Filename        : tb_utils.sv
// Description     : Useful Function and tasks for Testbench
// Author          : JorisP
// Created On      : Sun Apr 18 16:38:09 2021
// Last Modified By: JorisP
// Last Modified On: Sun Apr 18 16:38:09 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!


class tb_utils_class;

   int data_size;
   
   

   function new ();
      //this.data_size = 8;            
   endfunction // new
   
   
   

  // Convert an input string into an integer
  function int str_2_int (input string str, output int result);
     
     int s_str_len;
     
     string s_str;
     int    s_value;
     
     
     result = 0;
     
     if( {str.getc(0),  str.getc(1)} == "0x") begin
		  
	s_str_len     = str.len(); // Find Length		  
        s_str         = str.substr(2, s_str_len - 1); // Remove 0x
        s_value       = s_str.atohex(); // Set Correct Hex value
     end
     // DECIMAL ARGS
     else begin
        s_value = str.atoi;
	
     end // else: !if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x")

     result = s_value;
     
     return result;
     

  endfunction // str_2_int
   
   

     
endclass // tb_utils_class

