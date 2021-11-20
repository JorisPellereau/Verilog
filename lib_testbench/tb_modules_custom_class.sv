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
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_generic/tb_wait_event_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_generic/tb_check_level_class.sv"
`include "/home/linux-jp/Documents/GitHub/Verilog/lib_tb_uart/tb_uart_class.sv"


class tb_modules_custom_class #(
				// == WAIT EVENT PARAMETERS ==
				parameter G_WAIT_SIZE  = 5,
				parameter G_WAIT_WIDTH = 1,
				parameter G_CLK_PERIOD = 1000, // Unity : ps
				
				// == CHECK LEVEL PARAMETERS ==
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
   typedef string regular_cmd_list_t [int]; // Associative array of Regular Commands
   
   /* ============
    * == STRUCT ==
    * ============
    */
   typedef struct {
      string 	  cmd_type;           // Type of Commande
      alias_list_t alias_list;        // List of Alias of Commande Type
      cmd_list_t cmd_list;            // List of Commande of Commande type
      int 	  alias_list_ptr = 0; // Alias List Pointer
      bit 	  is_regular_cmd = 0; // Regular Command (CHK-WAIT-SET ..) or Custom command (UART - DATA_COLLECTOR ..)
   } tb_modules_infos_st;

   /* ================
    * == CONSTANTES ==
    * ================
    */
   const int regular_cmd_nb = 7;
   tb_modules_infos_st regular_tb_modules_infos[7-1:0];

   regular_cmd_list_t regular_cmd_list = '{0         : "SET",
					   1         : "WTR",
					   2         : "WTF",
					   3         : "WTRS",
					   4         : "WTFS",
					   5         : "CHK" ,
					   6         : "WAIT",
					   7         : "MODELSIM_CMD"
					   };

   
   /* ===============
    * == VARIABLES ==
    * ===============
    */

   
   tb_modules_infos_st tb_modules_infos [*]; // TB Infos of Custom Testbench Modules - Dynamic Struct
   int 	       tb_infos_ptr = 0;   
   int 	       i;                  // Index

   
   

   /* =====================================    
    * == GENERIC Testbench Modules Class ==
    * =====================================
    */

   // Wait Event Testbench Module
   tb_wait_event_class #(G_WAIT_SIZE,
			 G_WAIT_WIDTH,
			 G_CLK_PERIOD // Unity : ps
			 )
   tb_wait_event_inst;   

   // Check Level Testbench Module
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
   
   // INIT UART TESTBENCH CLASS and Add Info
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
   function new (virtual wait_event_intf  #(G_WAIT_SIZE, G_WAIT_WIDTH)   wait_event_nif,
		 virtual check_level_intf #(G_CHECK_SIZE, G_CHECK_WIDTH) check_level_nif);

      this.tb_wait_event_inst  = new(wait_event_nif);  // Init Class Object Wait Event      
      this.tb_check_level_inst = new(check_level_nif); // Init Class object Check Level

      // Init Regular TB Modules Infos
      for(i = 0; i < this.regular_cmd_list.size(); i++) begin
	 this.regular_tb_modules_infos[i].cmd_type       = this.regular_cmd_list[i];
	 this.regular_tb_modules_infos[i].is_regular_cmd = 1;                       // Regular Command	 
      end
   endfunction // new

   
   /* ===============
    * == FUNCTIONS ==
    * ===============
    */
 
  
   // Add Info of Current Custom TB Module to GLobal Info
   function void ADD_INFO(string cmd_type, cmd_list_t tb_module_cmd_list, string TB_MODULE_ALIAS);
            
      // Internal Variables
      int      cmd_type_already_exists = 0;
      int      cmd_type_index          = 0;
      bit      is_regular = 0;
      
      
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

      // == Check if cmd_type is a regular command or not ==
      // if(this.regular_cmd_list.exists(cmd_type) == 1) begin
      // 	 is_regular = 1;	 
      // end
      // else begin
      // 	 is_regular = 0;	 
      // end
      // ===================================================

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

	 // Add info of regular cmd
	 this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd = is_regular;
	 
	 $display("this.tb_modules_infos[this.tb_infos_ptr].cmd_type : %s", this.tb_modules_infos[this.tb_infos_ptr].cmd_type);
	 $display("this.tb_modules_infos[this.tb_infos_ptr].alias_list : %p", this.tb_modules_infos[this.tb_infos_ptr].alias_list);
	 $display("this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd : %d", this.tb_modules_infos[this.tb_infos_ptr].is_regular_cmd);
	 
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
   
   // REGULAR_TB_MODULE_ADD_INFO
   function void REGULAR_TB_MODULES_ADD_INFO();
      this.regular_tb_modules_infos[1].alias_list = this.tb_wait_event_inst.wait_event_alias_list;   // Get Alias List of WTR
      this.regular_tb_modules_infos[2].alias_list = this.tb_wait_event_inst.wait_event_alias_list;   // Get Alias List of WTF
      this.regular_tb_modules_infos[3].alias_list = this.tb_wait_event_inst.wait_event_alias_list;   // Get Alias List of WTRS
      this.regular_tb_modules_infos[4].alias_list = this.tb_wait_event_inst.wait_event_alias_list;   // Get Alias List of WTFS
      this.regular_tb_modules_infos[5].alias_list = this.tb_check_level_inst.check_level_alias_list; // Get ALias List of Check Level
      
            
   endfunction // REGULAR_TB_MODULES_ADD_INFO

   // Display Regular TB Module Info
   function void DISPLAY_REGULAR_TB_MODULES_INFO();
      $display("# ================================ #");           
      $display("Regular TB Infos : ");
      for(i = 0; i < this.regular_cmd_nb; i++) begin
	 $display("cmd_type   : %s", this.regular_tb_modules_infos[i].cmd_type);
	 $display("alias_list : %p\n", this.regular_tb_modules_infos[i].alias_list);
      end	 	 
      $display("# ================================ #");
   endfunction // DISPLAY_REGULAR_TB_MODULES_INFO
   
   
   // Display Custom TB Module Info
   function void DISPLAY_CUSTOM_TB_MODULES_INFO();
      $display("# ================================ #");           
      $display("TB Infos : ");
      for(i = 0 ; i < this.tb_infos_ptr ; i++) begin
	 $display("cmd_type   : %s", this.tb_modules_infos[i].cmd_type);
	 $display("alias_list : %p", this.tb_modules_infos[i].alias_list);
	 $display("cmd_list   : %p\n", this.tb_modules_infos[i].cmd_list);
      end      	 
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
	 logic 	check_ok;  // Check OK "1" or KO "0"
	 logic 	is_regular_cmd; // Regular command when  == '1'	  
	 
	 decod_scn_line(line, cmd_type, alias_str, cmd, cmd_args); // Decode Scenarii lines
	 check_commands(cmd_type, alias_str, check_ok, is_regular_cmd);            // Check if Command type exists and if Alias exists

	 if(check_ok == 1) begin
	    routed_commands(cmd_type, alias_str, cmd, cmd_args, is_regular_cmd);   // Route commands to corect Testbench Modules
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
			       output logic o_check_ok,
			       output logic o_is_regular_cmd);
      begin
	 // Internal variables
	 int i                   = 0; // Loop index
	 logic i_cmd_type_exists = 0; // Command Type exists flag
	 int   cmd_type_index    = 0; // Index of command type if exists
	 
	 int   is_regular_cmd = 0;
	 
	 
	 // By default check is not ok
	 o_check_ok   = 0;

	 // == Check if i_cmd_type is a regular command or not
	 for(i = 0; i < this.regular_cmd_nb ; i ++) begin
	    if(this.regular_tb_modules_infos[i].cmd_type == i_cmd_type) begin
	       is_regular_cmd    = 1;
	       i_cmd_type_exists = 1; // Set flag to 1
	       cmd_type_index    = i; // Get index
	    end
	 end
	 
	 // == Check if i_cmd_type is in tb_modules_info only if it is not a regular cmd ==
	 if(is_regular_cmd == 0) begin
	    for(i = 0; i < this.tb_infos_ptr; i++) begin
	       if(this.tb_modules_infos[i].cmd_type == i_cmd_type) begin
		  i_cmd_type_exists = 1; // Set flag to 1
		  cmd_type_index    = i; // Get index
	       end
	    end
	 end
	 // ===============================================
	 
	 if(i_cmd_type_exists == 0) begin
	    $display("Error: cmd_type %s does not exists !", i_cmd_type);
	    o_check_ok = 0;
	 end
	 // Case i_cmd_type exists
	 else begin

	    // Check if Alias exists in regular cmd type
	    if(is_regular_cmd == 1) begin
	       if(this.regular_tb_modules_infos[cmd_type_index].alias_list.exists(i_alias_str)) begin
		  o_check_ok = 1;		  
	       end
	       else begin
		  $display("Error: Alias %s does not exists !", i_alias_str);
	       end
	    end
	    else begin
	       // Check if Alias exists in cmd_type (not a regular cmd)
	       if(this.tb_modules_infos[cmd_type_index].alias_list.exists(i_alias_str)) begin
		  o_check_ok = 1; // Commad type and Alias Exists
	       end
	       else begin
		  $display("Error: Alias %s does not exists !", i_alias_str);	       
	       end
	    end
	 end // else: !if(i_cmd_type_exists == 0)

	 $display("DEBUG - check_commands : o_check_ok : %d", o_check_ok);

	 o_is_regular_cmd = is_regular_cmd;	 
      end
   endtask; // check_commands


   // Routed Commands
   // Run route_commands method of selected testbench modules
   virtual task routed_commands(input string i_cmd_type,
				input string i_alias_str,
				input string i_cmd,
				input string i_cmd_args,
				input logic  i_is_regular_cmd);
      begin

	 // Internal variables
	 int i = 0; // Loop index

	 if(i_is_regular_cmd == 0) begin
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
	    end // for (i = 0; i < this.tb_infos_ptr ; i++)
	 end // if (i_is_regular_cmd == 0)

	 
	 else begin
	    // Loop For REGULAR Commands
	    for(i = 0; i < this.regular_cmd_nb ; i++) begin

	       // Check Commands
	       if(this.regular_tb_modules_infos[i].cmd_type == "CHK" && i_cmd_type == "CHK") begin
		  this.tb_check_level_inst.sel_check_level_command(i_cmd_type,
								   i_alias_str,
								   i_cmd_args);
	       end
	       // Wait Event Command
	       else if(
		       (this.regular_tb_modules_infos[i].cmd_type == "WTR" && i_cmd_type == "WTR")   ||
		       (this.regular_tb_modules_infos[i].cmd_type == "WTF" && i_cmd_type == "WTF")   ||
		       (this.regular_tb_modules_infos[i].cmd_type == "WTRS" && i_cmd_type == "WTRS") || 
		       (this.regular_tb_modules_infos[i].cmd_type == "WTFS" && i_cmd_type == "WTRS") ) begin
		  this.tb_wait_event_inst.sel_wait_event_command(i_cmd_type,
								 i_alias_str,
								 i_cmd_args);
		  
	       end
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
