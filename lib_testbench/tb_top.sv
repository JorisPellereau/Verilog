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
`include "tb_tasks.sv"


// TB TOP
module tb_top;
   

   // == INTERNAL SIGNALS ==
   
   wire clk;
   wire ack;
   wire rst_n;

   
   string s_args [`C_CMD_ARGS_NB];   
   wire	  s_args_valid;
   
   wire 	s_ack;
   wire 	s_sel_set;

   // SET INJECTOR signals
   string 	                s_set_alias [`C_SET_ALIAS_NB];
   wire [`C_SET_WIDTH - 1:0] 	s_set [`C_SET_ALIAS_NB];

   // WAIT EVENT signals
   string 	                s_wait_alias [`C_WAIT_ALIAS_NB];
   wire [`C_WAIT_WIDTH - 1:0] 	s_wait [`C_WAIT_ALIAS_NB];

   // CHECK LEVEL signals
   string 	                s_check_alias [`C_CHECK_ALIAS_NB];
   wire [`C_CHECK_WIDTH - 1:0] 	s_check [`C_CHECK_ALIAS_NB];
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
   assign s_check_alias[0] = "TOTO0";
   assign s_check_alias[1] = "TOTO1";
   assign s_check_alias[2] = "TOTO2";
   assign s_check_alias[3] = "TOTO3";
   assign s_check_alias[4] = "TOTO4";
   // ========================

   // == WAIT EVENT INPUTS ==
   assign s_wait[0] = 1'b0;
   assign s_wait[1] = 1'b0;
   assign s_wait[2] = 1'b0;
   assign s_wait[3] = 1'b0;
   assign s_wait[4] = 1'b0;
   // =======================

   // == CHECK LEVEL INPUTS ==
   assign s_check[0] = 32'hCAFEDECA;
   assign s_check[1] = 16'h5678;
   assign s_check[2] = 8'h72;
   assign s_check[3] = 16'hzzzz;
   assign s_check[4] = 1'bz;   
   // ========================

   
   
   // Testbench Sequencer INST
/* -----\/----- EXCLUDED -----\/-----
   tb_seq_wrapper #(
    .SCN_FILE_PATH  ("scn.txt"),		    
    .ARGS_NB        (`C_CMD_ARGS_NB),
    .SET_ALIAS_NB   (`C_SET_ALIAS_NB),
    .SET_SIZE       (`C_SET_SIZE),
    .SET_WIDTH      (`C_SET_WIDTH),
    .CLK_PERIOD     (`C_TB_CLK_PERIOD),
    .CHECK_SIZE     (`C_CHECK_SIZE),
    .CHECK_WIDTH    (`C_CHECK_WIDTH)
   )
   i_tb_seq_wrapper_0 (
		       
     .clk   (clk),
     .rst_n (rst_n),

     // SET ALIAS
     .i_set_alias  (s_set_alias),
     .o_set        (s_set),

     // WAIT ALIAS
     .i_wait_alias  (s_wait_alias),
     .i_wait        (s_wait),

     // CHECK LEVEL
     .i_check_alias  (s_check_alias),
     .i_check        (s_check)
  );
 -----/\----- EXCLUDED -----/\----- */

   wire 			i_wait_done;
   wire				i_wait_duration_done;
   
   int 			o_sel_wait;
   int 			o_sel_check;
   int 			o_sel_wait_duration;
   int 			o_sel_set;
   string 			line;
   string 			args [5];
   
   

   // CREATE CLASS
   tb_class tb_class_inst;
   
   assign i_wait_duration_done = 1'b0;
   
   // TASK Testbench Sequencer
   initial begin

      tb_class_inst = new();

      //tb_class_inst.cmd_decoder(line, i_wait_done, i_wait_duration_done, o_sel_set, o_sel_wait, o_sel_check, o_sel_wait_duration, args);
      #1;
      
      tb_class_inst.tb_sequencer("/home/jorisp/GitHub/Verilog/test_tasks.txt", i_wait_done, i_wait_duration_done, o_sel_wait, o_sel_set, o_sel_check, o_sel_wait_duration);
      
      
   end
   
 
endmodule // tb_top
