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
//`include "/home/jorisp/GitHub/Verilog/lib_tb_uart/uart_checker_wrapper.sv"


class tb_modules_custom_class;

   logic test;

   // UART parameters
    int 	 G_NB_UART_CHECKER;
    int 	 G_DATA_WIDTH;
    int 	 G_BUFFER_ADDR_WIDTH;
   
   
   //tb_uart_class tb_uart_class_inst = null;
   
   //virtual uart_checker_intf uart_checker_vif;
   
   
 
   // Constructor of the class - Infos of Used modules
   function new (
		 int G_NB_UART_CHECKER_new = 1,
		 int G_DATA_WIDTH_new = 8,
		 int G_BUFFER_ADDR_WIDTH_new = 8
		  ); 
      G_NB_UART_CHECKER = G_NB_UART_CHECKER_new;
      G_DATA_WIDTH = G_DATA_WIDTH_new;
      G_BUFFER_ADDR_WIDTH = G_BUFFER_ADDR_WIDTH_new;
      

   endfunction // new



   
   /*static function tb_modules_custom_class create_custom_module_uart(virtual uart_checker_intf uart_checker_nif,
								     int     G_NB_UART_CHECKER = 1,
								     int     G_DATA_WIDTH = 8,
								     int     G_BUFFER_ADDR_WIDTH = 8
								     );

      tb_modules_custom_class tb_modules_custom_class_inst = new(G_NB_UART_CHECKER,
								 G_DATA_WIDTH,
								 G_BUFFER_ADDR_WIDTH);

      tb_modules_custom_class_inst.init_uart_class(uart_checker_nif);
      
      return tb_modules_custom_class_inst;      
   endfunction;*/ // tb_uart_class
   

   
   // Init Class UART
   /*function void init_uart_class( virtual uart_checker_intf uart_checker_nif);
      
      tb_uart_class_inst = new(G_NB_UART_CHECKER,
				    G_DATA_WIDTH,
				    G_BUFFER_ADDR_WIDTH,uart_checker_nif);
        
            
 
   endfunction*/ // init_uart_class


   // Initialization of Enabled Testbench Modules
   function void init_tb_modules();
      /*$display("Avant if init_uart_tb)");
      $display("G_DATA_WIDTH : %d", G_DATA_WIDTH);
      
      
      if(tb_uart_class_inst != null) begin
	 $display("Dans init_uart");
	 
	 tb_uart_class_inst.INIT_UART_CHECKER(); 
	 $display("apres init_uart");
      end
      $display("Fin init_tb_modules");*/

      
   endfunction // init_tb_modules


   // Launch Sequencer of Custom Testbench Modules
   /*task run_seq_custom_tb_modules (
				       input string line,
				       output logic o_cmd_custom_exists,
				       output logic o_cmd_custom_done
				       );
      begin
	

	
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
      
   endtask*/ // run_seq_custom_tb_modules
   
  
   
  
endclass // tb_modules_custom_class



class tb_modules_custom_uart extends tb_modules_custom_class;


   tb_uart_class tb_uart_class_inst = null;

   // Constructor of the class - Infos of Used modules
   function new (virtual uart_checker_intf uart_checker_nif,
		 int G_NB_UART_CHECKER_new = 1,
		 int G_DATA_WIDTH_new = 8,
		 int G_BUFFER_ADDR_WIDTH_new = 8
		
		  );

      super.new( G_NB_UART_CHECKER_new,
		 G_DATA_WIDTH_new,
		 G_BUFFER_ADDR_WIDTH_new);

      init_uart_class(uart_checker_nif);
 

   endfunction // new




   function void init_tb_modules();
	 tb_uart_class_inst.INIT_UART_CHECKER();       
   endfunction // init_tb_modules

   
   function void init_uart_class( virtual uart_checker_intf uart_checker_nif);
      
      tb_uart_class_inst = new(G_NB_UART_CHECKER,
				    G_DATA_WIDTH,
				    G_BUFFER_ADDR_WIDTH,uart_checker_nif);
        
            
 
   endfunction // init_uart_class
   
endclass // tb_modules_custom_uart
