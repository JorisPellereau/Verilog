//                              -*- Mode: Verilog -*-
// Filename        : set_injector.sv
// Description     : SET Injector
// Author          : JorisP
// Created On      : Wed Oct 14 23:11:59 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 14 23:11:59 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

module set_injector

  #(
    parameter ARGS_NB   = 5,
    parameter SET_SIZE  = 5,
    parameter SET_WIDTH = 32
    )
   (
    input 		       clk,
    input 		       rst_n,
    
    input string 	       i_set_alias [SET_SIZE],
    input 		       i_set_sel,
    
    input 		       i_args_valid, 
    input string 	       i_args [ARGS_NB],

    output reg [SET_WIDTH - 1 : 0] o_set [SET_SIZE]

    );


   // INTERNAL SIGNALS
   // ASSOCIATIVE ARRAY
   int 	 s_alias_array [string];

   string s_str;
   int 	  s_str_len;
   
   // DECOD
   always @(posedge clk) begin
      if (!rst_n) begin

	 for(int j = 0 ; j < SET_WIDTH ; j++) begin
	    for(int k = 0 ; k < SET_SIZE ; k++) begin
	       o_set [k][j] <= 0;
	    end
	 end

	 for (int i = 0; i < SET_SIZE; i++) begin
	   s_alias_array[i_set_alias[i]] = i;
         end
	 
      end
      else begin
	 if(i_set_sel) begin
	    if(i_args_valid) begin

	       // Case : 0x at the beginning of the Args
	       if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
		  s_str_len = i_args[2].len(); // Find Length		  
		  s_str     = i_args[2].substr(2, s_str_len - 1); // Remove 0x
		  		  
	          o_set[s_alias_array[i_args[1]]] <= s_str.atohex(); // Set Correct Hex value
	       end
	       // Decimal args
	       else begin
                 o_set[s_alias_array[i_args[1]]] <= i_args[2].atoi();		  
	       end
	       
	       	       	       
	    end	    
	 end	 	 
      end
   end // always @ (posedge clk)   
   
endmodule // set_injector

    
