//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : V1.0

`timescale 1ps/1ps

`include "testbench_setup.sv"
`include "wait_event_wrapper.sv"
`include "set_injector_wrapper.sv"
`include "wait_duration_wrapper.sv"
`include "check_level_wrapper.sv"
`include "tb_tasks.sv"

//`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"



// TB TOP
module tb_top
  #(
    parameter SCN_FILE_PATH = "scenario.txt"
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




   // == TESTBENCH GENERIC INTERFACE SIGNALS DECLARATIONS ==
    wait_event_intf #( .WAIT_SIZE   (`C_WAIT_ALIAS_NB),
                       .WAIT_WIDTH  (`C_WAIT_WIDTH)
    ) 
    s_wait_event_if();

    set_injector_intf #( .SET_SIZE   (`C_SET_ALIAS_NB),
			 .SET_WIDTH  (`C_SET_WIDTH)
    )
    s_set_injector_if();
 
    wait_duration_intf s_wait_duration_if();
   
    assign s_wait_duration_if.clk = clk;
   

    check_level_intf #( .CHECK_SIZE  (),
		        .CHECK_WIDTH  ()
    )
    s_check_level_if();
   

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

   // INIT CHECK LEVEL ALIAS
   assign s_check_level_if.check_alias[0] = "TOTO0";
   assign s_check_level_if.check_alias[1] = "TOTO1";
   assign s_check_level_if.check_alias[2] = "TOTO2";
   assign s_check_level_if.check_alias[3] = "TOTO3";
   assign s_check_level_if.check_alias[4] = "TOTO4";

   // SET CHECK_SIGNALS
   assign s_check_level_if.check_signals[0] =  32'hCAFEDECA;
   assign s_check_level_if.check_signals[1] =  32'hCAFEDEC0;
   assign s_check_level_if.check_signals[2] =  32'hCAFEDEC1;
   assign s_check_level_if.check_signals[3] =  32'hCAFEDEC2;
   assign s_check_level_if.check_signals[4] =  32'hCAFEDEC3;
  
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


   wire [`C_NB_UART_CHECKER - 1 : 0] s_rx_uart;
   wire [`C_NB_UART_CHECKER - 1 : 0] s_tx_uart;

   // Create UART checker Interface

   uart_checker_intf #(
		       .G_NB_UART_CHECKER    (`C_NB_UART_CHECKER),
		       .G_DATA_WIDTH         (`C_UART_DATA_WIDTH),
		       .G_BUFFER_ADDR_WIDTH  (`C_UART_BUFFER_ADDR_WIDTH)
		       ) 
   uart_checker_if();


   // Assign Alias of UART checker
   assign uart_checker_if.uart_checker_alias = '{
						 "UART_0" : 0,
						 "UART_1" : 1
						 };
   assign uart_checker_if.clk = clk;
   
 
   // == HDL SPEFICIC TESTBENCH MODULES ==

   
   uart_checker_wrapper #(

			      .G_NB_UART_CHECKER    (`C_NB_UART_CHECKER),
			      .G_STOP_BIT_NUMBER    (1),
			      .G_POLARITY           (4'd3),
			      .G_PARITY             (0),
			      .G_BAUDRATE           (9),
			      .G_DATA_WIDTH         (`C_UART_DATA_WIDTH),
			      .G_FIRST_BIT          (0),
			      .G_CLOCK_FREQ         (20000000),
			      .G_BUFFER_ADDR_WIDTH  (`C_UART_BUFFER_ADDR_WIDTH)
   )
   i_uart_checker_wrapper (
			   .clk    (clk),
			   .rst_n  (rst_n),			  

			   .i_rx  (s_rx_uart),
			   .o_tx  (s_tx_uart),

			   .uart_checker_if (uart_checker_if)
    
    );


   
   // ====================================
   //assign uart_checker_if.clk = clk;
   assign s_rx_uart = s_tx_uart; // LOOP


   bit 				     C_UART_MODULE_EN; 
   assign C_UART_MODULE_EN = 1;
   
   /*uart_tb_info_struct uart_tb_info;
   
   assign uart_tb_info = '{1, "tb_top/uart_checker_if"};*/
   
   
   
   
   // Declare TB Module class type   
   tb_modules_custom_uart tb_modules_custom_class_inst = new(uart_checker_if, 1, 8, 8); // a faire en static


   // == TESTBENCH SEQUENCER ==
   
   // CREATE CLASS - Configure Parameters
   static tb_class #( `C_CMD_ARGS_NB, 
                      `C_SET_SIZE, 
                      `C_SET_WIDTH,
                      `C_WAIT_ALIAS_NB,
                      `C_WAIT_WIDTH, 
                      `C_TB_CLK_PERIOD,
                      `C_CHECK_SIZE,
                      `C_CHECK_WIDTH) 
   tb_class_inst = new (s_wait_event_if, 
                        s_set_injector_if, 
                        s_wait_duration_if,
                        s_check_level_if,
  			tb_modules_custom_class_inst);
   
    
   initial begin : TB_SEQUENCER
       
      tb_class_inst.tb_sequencer(SCN_FILE_PATH);
      
   end : TB_SEQUENCER
   
   // ========================
   



   // == DUT INST ==
   
   // ==============

   
endmodule // tb_top
