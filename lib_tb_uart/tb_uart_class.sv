//                              -*- Mode: Verilog -*-
// Filename        : tb_uart_class.sv
// Description     : Testbench UART class
// Author          : JorisP
// Created On      : Sat Apr 17 00:36:04 2021
// Last Modified By: JorisP
// Last Modified On: Sat Apr 17 00:36:04 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

// TBD !
`include "/home/jorisp/GitHub/Verilog/lib_tb_utils/tb_utils_class.sv"

class tb_uart_class #(
		      parameter G_NB_UART_CHECKER = 2,
		      parameter G_DATA_WIDTH      = 8
		      );

   // == VIRTUAL I/F ==
   virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_vif;   
   // =================

   string  s_uart_checker_aliases [G_NB_UART_CHECKER];  // UART CHECKER ALIASES
   

   // == Interface passed in Virtual I/F ==
   function new(virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_nif);
      uart_checker_vif = uart_checker_nif; // New Virtual Interface

      // INIT ALIASES via Interface
      //s_uart_checker_aliases = uart_checker_vif.uart_checker_alias;
      
   endfunction // new
   // ====================================


   // == LIST OF UART COMMANDS ==

   // -- UART TX
   // UART[alias] TX_START(data)  // On UART(alias) send 1 TX DATA


   // -- UART RX
   // UART[alias] RX_READ(data_to_check) // On UART(alias) read and check last received data
   
   // ===========================

   const int 	   C_UART_CMD_NB = 2; // Number of Uart Command
   int  UART_CMD_ARRAY [string] = '{
			        "TX_START" : 0,
			        "RX_READ"  : 1
					      };
   
   
   

   // Get line from scenarios - Check if alias exist - Check if command exsits and return args of command

   task decod_scn_line(
		       virtual 	     uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_vif,
		       input string  line,
		       input int     uart_checker_cmd_list [string],
		       logic 	     o_command_exist,
		       output string o_uart_alias,
		       output string o_uart_cmd,
		       output string o_uart_cmd_args
		       );
      begin

	 // Internal variables
	 string alias_tmp;
	 string uart_cmd_tmp;
	 string uart_cmd_alias;
	 string uart_cmd;
	 string uart_data;
	 string uart_cmd_args;

	 int 	space_position = 0; // Position of " " character
	 
	 	 	 
	 int 	line_length;
	 int 	i; // Index for loop

	 int 	pos_0 = 0;
	 int 	pos_1 = 0;

	 o_command_exist = 0;
	 
	 
	 line_length = line.len();
	 
	 $display("Line : %s", line);

	 // Check if command exist
	 //$sscanf(line, "%s %s", uart_cmd_alias, uart_cmd_tmp);
	 
	 // Check if Command exists
	 if(line.substr(0, 3) == "UART") begin

	    // Get alias between [] and check if alias exist	    
	    for(i = 0; i < line_length; i++) begin
	       if(line.getc(i) == "[") begin
		  pos_0 = i;		  
	       end
	       
	       if(line.getc(i) == "]") begin
		  pos_1 = i;		  
	       end	       
	    end

	    uart_cmd_alias = line.substr(0, pos_1);
	    
	    space_position = pos_1 + 1;
	    uart_cmd_tmp = line.substr(space_position + 1, line.len() - 1);
	    	    
	    

	    alias_tmp = line.substr(pos_0 + 1, pos_1 - 1); // RM "[" and "]"	    
	    $display("Alias_tmp : %s", alias_tmp);

	    
	    // Check if alias exist
	    if(uart_checker_vif.uart_checker_alias.exists(alias_tmp)) begin
	       $display("Alias Exist !");

	       // Check if command exist
	       $display("cmd_type :%s uart_cmd_tmp :%s", uart_cmd_alias, uart_cmd_tmp);


	       // Position of ()
	       for(i = 0; i < uart_cmd_tmp.len() ; i ++) begin
		  if(uart_cmd_tmp.getc(i) == "(") begin
		     pos_0 = i;		    
		  end

		  if(uart_cmd_tmp.getc(i) == ")") begin
		     pos_1 = i;		     
		  end		  
	       end


	       uart_cmd = uart_cmd_tmp.substr(0, pos_0 - 1); // Get UART command
	       $display("pos_0 = %d  pos_1 : %d uart_cmd : %s", pos_0, pos_1, uart_cmd);
	       
	       
	       if(uart_checker_cmd_list.exists(uart_cmd)) begin
		  $display("UART command exist ! %s", uart_cmd);

		  // Get Args inside () if exist
		  uart_cmd_args = uart_cmd_tmp.substr(pos_0 + 1, pos_1 - 1);// RM "(" and ")"

		  // Generation of outputs		  
		  o_command_exist = 1; // End of test => Command exist
		  o_uart_alias    = alias_tmp;
		  o_uart_cmd      = uart_cmd;
		  o_uart_cmd_args = uart_cmd_args;
		  
		  
	       end
	       else begin
		  $display("UART command doesn't exist ! %s", uart_cmd);
		  o_command_exist = 0;  // End of test => Command don't exist
	       end
	       
	       
	    end
	    else begin
	       $display("Alias Doesn't Exist !");
	       o_command_exist = 0;  // End of test => Command don't exist
	    end
	    
	    
	 end
	 else begin
	    $display("Error: Command not recognized");
	    o_command_exist = 0;  // End of test => Command don't exist	    
	 end // else: !if(line.substr(0, 3) == "UART")
      end
      
   endtask // decod_scn_line


   // TASK : Init UART checker
   task INIT_UART_CHECKER(virtual 	     uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_vif);

      begin

	 int i;
	 for(i = 0 ; i < uart_checker_vif.G_NB_UART_CHECKER; i++) begin
	    uart_checker_vif.start_tx[i] = 0;
	    uart_checker_vif.tx_data[i] = 4'hAA; // TBD
	    uart_checker_vif.s_rd_ptr_soft[i] = 0;
	    
	    // 	 
	    //    
	 end
	 
      end
   endtask // INIT_UART_CHECKER
   

   /*utils_class utils;
   utils = new ();*/

   //static tb_utils_class toto;
   //toto = new();
   
   
   /* Task : TX_START - Send a byte or multiple bytes on TX UART
    * * BLOCKING COMMAND
    * 
    */

   task UART_TX_START (
		       virtual 	     uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_vif,
		       input string uart_alias,
		       input string uart_cmd,
		       input string uart_cmd_args
		       
		       );
      begin

	 /*tb_utils_class toto;
	 

	 utils = new (8);*/
	 
	 
	 // Internal Variables
	 int data_nb = 0;
	 int i = 0;
	 string data_array [];
	 
	 int 	space_position = 0;
	 int 	start_pos = 0;
	 
	 int 	data_cnt = 0;

	 int 	data_int = 0;
	 
	 
	 int data_tmp;
	 
	 string str_tmp;

	 int 	array_index = 0;
	 
	 
	 
	 
	 // Get the number of data in uart_cmd_args
	 for(i = 0 ; i < uart_cmd_args.len() ; i ++) begin
	    if(uart_cmd_args.getc(i) == " ") begin
	       data_nb += 1;	       
	    end	    	    
	 end

	 data_nb += 1; // Number of space + 1
	 

	 $display("data_nb : %d" , data_nb);
	 data_array = new [data_nb]; // Create a dynamic array with the number of data
	 

	 // Store data in an array
	 for(i = 0 ; i < uart_cmd_args.len() ; i ++) begin
	    if(uart_cmd_args.getc(i) == " ") begin	       
	       space_position = i;
	       if(data_cnt < data_nb) begin
		  data_array[data_cnt] = uart_cmd_args.substr(start_pos, space_position -1);
		  data_cnt += 1;
		  $display("data_cnt : %d" , data_cnt);
		  
	       end
	       start_pos = space_position + 1; // Update Start Position       
	    end
	 
   	 end // for (i = 0 ; i < uart_cmd_args.len() ; i ++)

	 // Fill Last data
	 data_array[data_nb - 1] = uart_cmd_args.substr(start_pos, uart_cmd_args.len() - 1);

	 $display("%p", data_array);


	 
	 for(i = 0 ; i < data_nb ; i ++) begin

	    // Convert STR to int
	    if( {data_array[i].getc(0), data_array[i].getc(1)} == "0x") begin

	       str_tmp = data_array[i].substr(2, data_array[i].len() - 1); // Remove 0x
	       
	       data_tmp = str_tmp.atohex();
	              		 
	    end	   
	    else begin
	       data_tmp = data_array[i].atoi();	       
	    end
	    
	    
	    $display("data_tmp : %d", data_tmp);

	    // Generation of a pulse of TX UART[alias]
	    @(posedge uart_checker_vif.clk);

	    array_index = uart_checker_vif.uart_checker_alias[uart_alias];
	    $display("array_index : %d", array_index);
	    
	    uart_checker_vif.tx_data[array_index]  = data_tmp;
	    uart_checker_vif.start_tx[array_index] = 1;

	    @(posedge uart_checker_vif.clk);
	    //uart_checker_vif.tx_data[array_index]  = 0;
	    uart_checker_vif.start_tx[array_index] = 0;

	    @(posedge uart_checker_vif.tx_done[array_index]); // Wait for UART[alias] tx_done
	    $display("UART TX DONE !");
	    $display("index i : %d", i);
	    
	    
	 end // for (i = 0 ; i < data_nb ; i ++)
	 
	 
	 
	 $display("End of TX_START");
	 
      end
   endtask // UART_TX_START



   /* TASK : UART_RX_READ
    *
    * - Check Value in RX buffer - Non Blocking command
    */

   task UART_RX_READ(
		     virtual 	  uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH) uart_checker_vif,
		     input string uart_alias,
		     input string uart_cmd,
		     input string uart_cmd_args);
      begin

	 // INTERNAL VARIABLES
	 int data_nb = 0;
	 int space_position = 0;
	 int start_pos = 0;
	 int data_cnt = 0;
	 int i = 0;	 
	 int data_tmp [];	 
	 string str_tmp;	 
	 string data_array [];
	 int 	array_index = 0;

	 array_index = uart_checker_vif.uart_checker_alias[uart_alias]; // Get Array Index
	 
	 // Get the number of data in uart_cmd_args
	 for(i = 0 ; i < uart_cmd_args.len() ; i ++) begin
	    if(uart_cmd_args.getc(i) == " ") begin
	       data_nb += 1;	       
	    end	    	    
	 end

	 data_nb += 1; // Number of space + 1


	 data_array = new [data_nb]; // Create a dynamic array with the number of data
	 data_tmp   = new [data_nb];
	 

	 // Store data in an array
	 for(i = 0 ; i < uart_cmd_args.len() ; i ++) begin
	    if(uart_cmd_args.getc(i) == " ") begin	       
	       space_position = i;
	       if(data_cnt < data_nb) begin
		  data_array[data_cnt] = uart_cmd_args.substr(start_pos, space_position -1);
		  data_cnt += 1;
		  $display("data_cnt : %d" , data_cnt);
		  
	       end
	       start_pos = space_position + 1; // Update Start Position       
	    end
	 
   	 end // for (i = 0 ; i < uart_cmd_args.len() ; i ++)

	 // Fill Last data
	 data_array[data_nb - 1] = uart_cmd_args.substr(start_pos, uart_cmd_args.len() - 1);

	 $display("%p", data_array);


	 // Fill Data to check
	 for(i = 0 ; i < data_nb ; i ++) begin

	    // Convert STR to INT
	    if( {data_array[i].getc(0), data_array[i].getc(1)} == "0x") begin

	       str_tmp = data_array[i].substr(2, data_array[i].len() - 1); // Remove 0x
	       
	       data_tmp[i] = str_tmp.atohex();
	              		 
	    end	   
	    else begin
	       data_tmp[i] = data_array[i].atoi();	       
	    end
	 end // for (i = 0 ; i < data_nb ; i ++)
	    

	 for(i = 0 ; i < data_nb ; i ++) begin

	    // Check if data is stored
	    if(uart_checker_vif.s_buffer_rx_soft[array_index][uart_checker_vif.s_rd_ptr_soft[array_index]] == data_tmp[i]) begin
	       $display("UART RX_READ(%x) - Expected %x => OK", data_tmp[i], uart_checker_vif.s_buffer_rx_soft[array_index][uart_checker_vif.s_rd_ptr_soft[array_index]]);	       
	    end
	    else begin
	       $display("UART RX_READ(%x) - Expected %x => Error", data_tmp[i], uart_checker_vif.s_buffer_rx_soft[array_index][uart_checker_vif.s_rd_ptr_soft]);
	    end

	    if(uart_checker_vif.s_rd_ptr_soft[array_index] < uart_checker_vif.s_wr_ptr_soft[array_index]) begin
	       uart_checker_vif.s_rd_ptr_soft[array_index] = uart_checker_vif.s_rd_ptr_soft[array_index] + 1; // Inc	       
	    end
	    else begin
	       $display("UART - Error : Buffer Read pointer soft > Buffer Write pointer soft");
	       
	    end
	    
	    //#1;
	    
	    
	    
	 end
	 
	 

	    
        
	 $display("UART_RX_READ END");
	 

	 
      end
   endtask // UART_RX_READ
   
      
  
endclass // tb_uart_class
