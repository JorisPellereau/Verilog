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


class tb_modules_custom_class #(parameter G_NB_UART_CHECKER   = 2,
				parameter G_DATA_WIDTH        = 8,
				parameter G_BUFFER_ADDR_WIDTH = 8
				);
   


   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   typedef int cmd_list_t   [string]; // Associative array of Possible Command (Ex : TX_START - COLLECT_STOP etc..)
   //typedef int cmd_type     [string]; // Associative array of Type of Commande (UART - DATA_COLLECTOR etc..)
   
   /* ============
    * == STRUCT ==
    * ============
    */
   typedef struct {
      string 	  cmd_type;           // Type of Commande
      alias_list_t alias_list;   // List of Alias of Commande Type
      cmd_list_t cmd_list;       // List of Commande of Commande type
      int 	  alias_list_ptr = 0; // Alias List Pointer
   } tb_modules_infos_st;
   
   /* ===============
    * == VARIABLES ==
    * ===============
    */
   alias_list_t alias_list;        // Alias List - Associative Array
   cmd_list_t cmd_list[*];         // Dynamic Command list
   
   tb_modules_infos_st tb_modules_infos [*]; // TB Infos - Dynamic Struct
   int 		  tb_infos_ptr = 0;
   
   
   int 	       cmd_list_ptr   = 0; // Command List Pointer
   int 	       alias_list_ptr = 0; // Alias List Pointer  
   int 	       i;                  // Index
   
   // == VIRTUAL I/F of Testbench Modules ==
   // UART Checker interface
   //virtual uart_checker_intf  #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_vif [*]; // Dynamic Array or UART I/F
   int 	   uart_checker_vif_ptr = 0; // Virtual interface pointer   
   // =================
   
   /* ======================================    
    * == Array of Testbench Modules Class ==
    * ======================================
    */

   tb_uart_class #(G_NB_UART_CHECKER  ,
		   G_DATA_WIDTH       ,
		   G_BUFFER_ADDR_WIDTH
		   )
   tb_uart_class_custom_inst [*];

   
   // INIT UART TESTBENCH CLASS
   function void init_uart_custom_class(virtual uart_checker_intf #(G_NB_UART_CHECKER, 
								    G_DATA_WIDTH, 
								    G_BUFFER_ADDR_WIDTH) uart_checker_nif, 
					string UART_ALIAS);
  
      this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr]  = new(uart_checker_nif, UART_ALIAS);
      this.uart_checker_vif_ptr += 1; // Inc Pointer      
   endfunction // init_uart_class
  
   
 
   
   
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
   function void ADD_INFO(string cmd_type, cmd_list_t tb_module_cmd_list, string TB_MODULE_ALIAS);
            
      // Internal Variables
      int      cmd_type_already_exists = 0;
      int      cmd_type_index          = 0;
      
      $display("DEBUG - ADD_INFO function !");
      $display("this.tb_infos_ptr : %d", this.tb_infos_ptr);
      
      // == Check if cmd_type is already stored in tb_modules_infos
      for(i = 0 ; i < this.tb_infos_ptr; i++) begin	 
	 if(cmd_type_already_exists == 0) begin
	    if(this.tb_modules_infos[i].cmd_type == cmd_type) begin
	       cmd_type_already_exists = 1; // Command Already Exists
	       cmd_type_index          = i; // Save the index
	       $display("DEBUG - tb_modules_custom_class : Command Type already exists - index : %d !", cmd_type_index);
	       
	    end
	 end
      end

      // If cmd_type doesnt exists, add it to array of struct
      if(cmd_type_already_exists == 0) begin
	 $display("cmd_type_already_exists == 0");	
	 $display("cmd_type : %s - tb_module_cmd_list : %p", cmd_type, tb_module_cmd_list);
	 
	 // Add Command type
	 this.tb_modules_infos[this.tb_infos_ptr].cmd_type = cmd_type;
	 
	 // Add Alias
	 this.tb_modules_infos[this.tb_infos_ptr].alias_list[TB_MODULE_ALIAS] = this.tb_modules_infos[this.tb_infos_ptr].alias_list_ptr;
	 this.tb_modules_infos[this.tb_infos_ptr].alias_list_ptr += 1; // Inc Alias Pointer
	 
	 // Add Command List
	 this.tb_modules_infos[this.tb_infos_ptr].cmd_list = tb_module_cmd_list; // Same List of command for cmd_type
	 
	 $display("this.tb_modules_infos[this.tb_infos_ptr].cmd_type : %s", this.tb_modules_infos[this.tb_infos_ptr].cmd_type);
	 $display("this.tb_modules_infos[this.tb_infos_ptr].alias_list : %p", this.tb_modules_infos[this.tb_infos_ptr].alias_list);
	 
	 this.tb_infos_ptr += 1; // Inc Pointer	
	 $display("this.tb_infos_ptr : %d\n", this.tb_infos_ptr);
	 
	 
