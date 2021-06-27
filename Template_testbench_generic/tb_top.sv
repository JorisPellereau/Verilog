//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : V1.0

/*
 *  Testbench TOP for test of XXX block
 * 
 */ 

`timescale 1ps/1ps


`include "/home/jorisp/GitHub/VHDL_code/UART/tb_sources/tb_lib_uart_display_ctrl/testbench_setup.sv" // Mettre le bon chemin
`include "/home/jorisp/GitHub/Verilog/lib_testbench/wait_event_wrapper.sv"
`include "/home/jorisp/GitHub/Verilog/lib_testbench/set_injector_wrapper.sv"
`include "/home/jorisp/GitHub/Verilog/lib_testbench/wait_duration_wrapper.sv"
`include "/home/jorisp/GitHub/Verilog/lib_testbench/check_level_wrapper.sv"
`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/uart_checker_wrapper.sv"
`include "/home/jorisp/GitHub/Verilog/lib_testbench/tb_tasks.sv"


// TB TOP
module tb_top
  #(
    parameter SCN_FILE_PATH = "scenario.txt"
   )
   ();
   

   
   // == INTERNAL SIGNALS ==
   
   wire clk;
   wire rst_n;

   wire        s_static_dyn;
   wire        s_new_display;
    
   
   
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
   

    check_level_intf #( .CHECK_SIZE   (`C_CHECK_ALIAS_NB),
		        .CHECK_WIDTH  (`C_CHECK_WIDTH)
    )
    s_check_level_if();
   


    // == HDL GENERIC TESTBENCH MODULES ==

    // WAIT EVENT TB WRAPPER INST
    wait_event_wrapper #(.CLK_PERIOD (`C_TB_CLK_PERIOD)
    )
    i_wait_event_wrapper (
       .clk            (clk),
       .rst_n          (rst_n),
       .wait_event_if  (s_wait_event_if)			 
    );


    // SET INJECTOR TB WRAPPER INST
    set_injector_wrapper #()
    i_set_injector_wrapper (
       .clk              (clk),
       .rst_n            (rst_n),
       .set_injector_if  (s_set_injector_if)			   
    );

   
   // =====================================================


   // Create UART checker Interface
   uart_checker_intf #(
		       .G_NB_UART_CHECKER    (`C_NB_UART_CHECKER),
		       .G_DATA_WIDTH         (`C_UART_DATA_WIDTH),
		       .G_BUFFER_ADDR_WIDTH  (`C_UART_BUFFER_ADDR_WIDTH)
		       ) 
   uart_checker_if();
   

   // == TESTBENCH MODULES ALIASES & SIGNALS AFFECTATION ==

   // INIT WAIT EVENT ALIAS
   assign s_wait_event_if.wait_alias[0] = "RST_N";
   assign s_wait_event_if.wait_alias[1] = "CLK";
   assign s_wait_event_if.wait_alias[2] = "TOTO1";
   assign s_wait_event_if.wait_alias[3] = "TOTO2";

   
   

   // SET WAIT EVENT SIGNALS
   assign s_wait_event_if.wait_signals[0] = rst_n;
   assign s_wait_event_if.wait_signals[1] = clk;
   assign s_wait_event_if.wait_signals[2] = s_toto1;
   assign s_wait_event_if.wait_signals[3] = s_toto2;

   

   // INIT SET ALIAS
   assign s_set_injector_if.set_alias[0]   = "I_STATIC_DYN";
   assign s_set_injector_if.set_alias[1]   = "I_NEW_DISPLAY";
   assign s_set_injector_if.set_alias[2]   = "I_NEW_CONFIG_VAL";
   assign s_set_injector_if.set_alias[3]   = "I_EN_STATIC";
   
   

   
   // SET SET_INJECTOR SIGNALS
   assign s_static_dyn                    = s_set_injector_if.set_signals_synch[0];
   assign s_new_display                   = s_set_injector_if.set_signals_synch[1];
   assign s_new_config_val                = s_set_injector_if.set_signals_synch[2];
  
 
   // SET SET_INJECTOR INITIAL VALUES
   assign s_set_injector_if.set_signals_asynch_init_value[0]  = 0;
   assign s_set_injector_if.set_signals_asynch_init_value[1]  = 0;
   assign s_set_injector_if.set_signals_asynch_init_value[2]  = 0;
 
   // INIT CHECK LEVEL ALIAS

   assign s_check_level_if.check_alias[0] = "O_CONFIG_DONE";
   assign s_check_level_if.check_alias[1] = "O_RDATA_STATIC";   
  

   // SET CHECK_SIGNALS
   assign s_check_level_if.check_signals[0] =  s_config_done;
   assign s_check_level_if.check_signals[1] =  s_rdata_static;

   
   // =====================================================


   // == HDL SPEFICIC TESTBENCH MODULES ==

 
   // =============================
   

   // == TESTBENCH Configuration ==

   // Declare  TB Modules Class 
   tb_modules_custom #(
			    .G_NB_UART_CHECKER     (`C_NB_UART_CHECKER),
			    .G_DATA_WIDTH          (`C_UART_DATA_WIDTH),
			    .G_BUFFER_ADDR_WIDTH   (`C_UART_BUFFER_ADDR_WIDTH)
			    ) tb_modules_custom_class_inst = new(uart_checker_if);

   
   // CREATE CLASS - Configure Parameters
   static tb_class #( `C_SET_SIZE, 
                      `C_SET_WIDTH,
                      `C_WAIT_ALIAS_NB,
                      `C_WAIT_WIDTH, 
                      `C_TB_CLK_PERIOD,
                      `C_CHECK_SIZE,
                      `C_CHECK_WIDTH
		      )
   
   tb_class_inst= new (s_wait_event_if, 
                       s_set_injector_if, 
                       s_wait_duration_if,
                       s_check_level_if,
		       tb_modules_custom_class_inst);
   
   initial begin// : TB_SEQUENCER


      // RUN Testbench Sequencer
      tb_class_inst.tb_sequencer(SCN_FILE_PATH);
      
   end// : TB_SEQUENCER
   
   // ========================




   

   // == DUT INST ==


   uart_max7219_display_ctrl_wrapper #(
				      
				       .G_STOP_BIT_NUMBER (`C_STOP_BIT_NUMBER),
				       .G_PARITY          (`C_PARITY),
				       .G_BAUDRATE        (`C_BAUDRATE),
				       .G_UART_DATA_SIZE  (`C_UART_DATA_WIDTH),
				       .G_POLARITY        (`C_POLARITY),
				       .G_FIRST_BIT       (`C_FIRST_BIT ),
				       .G_CLOCK_FREQUENCY (`C_CLOCK_FREQ),
				       
				       .G_MATRIX_NB                (8),
				       .G_RAM_ADDR_WIDTH_STATIC    (8), 
				       .G_RAM_DATA_WIDTH_STATIC    (16),
				       .G_RAM_ADDR_WIDTH_SCROLLER  (8),
				       .G_RAM_DATA_WIDTH_SCROLLER  (8),

				       .G_MAX_HALF_PERIOD  (4),
				       .G_LOAD_DURATION    (4),

				       .G_DECOD_MAX_CNT_32B  (32'h02FAF080)
				       )
   
   i_dut (
	  .clk    (clk),
	  .rst_n  (rst_n),
	  	  
	  .i_rx(s_tx_uart),
	  .o_tx(s_rx_uart),
	  
	  .o_max7219_load (s_max7219_load),
	  .o_max7219_data (s_max7219_data),
	  .o_max7219_clk  (s_max7219_clk)
	  );
   
   // ===============


endmodule // tb_top
