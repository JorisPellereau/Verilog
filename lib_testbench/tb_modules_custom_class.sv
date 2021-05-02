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
 /*#(
				parameter G_NB_UART_CHECKER = 2,
				parameter G_DATA_WIDTH = 8,
				parameter G_BUFFER_ADDR_WIDTH = 8
				);*/

   // Testbench Infos
   logic UART_MODULES_EN;
   logic test;

   // UART parameters
   const int 	 G_NB_UART_CHECKER;
   const int 	 G_DATA_WIDTH;
   const int 	 G_BUFFER_ADDR_WIDTH;
   
   
   //uart_tb_info_struct uart_tb_info; // Info of UART Testbench Modules
   
   virtual uart_checker_intf /*#(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH)*/ uart_checker_vif;
   
   //tb_uart_class #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) tb_uart_class_inst;

   
   // Constructor of the class - Infos of Used modules
   function new (logic UART_MODULES_EN,
		 int G_NB_UART_CHECKER = 1,
		 int G_DATA_WIDTH = 8,
		 int G_BUFFER_ADDR_WIDTH = 8
//,//
		  /*tb_uart_class #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) tb_uart_class_inst*/
		  //virtual uart_checker_intf #(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH) uart_checker_nif
		  ); 
      this.UART_MODULES_EN     = UART_MODULES_EN;
      this.G_NB_UART_CHECKER = G_NB_UART_CHECKER;
      this.G_DATA_WIDTH = G_DATA_WIDTH;
      this.G_BUFFER_ADDR_WIDTH = G_BUFFER_ADDR_WIDTH;
      


      /*if(UART_MODULES_EN) begin
	 init_uart_class(tb_top.uart_checker_if);//`C_UART_CHECKER_INTERFACE);
	 this.test = 1;
	 
      end
      else begin
	  this.test = 0;
      end*/
      
	

     //if(UART_MODULES_EN) begin
	/*tb_uart_class #( .G_NB_UART_CHECKER    (G_NB_UART_CHECKER), 
			 .G_DATA_WIDTH         (G_DATA_WIDTH),
			 .G_BUFFER_ADDR_WIDTH  (G_BUFFER_ADDR_WIDTH)
			 )*/
	
	//tb_uart_class_inst = new(uart_checker_nif);
	//uart_checker_vif = uart_checker_nif;
	
	
      
	 /*return*/  //this.tb_uart_class_inst = tb_uart_class_inst;
	 
      //end // if (UART_MODULES_EN)

      //this.uart_checker_vif = uart_checker_nif;
   endfunction // new


   // Display info on Class
   function void display_info();
      /*$display("UART_MODULES_EN    : %b", this.UART_MODULES_EN);
      $display("uart_checker_vif   : %p - %s", this.uart_checker_vif, $typename(this.uart_checker_vif));
      $display("tb_uart_class_inst : %p", this.tb_uart_class_inst);
      $display("test : %b", this.test);*/
      
      
   endfunction // display_info
   

   
   static function tb_modules_custom_class create_custom_module_uart(logic UART_MODULES_EN,
								     int     G_NB_UART_CHECKER,
								     int     G_DATA_WIDTH,
								     int     G_BUFFER_ADDR_WIDTH,
								     virtual uart_checker_intf /*#(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH)*/ uart_checker_nif);

      tb_modules_custom_class tb_modules_custom_class_inst = new(UART_MODULES_EN,
								 G_NB_UART_CHECKER,
								 G_DATA_WIDTH,
								 G_BUFFER_ADDR_WIDTH);

      tb_modules_custom_class_inst.init_uart_class(uart_checker_nif);
      
      return tb_modules_custom_class_inst;      
   endfunction; // tb_uart_class
   

   
   // Init Class UART
   function void /*tb_uart_class*/ init_uart_class( virtual uart_checker_intf /*#(G_NB_UART_CHECKER, G_DATA_WIDTH, G_BUFFER_ADDR_WIDTH)*/ uart_checker_nif);
      
//					      virtual uart_checker_intf /*#(2, 8, 8)*/ uart_checker_if);
//uart_checker_intf uart_checker_if);
      tb_uart_class /*#( .G_NB_UART_CHECKER    (this.G_NB_UART_CHECKER), 
		       .G_DATA_WIDTH         (this.G_DATA_WIDTH),
		       .G_BUFFER_ADDR_WIDTH  (this.G_BUFFER_ADDR_WIDTH)
		       )*/
      
	tb_uart_class_inst = new(     G_NB_UART_CHECKER,
				      G_DATA_WIDTH,
				      G_BUFFER_ADDR_WIDTH,uart_checker_nif);
      
      uart_checker_vif = uart_checker_nif;
            
      
      /*return*/  //this.tb_uart_class_inst = tb_uart_class_inst;    
   endfunction // init_uart_class


   // Initialization of Enabled Testbench Modules
   function void init_tb_modules();
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