//  
      end // if (cmd_type_already_exists == 0)
      // If cmd_already exists - Check if Alias is not already in the list, if not add it to struct
      else begin

	 // Check if Alias already exists in the list 
	 if(this.tb_modules_infos[cmd_type_index].alias_list.exists(TB_MODULE_ALIAS) == 0) begin
	    $display("Alias does not exists : %s", TB_MODULE_ALIAS);
	    
	    this.tb_modules_infos[cmd_type_index].alias_list[TB_MODULE_ALIAS] = this.tb_modules_infos[cmd_type_index].alias_list_ptr;
	    this.tb_modules_infos[cmd_type_index].alias_list_ptr += 1; // Inc Alias Pointer
	 end
	 else begin
	    $display("Error: %s already exists in tb_modules_infos !", TB_MODULE_ALIAS);	    
	 end
      end

      $display("this.tb_modules_infos : %p\n\n", this.tb_modules_infos);
      
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
      
      $display("\n");      
      $display("TB Infos : ");
      //for(i = 0; i < this.tb_infos_ptr ; i++) begin
      $display("tb_modules_infos: %p", i, this.tb_modules_infos);	 
      //end	 
      $display("# ================================ #");
   endfunction // DISPLAY_CUSTOM_TB_MODULES_INFO


   // Add extend class to an array
   // function void INIT_TB_MODULES_CUSTOM_UART(virtual uart_checker_intf #(G_NB_UART_CHECKER_PER_INST[inst_nb], 
   // 										      G_DATA_WIDTH[inst_nb], 
   // 										      G_BUFFER_ADDR_WIDTH[inst_nb]) uart_checker_nif, */
   // 					     string UART_ALIAS [*]);

   //    for(i = 0 ; i < G_NB_UART_CHECKER_INST; i++) begin
   // 	 this.tb_uart_class_inst[this.uart_checker_list_ptr] = new(uart_checker_nif, UART_ALIAS[i]);
   // 	 this.uart_checker_list_ptr += 1;
   //    end
   // endfunction // INIT_TB_MODULES_CUSTOM_UART
   
   // tb_modules_custom_uart

   
   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   // Get Line from scenario and :
   // Check if Command exists - Display error if it doesnt and abort
   // Check if Alias exixts    - Display error if it doesnt and abort
   // If ok get argument and send if to correct TB Module Tasks
   virtual task seq_custom_tb_modules(input string line);
      begin
	 // == INTERNAL Variables ==
	 int tb_module_cmd_len    = 0; // Len of tb_module_cmd
	 int line_length          = 0; // Length of the line
	 int pos_0                = 0; // Position of [ character
	 int pos_1                = 0; // Position of ] character
	 int first_space_position = 0; // First position of " " character
	 
	 int i; // Loop Index

	 string cmd_type;  // Command between beginning of line and fier "["	 
	 string alias_str; // Extracted Alias of the line
	 // ========================

	 // Get the length of the line
	 line_length = line.len();

	 // Get info. of the line
	 // Get The type of Command (UART - DATA_COLLECTOR - etc..)
	 for(i = 0; i < line_length; i++) begin	    
	    if(line.getc(i) == "[") begin
	       pos_0 = i;		  
	    end
	       
	    if(line.getc(i) == "]") begin
	       pos_1 = i;		  
	    end
	 end

	 // Get Commande Type
	 cmd_type = line.substr(0, pos_0 - 1);
	 
	 // Get Alias
	 alias_str = line.substr(pos_0 + 1, pos_1 - 1); // RM "[" and "]"
	 

	 // Check if command exists
	 // if(line.substr(0, tb_module_cmd_len - 1) == tb_module_cmd) begin

	 //    // Get alias between [] and check if alias exist	    
	 //    for(i = 0; i < line_length; i++) begin
	 //       if(line.getc(i) == "[") begin
	 // 	  pos_0 = i;		  
	 //       end
	       
	 //       if(line.getc(i) == "]") begin
	 // 	  pos_1 = i;		  
	 //       end	       
	 //    end

	    

	    // Get First space position
	    first_space_position = pos_1 + 1;
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
      //ADD_INFO(tb_uart_class_inst.UART_COMMAND_TYPE, tb_uart_class_inst.UART_CMD_ARRAY, UART_ALIAS); // Add info to global Info List
      
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
