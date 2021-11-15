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
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_generic/tb_check_level_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"


class tb_modules_custom_class #(// == CHECK LEVEL PARAMETERS ==
				parameter G_CHECK_SIZE  = 5,
				parameter G_CHECK_WIDTH = 32,

				// == UART PARAMETERS ==
				parameter G_NB_UART_CHECKER   = 2,
				parameter G_DATA_WIDTH        = 8,
				parameter G_BUFFER_ADDR_WIDTH = 8
				);
   

   /* ===========
    * == TYPES ==
    * ===========
    */
   typedef int alias_list_t [string]; // Associative array of Possible Alias
   typedef int cmd_list_t   [string]; // Associative array of Possible Command (Ex : TX_START - COLLECT_STOP etc..)
 
   /* ============
    * == STRUCT ==
    * ============
    */
   typedef struct {
      string 	  cmd_type;           // Type of Commande
      alias_list_t alias_list;        // List of Alias of Commande Type
      cmd_list_t cmd_list;            // List of Commande of Commande type
      int 	  alias_list_ptr = 0; // Alias List Pointer
   } tb_modules_infos_st;
   
   /* ===============
    * == VARIABLES ==
    * ===============
    */

   
   tb_modules_infos_st tb_modules_infos [*]; // TB Infos - Dynamic Struct
   int 	       tb_infos_ptr = 0;   
   int 	       i;                  // Index

   /* =====================================    
    * == GENERIC Testbench Modules Class ==
    * =====================================
    */
   tb_check_level_class #(G_CHECK_SIZE,
			  G_CHECK_WIDTH
			  )
   tb_check_level_inst;
   
   
   /* ======================================    
    * == Array of Testbench Modules Class ==
    * ======================================
    */

   tb_uart_class #(G_NB_UART_CHECKER  ,
		   G_DATA_WIDTH       ,
		   G_BUFFER_ADDR_WIDTH
		   )
   tb_uart_class_custom_inst [*];
   
    int 	   uart_checker_vif_ptr = 0; // Virtual interface pointer   
   
   // INIT UART TESTBENCH CLASS
   function void init_uart_custom_class(virtual uart_checker_intf #(G_NB_UART_CHECKER, 
								    G_DATA_WIDTH, 
								    G_BUFFER_ADDR_WIDTH) uart_checker_nif, 
					string UART_ALIAS);
  
      this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr]  = new(uart_checker_nif, UART_ALIAS);

      // Add Info Of current Instantiated class
      ADD_INFO(this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_COMMAND_TYPE,
	       this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_CMD_ARRAY,
	       this.tb_uart_class_custom_inst[this.uart_checker_vif_ptr].UART_ALIAS);
      
      this.uart_checker_vif_ptr += 1; // Inc Pointer
            
   endfunction // init_uart_class
  
   
 
   
   
   /* =================
    * == CONSTRUCTOR ==
    * =================
    */

   // Initialize Generic Testbench Modules
   function new (virtual check_level_intf #(G_CHECK_SIZE, G_CHECK_WIDTH) check_level_nif);
      this.tb_check_level_inst = new(check_level_nif); // Init Class object Check Level      
   endfunction // new

   
   /* ===============
    * == FUNCTIONS ==
    * ===============
    */
 
  
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
            
   endfunction // ADD_INFO
   
   
   // Display Custom TB Module Info
   function void DISPLAY_CUSTOM_TB_MODULES_INFO();
      $display("# ================================ #");           
      $display("TB Infos : ");
      $display("tb_modules_infos: %p", this.tb_modules_infos);	 	 
      $display("# ================================ #");
   endfunction // DISPLAY_CUSTOM_TB_MODULES_INFO


  
   
   /* ==========================================
    * == COMMON FUNCTIONS AND TASK to CHILDS  ==
    * ==========================================
    */

   // Sequencer of scenario command lines
   virtual task seq_custom_tb_modules(input string line);
      begin
	 string cmd_type;  // Type of the command (UART, DATA_COLLECTOR etc..)
	 string alias_str; // Alias of the Type of Command
	 string cmd;	   // Command of the type of command
	 string cmd_args;  // Args of the command
	 logic 	check_ok;	 
	 
	 decod_scn_line(line, cmd_type, alias_str, cmd, cmd_args); // Decode Scenarii lines
	 check_commands(cmd_type, alias_str, check_ok);            // Check if Command type exists and if Alias exists

	 if(check_ok == 1) begin
	    routed_commands(cmd_type, alias_str, cmd, cmd_args);   // Route commands to corect Testbench Modules
	 end	 	 
      end
   endtask // seq_custom_tb_modules
   

   // Get Line from scenario and :
   // Extract from line : cmd_type - alias and args
   virtual task decod_scn_line(input string line,
			       
			       output string o_cmd_type,
			       output string o_alias_str,
			       output string o_cmd,
			       output string o_cmd_args);
      begin
	 // == INTERNAL Variables ==
	 int line_length          = 0; // Length of the line
	 int pos_0                = 0; // Position of [ character
	 int pos_1                = 0; // Position of ] character
	 int pos_parenthesis_0    = 0; // Position of ( character
	 int pos_parenthesis_1    = 0; // Position of ) character
	 int first_space_position = 0; // First position of " " character
	 
	 int i; // Loop Index

	 string cmd_type;  // Command between beginning of line and "["	 
	 string alias_str; // Extracted Alias of the line
	 string cmd;       // Command of the commande type	 
	 string cmd_args;  // Extract char. between "(" and ")"	 
	 // ========================

	 // Get the length of the line
	 line_length = line.len();

	 // Get info. of the line
	 // Get The type of Command (UART - DATA_COLLECTOR - etc..)
	 for(i = 0; i < line_length; i++) begin

	    // Get "[" position
	    if(line.getc(i) == "[") begin
	       pos_0 = i;		  
	    end

	    // Get "]" position
	    if(line.getc(i) == "]") begin
	       pos_1 = i;		  
	    end

	    // Get "(" position
	    if(line.getc(i) == "(") begin
	       pos_parenthesis_0 = i;	       
	    end

	    // Get ")" position
	    if(line.getc(i) == ")") begin
	       pos_parenthesis_1 = i;	       
	    end
	    
	 end

	 // Get Commande Type
	 cmd_type = line.substr(0, pos_0 - 1);
	 
	 // Get Alias
	 alias_str = line.substr(pos_0 + 1, pos_1 - 1); // RM "[" and "]"

	 // Get First space position
	 first_space_position = pos_1 + 1;
	 cmd = line.substr(first_space_position + 1, pos_parenthesis_0 - 1);	 

	 // Get Commands Args
	 cmd_args = line.substr(pos_parenthesis_0 + 1 , pos_parenthesis_1 - 1); // RM "(" and ")"

	 
	 $display("DEBUG - cmd_type : %s - alias_str : %s - cmd : %s - cmd_args : %s", cmd_type, alias_str, cmd, cmd_args);
	 
	 // Output affectation
	 o_cmd_type  = cmd_type;
	 o_alias_str = alias_str;
	 o_cmd       = cmd;	 
	 o_cmd_args  = cmd_args;
	 
      end      
   endtask // seq_custom_tb_modules

   // Check if extracted commands exists
   virtual task check_commands(input string i_cmd_type,
			       input string i_alias_str,
			       output logic o_check_ok);
      begin
	 // Internal variables
	 int i                   = 0; // Loop index
	 logic i_cmd_type_exists = 0; // Command Type exists flag
	 int   cmd_type_index    = 0; // Index of command type if exists	 
	 
	 // By default check is not ok
	 o_check_ok   = 0;	 

	 // == Check if i_cmd_type is in tb_modules_info ==
	 for(i = 0; i < this.tb_infos_ptr; i++) begin
	    if(this.tb_modules_infos[i].cmd_type == i_cmd_type) begin
	       i_cmd_type_exists = 1; // Set flag to 1
	       cmd_type_index    = i; // Get index
	    end
	 end
	 // ===============================================
	 
	 if(i_cmd_type_exists == 0) begin
	    $display("Error: cmd_type %s does not exists !", i_cmd_type);
	    o_check_ok = 0;
	 end
	 // Case i_cmd_type exists
	 else begin
	    // Check if Alias exists in cmd_type
	    if(this.tb_modules_infos[cmd_type_index].alias_list.exists(i_alias_str)) begin
	       o_check_ok = 1; // Commad type and Alias Exists
	    end
	    else begin
	       $display("Error: Alias %s does not exists !", i_alias_str);	       
	    end
	 end // else: !if(i_cmd_type_exists == 0)

	 $display("DEBUG - check_commands : o_check_ok : %d", o_check_ok);
	 
      end
   endtask; // check_commands


   // Routed Commands
   // Run route_commands method of selected testbench modules
   virtual task routed_commands(input string i_cmd_type,
				input string i_alias_str,
				input string i_cmd,
				input string i_cmd_args);
      begin

	 // Internal variables
	 int i = 0; // Loop index

	 // Loop on all possible commands
	 for (i = 0; i < this.tb_infos_ptr ; i++) begin
	    
	    // Check if Commands are "UART" Types
	    if(this.tb_modules_infos[i].cmd_type == "UART" && i_cmd_type == "UART") begin
	       this.tb_uart_class_custom_inst[this.tb_modules_infos[i].alias_list[i_alias_str]].sel_uart_command(i_cmd, 
														 i_alias_str, 
														 i_cmd_args);	       
	    end

	    // Check if Commands are "DATA_COLLECTOR" Types
	    else if(this.tb_modules_infos[i].cmd_type == "DATA_COLLECTOR") begin
	       // TBD !!!
	    end
	 end
	 
      end
   endtask; // routed_commands
   
   

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
