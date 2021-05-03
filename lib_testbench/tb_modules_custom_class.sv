//                              -*- Mode: Verilog -*-
// Filename        : tb_modules_custom_class.sv
// Description     : A Class which will contain Custom Testbench Block
// Author          : JorisP
// Created On      : Tue Apr 20 20:15:47 2021
// Last Modified By: JorisP
// Last Modified On: Tue Apr 20 20:15:47 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"


class tb_modules_custom_class;


   // UART parameters
   int 	 G_NB_UART_CHECKER;
   int 	 G_DATA_WIDTH;
   int 	 G_BUFFER_ADDR_WIDTH;
   
   

 
   /* =================
    * == CONSTRUCTOR ==
    * =================
    */
   function new (int G_NB_UART_CHECKER_new   = 1,
		 int G_DATA_WIDTH_new        = 8,
		 int G_BUFFER_ADDR_WIDTH_new = 8
		 );

      // UART TESTBENCH PARAMETERS
      this.G_NB_UART_CHECKER   = G_NB_UART_CHECKER_new;
      this.G_DATA_WIDTH        = G_DATA_WIDTH_new;
      this.G_BUFFER_ADDR_WIDTH = G_BUFFER_ADDR_WIDTH_new;
      
   endfunction // new


   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   // Initialization of Enabled Testbench Modules
   function void init_tb_modules();     
      // By Default => No Custom Modules
   endfunction // init_tb_modules


   // Launch Sequencer of Custom Testbench Modules
   task run_seq_custom_tb_modules (input string line,
				   output logic o_cmd_custom_exists,
				   output logic o_cmd_custom_done
				   );
      begin
	// By Default => No Custom Modules

	 //$display("run_seq_custom_tb_modules - tb_modules_custom_class done");	 
      end      
   endtask // run_seq_custom_tb_modules
        
  
endclass // tb_modules_custom_class




/* ==================
 * == EXTEND CLASS ==
 * ==================
 */

class tb_modules_custom_uart extends tb_modules_custom_class;


   tb_uart_class tb_uart_class_inst = null;

   // Constructor of the class - Infos of Used modules
   function new (virtual uart_checker_intf uart_checker_nif,
		 int G_NB_UART_CHECKER_new   = 1,
		 int G_DATA_WIDTH_new        = 8,
		 int G_BUFFER_ADDR_WIDTH_new = 8		
		 );

      // CONSTRUCTOR
      super.new(G_NB_UART_CHECKER_new,
		G_DATA_WIDTH_new,
		G_BUFFER_ADDR_WIDTH_new);          

      init_uart_class(uart_checker_nif);

      //super.run_seq_custom_tb_modules();
      
      
 

   endfunction // new


   /* ===========================================
    * == COMMON FUNCTIONS AND TASK with PARENT ==
    * ===========================================
    */

   // INIT UART TESTBENCH CHECKER
   function void init_tb_modules();
	 this.tb_uart_class_inst.INIT_UART_CHECKER();       // this ?
   endfunction // init_tb_modules


   /* Launch UART SEQUENCER
    * Execute UART Command if exist else do nothing
    * Set o_cmd_custom_done at the end
    */
   
   task run_seq_custom_tb_modules (input string line,
				   output logic o_cmd_custom_exists,
				   output logic o_cmd_custom_done);
      begin

	 // Link with Parent Task
	 /*super.run_seq_custom_tb_modules (line,
					  o_cmd_custom_exists,
					  o_cmd_custom_done);*/
	 
	 logic 	s_command_exist;	 	 
	 logic 	s_route_uart_done;	 
	 
	 o_cmd_custom_exists = 0;
	 o_cmd_custom_done   = 0;

	 // Lauch UART Sequencer
	 this.tb_uart_class_inst.uart_tb_sequencer (line,
						    s_command_exist,
						    s_route_uart_done
						    );
	 
	 if(s_route_uart_done && s_command_exist) begin
	    o_cmd_custom_exists = 1;	    
	 end	 
	 o_cmd_custom_done = 1;

	 $display("run_seq_custom_tb_modules - UART extends done");	 
	 
      end                  
   endtask // run_seq_custom_tb_modules
   

   /* =====================
    * == LOCAL FUNCTIONS ==
    * =====================
    */

   // INIT UART TESTBENCH CLASS
   function void init_uart_class(virtual uart_checker_intf uart_checker_nif);      
      this.tb_uart_class_inst = new(G_NB_UART_CHECKER,
				    G_DATA_WIDTH,
				    G_BUFFER_ADDR_WIDTH,uart_checker_nif);                     
   endfunction // init_uart_class
   
endclass // tb_modules_custom_uart
