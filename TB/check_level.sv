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
   input 		      clk,
   input 		      rst_n,

   input string 	      i_check_alias [CHECK_SIZE],
   input 		      i_sel_check, 
   input 		      i_args_valid, 
   input string 	      i_args [ARGS_NB],

   input [CHECK_WIDTH - 1 : 0] i_check [CHECK_SIZE]

   
   );
  
endmodule // check_level
