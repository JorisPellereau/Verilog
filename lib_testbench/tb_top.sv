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
`include "wait_event_wrapper.sv"
`include "set_injector_wrapper.sv"
`include "wait_duration_wrapper.sv"
`include "tb_tasks.sv"


// TB TOP
module tb_top
  #(
    parameter SCN_FILE_PATH = "scn.txt"
   )
   ();
   

   
   // == INTERNAL SIGNALS ==
   
   wire clk;
   wire rst_n;

   // SET INJECTOR signals
   wire [31:0] i0;
   wire [31:0] i1;
   wire [31:0] i2;
   wire [31:0] i3;
   wire [31:0] i4;

   
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


   // == CHECK LEVEL ALIAS ==
   /*assign s_check_alias[0] = "TOTO0";
   assign s_check_alias[1] = "TOTO1";
   assign s_check_alias[2] = "TOTO2";
   assign s_check_alias[3] = "TOTO3";
   assign s_check_alias[4] = "TOTO4";*/
   // ========================



   // == CHECK LEVEL INPUTS ==
   /*assign s_check[0] = 32'hCAFEDECA;
   assign s_check[1] = 16'h5678;
   assign s_check[2] = 8'h72;
   assign s_check[3] = 16'hzzzz;
   assign s_check[4] = 1'bz; */  
   // ========================

   
 

   bit   			s_wait_done;
   wire				i_wait_duration_done;
   
   logic 			o_sel_check;
   logic 			o_sel_wait_duration;
   logic 			o_sel_set;
   
   

   // == TESTBENCH GENERIC INTERFACE SIGNALS DECLARATIONS ==
    wait_event_intf #( .WAIT_SIZE   (`C_WAIT_ALIAS_NB),
                       .WAIT_WIDTH  (`C_WAIT_WIDTH)
    ) 
    s_wait_event_if();

    set_injector_intf #( .SET_SIZE   (`C_SET_ALIAS_NB),
			 .SET_WIDTH  (`C_SET_WIDTH)
    )
    s_set_injector_if();
 
    wait_duration_intf #( .WAIT_CLK_PERIOD (`C_TB_CLK_PERIOD)
    )
    s_wait_duration_if();
   
    assign s_wait_duration_if.clk = clk;
   
   

   // =====================================================

   // == TESTBENCH MODULES ALIASES & SIGNALS AFFECTATION ==

   // INIT WAIT EVENT ALIAS
   assign s_wait_event_if.wait_alias[0] = "RST_N";
   assign s_wait_event_if.wait_alias[1] = "O1";
   assign s_wait_event_if.wait_alias[2] = "O2";
   assign s_wait_event_if.wait_alias[3] = "O3";
   assign s_wait_event_if.wait_alias[4] = "O4";

   // SET WAIT EVENT SIGNALS
   assign s_wait_event_if.wait_signals[0] = rst_n;
   assign s_wait_event_if.wait_signals[1] = 1'b0;
   assign s_wait_event_if.wait_signals[2] = 1'b0;
   assign s_wait_event_if.wait_signals[3] = 1'b0;
   assign s_wait_event_if.wait_signals[4] = 1'b0;

   // INIT SET ALIAS
   assign s_set_injector_if.set_alias[0] = "I0";
   assign s_set_injector_if.set_alias[1] = "I1";
   assign s_set_injector_if.set_alias[2] = "I2";
   assign s_set_injector_if.set_alias[3] = "I3";
   assign s_set_injector_if.set_alias[4] = "I4";
   
   // SET SET_INJECTOR SIGNALS
   assign i0 = s_set_injector_if.set_signals_synch[0];
   assign i1 = s_set_injector_if.set_signals_synch[1];
   assign i2 = s_set_injector_if.set_signals_synch[2];
   assign i3 = s_set_injector_if.set_signals_synch[3];
   assign i4 = s_set_injector_if.set_signals_synch[4];

   // SET SET_INJECTOR INITIAL VALUES
   assign s_set_injector_if.set_signals_asynch_init_value[0] = 32'hAAAAAAAA;
   assign s_set_injector_if.set_signals_asynch_init_value[1] = 32'h22222222;
   assign s_set_injector_if.set_signals_asynch_init_value[2] = 32'h55555555;
   assign s_set_injector_if.set_signals_asynch_init_value[3] = 32'hZZZZZZZZ;
   assign s_set_injector_if.set_signals_asynch_init_value[4] = 32'hFFFFFFFF;
   
   // =====================================================


   
   // == HDL GENERIC TESTBENCH MODULES ==

   // WAIT EVENT TB WRAPPER INST
   wait_event_wrapper #(
			.ARGS_NB    (`C_CMD_ARGS_NB),
			.CLK_PERIOD (`C_TB_CLK_PERIOD)
   )
   i_wait_event_wrapper (
       .clk            (clk),
       .rst_n          (rst_n),
       .wait_event_if  (s_wait_event_if)			 
   );


   // SET INJECTOR TB WRAPPER INST
   set_injector_wrapper #(
			  .ARGS_NB(`C_CMD_ARGS_NB) 
   )
   i_set_injector_wrapper (
       .clk              (clk),
       .rst_n            (rst_n),
       .set_injector_if  (s_set_injector_if)			   
   );
   
   
   // ===========================


   // == TESTBENCH SEQUENCER ==
   
   // CREATE CLASS - Configure Parameters
   static tb_class #( `C_CMD_ARGS_NB, 
                      `C_SET_SIZE, 
                      `C_SET_WIDTH,
                      `C_WAIT_ALIAS_NB,
                      `C_WAIT_WIDTH, 
                      `C_TB_CLK_PERIOD) 
   tb_class_inst = new (s_wait_event_if, s_set_injector_if, s_wait_duration_if);
   
   
   initial begin
      tb_class_inst.tb_sequencer("/home/jorisp/GitHub/Verilog/test_tasks.txt");


   end // initial begin
   
   // ========================

   
endmodule // tb_top
