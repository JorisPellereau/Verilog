//                              -*- Mode: Verilog -*-
// Filename        : tb_modules_custom_class.sv
// Description     : A Class which will contain Custom Testbench Block
// Author          : JorisP
// Created On      : Tue Apr 20 20:15:47 2021
// Last Modified By: JorisP
// Last Modified On: Tue Apr 20 20:15:47 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

//`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"


class tb_modules_custom_class;


   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   typedef int cmd_list_t   [string]; // Associative array of Possible Command (Ex : TX_START - COLLECT_STOP etc..)
   
   /* ===============
    * == VARIABLES ==
    * ===============
    */
   alias_list_t alias_list;        // Alias List
   cmd_list_t cmd_list[*];         // Dynamic Command list   
   int 	       cmd_list_ptr   = 0; // Command List Pointer
   int 	       alias_list_ptr = 0; // Alias List Pointer  
   int 	       i;                  // Index
   
   
 
   /* =================
    * == CONSTRUCTOR ==
    * =================
    */
   function new ();

   endfunction // new

   
   /* ===============
    * == FUNCTIONS ==
    * ===============
    */
   
   // Add Command list of Current TB Module to Global command list
   // Increment. Command List Pointer for dynamic array
   function void ADD_CMD_2_CMD_LIST(cmd_list_t tb_module_cmd_list);
      this.cmd_list[this.cmd_list_ptr] = tb_module_cmd_list; // Add commands to global list (Dynamic Array)
      this.cmd_list_ptr += 1;                                // Inc. Command List Pointer
   endfunction // ADD_CMD_2_CMD_LIST

   // Add Alias of Current TB Module to Global Alias List
   // Increment alias list pointer
   function void ADD_ALIAS_2_ALIAS_LIST(string TB_MODULE_ALIAS);
      this.alias_list[TB_MODULE_ALIAS] = this.alias_list_ptr; // Add Current TB Module Alias (string index) to Associative array - int value
      this.alias_list_ptr += 1;                               // Inc. Pointer
   endfunction // ADD_ALIAS_2_ALIAS_LIST
   
   // Add Info of Current TB Module to GLobal Info
   function void ADD_INFO(cmd_list_t tb_module_cmd_list, string TB_MODULE_ALIAS);
      ADD_CMD_2_CMD_LIST(tb_module_cmd_list);
      ADD_ALIAS_2_ALIAS_LIST(TB_MODULE_ALIAS);
   endfunction // ADD_INFO
   
   
   // Display Custom TB Module Info
   function void DISPLAY_CUSTOM_TB_MODULES_INFO();
      $display("# ================================ #");
      $display("tb_modules_custom_class Infos :\n");
      $display("Commands List : ");
      for(i = 0 ; i < this.cmd_list_ptr; i++) begin
	 $display("cmd_list[%d] : %p", i, this.cmd_list[i]);	 
      end
      $display("\n");      
      $display("Alias List : ");
      $display("alias_list : %p", this.alias_list);	 
      $display("# ================================ #");
   endfunction // DISPLAY_CUSTOM_TB_MODULES_INFO
   

   
   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   virtual task seq_custom_tb_modules();
      begin
      end      
   endtask // seq_custom_tb_modules
   

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
   function new (virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif, string UART_ALIAS);

      // CONSTRUCTOR
      super.new();      
      
      init_uart_class(uart_checker_nif, UART_ALIAS);          // Init Uart Testbench Module class
      ADD_INFO(tb_uart_class_inst.UART_CMD_ARRAY, UART_ALIAS); // Add info to global Info List
      
      //ADD_CMD_2_CMD_LIST(tb_uart_class_inst.UART_CMD_ARRAY);  // Add List of UART Command to Global List
      
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

   /* Add Alias in associative array - TBD Obsolete
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
   function void init_uart_class(virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif, 
				 string UART_ALIAS);
  
      this.tb_uart_class_inst  = new(uart_checker_nif, UART_ALIAS);    

   endfunction // init_uart_class
   
endclass // tb_modules_custom_uart
