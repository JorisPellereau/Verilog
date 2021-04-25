//                              -*- Mode: Verilog -*-
// Filename        : tb_modules_custom_class.sv
// Description     : A Class which will contain Custom Testbench Block
// Author          : JorisP
// Created On      : Tue Apr 20 20:15:47 2021
// Last Modified By: JorisP
// Last Modified On: Tue Apr 20 20:15:47 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

// All Class from Custom Testbench Modules are link here
`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"
`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/uart_checker_wrapper.sv"

class tb_modules_custom_class;

   // Testbench Infos
   logic UART_MODULES_EN;

   virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_vif;
   
   tb_uart_class tb_uart_class_inst;


   
   // Constructor of the class - Infos of Used modules
   function new (logic UART_MODULES_EN); 
      this.UART_MODULES_EN    = UART_MODULES_EN;
   endfunction // new


   // Init Class UART
   function /*tb_uart_class*/ init_uart_class(int G_NB_UART_CHECKER,
					      int     G_DATA_WIDTH,
					      int     G_BUFFER_ADDR_WIDTH,
					      virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif);
      
//					      virtual uart_checker_intf /*#(2, 8, 8)*/ uart_checker_if);
//uart_checker_intf uart_checker_if);
      tb_uart_class #( .G_NB_UART_CHECKER(G_NB_UART_CHECKER) , .G_DATA_WIDTH(G_DATA_WIDTH) , .G_BUFFER_ADDR_WIDTH(G_BUFFER_ADDR_WIDTH))
      tb_uart_class_inst = new(uart_checker_if);
      
      
      /*return*/  this.tb_uart_class_inst = tb_uart_class_inst;    
   endfunction // init_uart_class


   // Initialization of Enabled Testbench Modules
   function init_tb_modules();
      if(UART_MODULES_EN) begin
	 tb_uart_class_inst.INIT_UART_CHECKER(this.tb_uart_class_inst.uart_checker_vif); // Init UART Testbench modules	 
      end
      
   endfunction // init_tb_modules


   // Launch Sequencer of Custom Testbench Modules
   task run_seq_custom_tb_modules (
				       input string line,
				       output logic o_cmd_custom_exists,
				       output logic o_cmd_custom_done
				       );
      begin
	

	 // Internal Signals
	 logic 					    s_command_exist;
	 logic 					    s_route_uart_done;
	 
	 o_cmd_custom_exists = 0;
	 o_cmd_custom_done = 0;
      
	 if(UART_MODULES_EN) begin
	    tb_uart_class_inst.uart_tb_sequencer (
						  this.tb_uart_class_inst.uart_checker_vif,
						  line,
						  s_command_exist,
						  s_route_uart_done
						  );
	    
	    if(s_route_uart_done && s_command_exist) begin
	       o_cmd_custom_exists = 1;	    
	    end	 
	 end
	 o_cmd_custom_done = 1;      
      end
      
   endtask // run_seq_custom_tb_modules
   
  
   
  
endclass // tb_modules_custom_class
