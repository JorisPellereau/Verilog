//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

`include "testbench_setup.sv"

// TB TOP
module tb_top;
   

   // == INTERNAL SIGNALS ==
   
   wire clk;
   wire ack;
   wire rst_n;

   
   string s_args [5];   
   wire	  s_args_valid;
   
   wire 	s_ack;
   wire 	s_sel_set;

   // SET INJECTOR signals
   string 	                s_set_alias [`C_SET_ALIAS_NB];
   wire [`C_SET_WIDTH - 1:0] 	s_set [`C_SET_ALIAS_NB];

   // WAIT EVENT signals
   string 	                s_wait_alias [`C_WAIT_ALIAS_NB];
   wire [`C_SET_WIDTH - 1:0] 	s_wait [`C_WAIT_ALIAS_NB];

   // CHECK LEVEL signals
   
   // ========================
   
   
   
   // == CLK GEN INST ==
   clk_gen #(
	.G_CLK_HALF_PERIOD  (`C_TB_CLK_HALF_PERIOD),
	.G_WAIT_RST         (`C_WAIT_RST)
   )
   i_clk_gen (
	      .clk_tb (clk),
              .rst_n  (rst_n)	      
   );
   // ==================

   // == SET INJECTOR ALIAS ==
   assign s_set_alias[0] = "I0";
   assign s_set_alias[1] = "I1";
   assign s_set_alias[2] = "I2";
   assign s_set_alias[3] = "I3";
   assign s_set_alias[4] = "I4";
   // ========================

   // == WAIT EVENT ALIAS ==
   assign s_wait_alias[0] = "O0";
   assign s_wait_alias[1] = "O1";
   assign s_wait_alias[2] = "O2";
   assign s_wait_alias[3] = "O3";
   assign s_wait_alias[4] = "O4";
   // ========================

   // == CHECK LEVEL ALIAS ==
/* -----\/----- EXCLUDED -----\/-----
   assign s_check_lvl_alias[0] = "O0";
   assign s_check_lvl_alias[1] = "O1";
   assign s_check_lvl_alias[2] = "O2";
   assign s_check_lvl_alias[3] = "O3";
   assign s_check_lvl_alias[4] = "O4";
 -----/\----- EXCLUDED -----/\----- */
   // ========================
   
   // Testbench Sequencer INST
   tb_seq_wrapper #(
    .ARGS_NB       (`C_CMD_ARGS_NB),
    .SET_ALIAS_NB  (`C_SET_ALIAS_NB),
    .SET_SIZE      (`C_SET_SIZE),
    .SET_WIDTH     (`C_SET_WIDTH)
   )
   i_tb_seq_wrapper_0 (
		       
     .clk   (clk),
     .rst_n (rst_n),

     // SET ALIAS
     .i_set_alias  (s_set_alias),
     .o_set        (s_set),

     // WAIT ALIAS
     .i_wait_alias  (s_wait_alias),
     .i_wait        (s_wait)

     // CHECK LEVEL
  );
   
 
endmodule // tb_top
