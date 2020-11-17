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

interface wait_event_intf #(
     parameter WAIT_SIZE  = 5,
     parameter WAIT_WIDTH = 1
   );
   
   logic wait_en;   
   logic sel_wtr_wtf;
   logic [31:0] max_timeout;
   logic [WAIT_WIDTH - 1 : 0] wait_signals [WAIT_SIZE];   
   logic 	wait_done;
   
   endinterface // wait_event_int

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

   
   logic [`C_SET_WIDTH - 1:0] 	s_set_task [`C_SET_ALIAS_NB];
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
   assign s_wait_alias[0] = "RST_N";
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
   assign s_wait[0] = rst_n;
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

   
 

   bit   			s_wait_done;
   wire				i_wait_duration_done;
   
   logic 			s_sel_wait;
   logic 			o_sel_check;
   logic 			o_sel_wait_duration;
   logic 			o_sel_set;
   
   string 			line;
   string 			args [`C_CMD_ARGS_NB];
   
   bit  			s_sel_wtr_wtf;
   logic [31:0] 		s_max_timeout;
   int 				s_wait_en;
   


   assign i_wait_duration_done = 1'b0;

    wait_event_intf #(.WAIT_SIZE(5), .WAIT_WIDTH(1)) s_wait_event_if();  // WAIT EVENT I/F


   // CREATE CLASS - Configure Parameters
   static tb_class #(`C_CMD_ARGS_NB, `C_SET_SIZE, `C_SET_WIDTH, 5, 1, `C_TB_CLK_PERIOD) tb_class_inst = new (s_wait_event_if);
   
   initial begin
      tb_class_inst  = new(s_wait_event_if);
      tb_class_inst.tb_sequencer("/home/jorisp/GitHub/Verilog/test_tasks.txt", 
                                   i_wait_duration_done, 
                                   s_set_alias, s_set_task, s_wait_alias, 
                                   s_wait_done, s_sel_wtr_wtf, s_wait_en, 
                                   s_max_timeout);


   end // initial begin
   


   

   // WAIT EVENT TB WRAPPER INST
   wait_event_wrapper #(
			.ARGS_NB    (`C_CMD_ARGS_NB),
			.CLK_PERIOD (`C_TB_CLK_PERIOD)
   )
   i_wait_event_wrapper (
       .clk         (clk),
       .rst_n       (rst_n),

	.wait_event_if (s_wait_event_if)			 
   );
   
   assign    s_wait_event_if.wait_en      = s_wait_en;
   assign    s_wait_event_if.sel_wtr_wtf  = s_sel_wtr_wtf;
   assign    s_wait_event_if.max_timeout  = s_max_timeout;
   assign    s_wait_event_if.wait_signals = s_wait;

endmodule // tb_top
