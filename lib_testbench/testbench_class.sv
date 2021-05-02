//                              -*- Mode: Verilog -*-
// Filename        : testbench_class.sv
// Description     : Testbench class
// Author          : JorisP
// Created On      : Sat May  1 20:40:14 2021
// Last Modified By: JorisP
// Last Modified On: Sat May  1 20:40:14 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "tb_tasks.sv"

class testbench_class;

   // == STATIC Functions ==

   static function void tb_classic (int ARGS_NB   = 5,
		 
				    // SET INJECTOR PARAMETERS
				    int     SET_SIZE = 5,
				    int     SET_WIDTH = 32,
				    
				    // WAIT EVENT INTS
				    int     WAIT_SIZE = 5,
				    int     WAIT_WIDTH = 1,
				    int     CLK_PERIOD = 1000, // Unity : ps
		 
				    // CHECK LEVEL INT
				    int     CHECK_SIZE = 5,
				    int     CHECK_WIDTH = 32,

				    int     WAIT_ALIAS_NB = 5,
				    int     TB_CLK_PERIOD = 20000000,
				    
	     			    virtual wait_event_intf /*#(WAIT_SIZE, WAIT_WIDTH)*/ wait_event_vif,
				    virtual set_injector_intf /*#(SET_SIZE, SET_WIDTH)*/ set_injector_vif,
				    virtual wait_duration_intf wait_duration_vif,
				    virtual check_level_intf /*#(CHECK_SIZE, CHECK_WIDTH)*/ check_level_vif
				    );
      
      
      
      tb_class #( ARGS_NB, 
                  SET_SIZE, 
                  SET_WIDTH,
                  WAIT_ALIAS_NB,
                  WAIT_WIDTH, 
                  TB_CLK_PERIOD,
                  CHECK_SIZE,
                  CHECK_WIDTH) tb_class_inst = new (wait_event_vif, 
						    set_injector_vif, 
						    wait_duration_vif,
						    check_level_vif
						    );
      
   endfunction // tb_classic
   
   // ======================
endclass // testbench_class
