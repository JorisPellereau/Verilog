//                              -*- Mode: Verilog -*-
// Filename        : check_level.sv
// Description     : Check Level Testbench Module
// Author          : JorisP
// Created On      : Wed Oct 28 22:37:22 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 28 22:37:22 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ps/1ps

`include "testbench_setup.sv"

module check_level
   #(  
    parameter ARGS_NB     = 5, 
    parameter CHECK_SIZE  = 5,
    parameter CHECK_WIDTH = 32
  )
  (
   input 		       clk,
   input 		       rst_n,

   input string 	       i_check_alias [CHECK_SIZE],
   input 		       i_sel_check, 
   input 		       i_args_valid, 
   input string 	       i_args [ARGS_NB],

   input [CHECK_WIDTH - 1 : 0] i_check [CHECK_SIZE]

   
   );


   // ASSOCIATIVE ARRAY
   int 	 s_alias_array [string];
   
   // INTERNAL SIGNALS
   /*int*/ reg [CHECK_WIDTH - 1 : 0] 			       s_check_value;
   string 		       s_str;     
   int 			       s_str_len;
   
   

   // CHECK MANAGEMENT
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_check_value <= 0;

	 // INIT ALIAS
	 for (int i = 0; i < CHECK_SIZE; i++) begin
	   s_alias_array[i_check_alias[i]] = i;
         end

	 
      end
      else begin
	 if(i_sel_check) begin
	    if(i_args_valid) begin
	       
	       // Case : 0x at the beginning of the Args
	       if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
		  s_str_len = i_args[2].len(); // Find Length		  
		  s_str     = i_args[2].substr(2, s_str_len - 1); // Remove 0x
		  s_check_value = s_str.atohex(); // Set Correct Hex value
	       end
	       // DECIMAL ARGS
	       else begin
		  s_check_value = s_str.atoi;
		  
	       end // else: !if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x")


	       // Test if ALIAS Name Exist else Error
	       if(s_alias_array.exists(i_args[1])) begin
	         // CHECK VALUE
	         // OK Expected
	         if(i_args[3] == "OK") begin

		    
		      if(i_check[s_alias_array[i_args[1]]] == s_check_value) begin
		         $display("CHECK %s = 0x%x - Expected : 0x%x => OK", i_args[1], i_check[s_alias_array[i_args[1]]], s_check_value);
		     
	              end
	              else begin
		         $display("Error: %s = 0x%x - Expected : 0x%x", i_args[1], i_check[s_alias_array[i_args[1]]], s_check_value);
	              end
		  //end
		  
	         end
	         // ERROR Expected
	         else if(i_args[3] == "ERROR") begin
		  
                    if(i_check[s_alias_array[i_args[1]]] != s_check_value) begin
		       $display("CHECK %s != 0x%x  => OK", i_args[1],  s_check_value);
		     
	            end
	            else begin
		       $display("Error: %s = 0x%x", i_args[1], s_check_value);
	            end
	         end
	         // Error no Expected state value
	         else begin
		    $display("Error: Args[3] of CHECK command not defined");
		  
	         end // else: !if(i_args[3] == "ERROR")
	       
	       end // if (s_alias_array.exists(i_args[1]))
	       else begin
		  $display("Error: %s alias doesn't exists", i_args[1]);
		  
	       end // else: !if(s_alias_array.exists(i_args[1]))
	       
	       
	    end // if (i_args_valid)
	    
	 end // if (i_sel_check)
	 
      end // else: !if(!rst_n)
   end // always @ (posedge clk)
   
	 

  
endmodule // check_level
