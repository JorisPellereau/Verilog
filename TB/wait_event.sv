//                              -*- Mode: Verilog -*-
// Filename        : wait_event.sv
// Description     : Wait Event Testbench Module
// Author          : JorisP
// Created On      : Wed Oct 21 19:46:10 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 21 19:46:10 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module wait_event
  #(  
    parameter ARGS_NB    = 5, 
    parameter WAIT_SIZE  = 5,
    parameter WAIT_WIDTH = 1
  )
  (
   input 		      clk,
   input 		      rst_n,

   input string 	      i_wait_alias [WAIT_SIZE],
   input 		      i_sel_wait, 
   input 		      i_args_valid, 
   input string 	      i_args [ARGS_NB],

   input [WAIT_WIDTH - 1 : 0] i_wait [WAIT_SIZE],

   output 		      o_wait_done
   
   );


   // INTERNAL signals
   reg [WAIT_WIDTH - 1 : 0]   s_wait [WAIT_SIZE];

   // 

   // LATCH INPUTS
   always(@posedge) begin
      if(!rst_n) begin
	 s_wait <= 0;	 
      end
      else begin
	 s_wait <= i_wait;	 
      end      
   end
   
   
endmodule // wait_event
