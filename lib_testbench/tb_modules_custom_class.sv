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

 
   /* =================
    * == CONSTRUCTOR ==
    * =================
    */
   function new ();

   endfunction // new


   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   // Initialization of Enabled Testbench Modules
   virtual task init_tb_modules(); 
      begin
	 // By Default => No Custom Modules

      end      
   endtask // init_tb_modules


   // Launch Sequencer of Custom Testbench Modules
   virtual task run_seq_custom_tb_modules (input string line,
					   output logic o_cmd_custom_exists,
					   output logic o_cmd_custom_done
					   );
      begin
	// By Default => No Custom Modules
	 o_cmd_custom_exists = 0;
	 o_cmd_custom_done   = 1;
	 
	 
      end      
   endtask // run_seq_custom_tb_modules


   // Add Alias in associative array
   function void ADD_TB_CUSTOM_MODULES_ALIAS();
      
   endfunction // ADD_TB_CUSTOM_MODULES_ALIAS
   
        
  
endclass // tb_modules_custom_class




/* ==================
 * == EXTEND CLASS ==
 * ==================
 */

// tb_modules_custom_uart - Class for initialization of UART testbench module
class tb_modules_custom_uart #(parameter G_NB_UART_CHECKER   = 2,
			       parameter G_DATA_WIDTH        = 8,
			       parameter G_BUFFER_ADDR_WIDTH = 8
			       ) 
   extends tb_modules_custom_class;


   tb_uart_class #(G_NB_UART_CHECKER,
		   G_DATA_WIDTH,
		   G_BUFFER_ADDR_WIDTH
		   )
   tb_uart_class_inst = null;

   // Constructor of the class - Infos of Used modules
   function new (virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif);

      // CONSTRUCTOR
      super.new();          

      init_uart_class(uart_checker_nif);

   endfunction // new


   /* ===========================================
    * == COMMON FUNCTIONS AND TASK with PARENT ==
    * ===========================================
    */

   // INIT UART TESTBENCH CHECKER
   task init_tb_modules();
      begin
     
	 this.tb_uart_class_inst.INIT_UART_CHECKER();
	 
      end      
   endtask // init_tb_modules
   


   /* Launch UART SEQUENCER
    * Execute UART Command if exist else do nothing
    * Set o_cmd_custom_done at the end
    */
 
   task run_seq_custom_tb_modules (input string line,
				   output logic o_cmd_custom_exists,
				   output logic o_cmd_custom_done
				   );
      begin
	 
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

	 
      end                  
   endtask // run_seq_custom_tb_modules

   /* Add Alias in associative array
    *
    * 
    */
   function void ADD_TB_CUSTOM_MODULES_ALIAS(string ALIAS, int alias_index);
      this.tb_uart_class_inst.UART_TB_ADD_ALIAS(ALIAS, alias_index);      
   endfunction // ADD_TB_CUSTOM_MODULES_ALIAS
   

   /* =====================
    * == LOCAL FUNCTIONS ==
    * =====================
    */

   // INIT UART TESTBENCH CLASS
   function void init_uart_class(virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif);
  
      this.tb_uart_class_inst  = new(uart_checker_nif);    

   endfunction // init_uart_class
   
endclass // tb_modules_custom_uart
