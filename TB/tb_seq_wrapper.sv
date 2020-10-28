//                              -*- Mode: Verilog -*-
// Filename        : tb_seq_wrapper.sv
// Description     : Testbench Sequencer Wrapper
// Author          : JorisP
// Created On      : Wed Oct 21 19:57:23 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 21 19:57:23 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

`include "testbench_setup.sv"



module tb_seq_wrapper
  #(
    parameter ARGS_NB = 5,
    
    parameter SET_ALIAS_NB = 5,
    parameter SET_SIZE     = 5,
    parameter SET_WIDTH    = 32,

    parameter WAIT_SIZE    = 5,
    parameter WAIT_WIDTH   = 1,
    parameter CLK_PERIOD   = 2000,

    parameter CHECK_SIZE   = 5,
    parameter CHECK_WIDTH  = 32
    
  )
  (
   input 		      clk,
   input 		      rst_n,

   // SET I/F
   input string 	      i_set_alias [SET_ALIAS_NB],
   output [SET_WIDTH - 1 : 0] o_set [SET_SIZE],

   // WAIT EVENT I/F
   input string 	      i_wait_alias [WAIT_SIZE],
   input [WAIT_WIDTH - 1 : 0] i_wait [WAIT_SIZE],

   // CHECK LEVEL I/F
   input string 	      i_check_alias [CHECK_SIZE],
   input [CHECK_WIDTH - 1 : 0] i_check [CHECK_SIZE]
   
  );
   

   // INTERNAL SIGNALS
   wire  s_ack;
   wire  s_args_valid;
   
   string s_args [ARGS_NB];
   
   
  
  // SEQUENCER INST
  sequencer #(
     .ARGS_NB(ARGS_NB)
  )
  i_sequencer_0 (
		 .clk     (clk),
		 .rst_n   (rst_n),

		 .ack         (s_ack),
		 .args        (s_args),
		 .args_valid  (s_args_valid)		 
  );
   

   // DECODER INST
   decoder #(
	     .ARGS_NB (ARGS_NB)
   )	     
   i_decoder (
       .clk         (clk),
       .rst_n       (rst_n),
	      
       .i_args        (s_args),
       .i_args_valid  (s_args_valid),
	      
       .o_sel_set     (s_sel_set),

       .i_wait_done   (s_wait_done),	      
       .o_sel_wait    (s_sel_wait),
	      
       .o_sel_check   (s_sel_check),
	      
       .o_ack         (s_ack)
		      
   );



   // SET INJECTOR INST
   set_injector #(
     .ARGS_NB   (ARGS_NB),
     .SET_SIZE  (SET_SIZE),
     .SET_WIDTH (SET_WIDTH)
    )
   i_set_injector
   (
       .clk         (clk),
       .rst_n       (rst_n),
   
       .i_set_alias  (i_set_alias),
       .i_set_sel    (s_sel_set),
    
       .i_args_valid  (s_args_valid),
       .i_args        (s_args),

       .o_set (o_set)

    );



   // WAIT EVENT INST
   wait_event #(
		.ARGS_NB    (ARGS_NB),		
		.WAIT_SIZE  (WAIT_SIZE),
		.WAIT_WIDTH (WAIT_WIDTH),
		.CLK_PERIOD (CLK_PERIOD)
   )
   i_wait_event (
       .clk         (clk),
       .rst_n       (rst_n),

       .i_wait_alias  (i_wait_alias),
       .i_sel_wait    (s_sel_wait),	 
       .i_args_valid  (s_args_valid),
       .i_args        (s_args),		 
       .i_wait        (i_wait),
       .o_wait_done   (s_wait_done)
   );
   

   // CHECK LEVEL INST
   check_level #(
		 .ARGS_NB     (ARGS_NB),
		 .CHECK_SIZE  (CHECK_SIZE),
		 .CHECK_WIDTH (CHECK_WIDTH)
   )
   i_check_level (
        .clk         (clk),
        .rst_n       (rst_n),

	.i_check_alias  (i_check_alias),
	.i_sel_check    (s_sel_check),
        .i_args_valid   (s_args_valid),
        .i_args         (s_args),
        .i_check        (i_check)		 
		  
   );
   
     
   
endmodule // tb_seq_wrapper
