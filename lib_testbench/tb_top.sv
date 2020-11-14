//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

`include "testbench_setup.sv"
//`include "wait_event_intf.sv"
//`include "tb_tasks.sv"


// TB TOP
module tb_top;

   // == TB CLASS == TO BE INCLUDED IN A SEPARATE FILE
   class tb_class #(
        parameter ARGS_NB   = 5,

	// SET INJECTOR PARAMETERS
        parameter SET_SIZE  = 5,
        parameter SET_WIDTH = 32,

	// WAIT EVENT PARAMETERS
	parameter WAIT_SIZE  = 5,
        parameter WAIT_WIDTH = 1,
        parameter CLK_PERIOD = 1000 // Unity : ps
      );


   // == VIRTUAL I/F ==
   virtual wait_event_intf vif;   
   // =================

   // Interface passed in Virtual I/F
   function new(virtual wait_event_intf nif);
      this.vif = nif;   
   endfunction // new
   
   
   // == TASKS ==   

   /* SEQUENCER Task
    * Read The Scenario File
    * Send Args to the Decoder
   */
   task tb_sequencer;

      // PHYSICAL INPUTS
      input string scn_file_path;
      input i_wait_duration_done;
     

      // SET INJECTOR I/F
      input string i_set_alias [SET_SIZE];      
      output logic [SET_WIDTH - 1 : 0] o_set       [SET_SIZE];
      
      // WAIT EVENT I/F
      input string 		       i_wait_alias [WAIT_SIZE];      
      input int/*bit*/		       i_wait_done;      
      output bit        	       o_sel_wtr_wtf;      
      output int 		       o_wait_en;    
      output reg [31:0] 	       o_max_timeout;

        			 

      // LOCAL VARIABLES
      int 	   scn_file;      
      string 	   line;
      logic 	   cmd_exists;      
      string 	   args[ARGS_NB];
      

      // OPEN File
      $display("Beginning of sequencer");
      scn_file = $fopen(scn_file_path, "r");

      
      // Ifinite Loop
      while(1) begin

	 // READ SCENARIO LINE
	 $fgets(line, scn_file);

	 // Filter Commentary
	 if( {line.getc(0), line.getc(1)} == "//" || {line.getc(0), line.getc(1)} == "--") begin
	   // Ignore Line   
	 end

	 // End of Test detected
	 else if( {line.getc(0), line.getc(1), line.getc(2), line.getc(3), line.getc(4), line.getc(5), line.getc(6), line.getc(7)} == "END_TEST") begin
	   $display("End of test");
           $fclose(scn_file);
	    
	   $finish;
	 end
	 
	 // Send line to Command Decoder
	 else begin
	    cmd_decoder(line, cmd_exists, args);

            if(cmd_exists) begin

	       case(args[0])
        
		  "SET": begin
		     set_injector(i_set_alias, args, o_set);		     
		  end

		  "WTR": begin
		     wait_event(vif, i_wait_alias, args, i_wait_done, o_sel_wtr_wtf, o_wait_en, o_max_timeout);		     
		  end

		  "WTF": begin
		     wait_event(vif, i_wait_alias, args, i_wait_done, o_sel_wtr_wtf, o_wait_en, o_max_timeout);
		  end		 
		  
		  default: $display("");
		 
	       endcase // case (args[0])	       	       
            end	    
	 end // else: !if( {line.getc(0), line.getc(1), line.getc(2), line.getc(3), line.getc(4), line.getc(5), line.getc(6), line.getc(7)} == "END_TEST")

	 
	 	 
      end // while (1)
      
                       
   endtask // tb_sequencer


   /* COMMAND DECODER TASK
    * Extracts Args and Check if commands exists
    * 
    */
   task cmd_decoder(
      input string  line,
      output logic  o_cmd_exists,		    
      output string args [ARGS_NB]);
      
      begin
	 	       
        $display("line : %s", line);
	 
        $sscanf(line, "%s %s %s %s %s", args[0], args[1], args[2], args[3], args[4]);
        $display("Args : %s %s %s %s %s", args[0], args[1], args[2], args[3], args[4]);
	 
        if(args[0] == "SET") begin
     	  o_cmd_exists = 1'b1;	 
        end
        else if(args[0] ==  "WTR") begin
	  o_cmd_exists = 1'b1;	 
        end
        else if(args[0] == "WTF") begin
          o_cmd_exists = 1'b1;
        end
        else if(args[0] == "CHK") begin
	  o_cmd_exists = 1'b1; 
        end
        else if(args[0] == "WAIT") begin
	  o_cmd_exists = 1'b1; 
        end    
        else begin
	  $display("Error: Command %s not recognized", args[0]);
          o_cmd_exists = 1'b0;	 
        end
      end
              
   endtask // cmd_decoder



   /* SET INJECTOR TASK
    * Read Args From Decoder task and set output as combinational
    * 
    */
   task set_injector(
     input string                        i_set_alias [SET_SIZE],		     
     input string                        i_args      [ARGS_NB],
     output logic    [SET_WIDTH - 1 : 0] o_set       [SET_SIZE]
   );
      begin

	 // LOCAL VARIABLES
	 int 	 s_alias_array [string];
         int     s_str_len;
	 string  s_str;

	 // INIT ALIAS
	 for (int i = 0; i < SET_SIZE; i++) begin
	   s_alias_array[i_set_alias[i]] = i;
         end
	 
	 // Case : 0x at the beginning of the Args
	 if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
           s_str_len = i_args[2].len();                    // Find Length		  
           s_str     = i_args[2].substr(2, s_str_len - 1); // Remove 0x	
	    // 	  		  
	   o_set[s_alias_array[i_args[1]]] = s_str.atohex(); // Set Correct Hex value
	 end
	 // Decimal args
	 else begin
           o_set[s_alias_array[i_args[1]]] = i_args[2].atoi();		  
	 end

      end            
      	 
   endtask // set_injector


   /* TASK WAIT EVENT
    *
    * 
    */
   task wait_event (

     virtual wait_event_intf vif,		    
     input string      i_wait_alias [WAIT_SIZE],
     input string      i_args [ARGS_NB],
     input int 	       i_wait_done,
		    
		    
     output bit        o_sel_wtr_wtf,
     output int        o_wait_en,
		    
		    
     output reg [31:0] o_max_timeout
   );
      begin

	 string 		      s_unit; // ps - ns - us - ms
	 int s_timeout_value;
	 int s_max_timeout_cnt;
         int s_alias_array [string];
	 
	 // INIT ALIAS ARRAY
	 for (int i = 0; i < WAIT_SIZE; i++) begin
	   s_alias_array[i_wait_alias[i]] = i;
         end

	 // Command Decod
	 if(i_args[0] == "WTR") begin
           o_sel_wtr_wtf = 1'b0;
	    #1;
	    
	    $display("WTR selected");
		  
	 end
	 else if(i_args[0] == "WTF") begin
	   o_sel_wtr_wtf = 1'b1;
	    $display("WTF selected");
	    
         end	       
         else begin
           $display("Error: Not A Wait Command");		  
	 end


	 // Timeout Decod
	 if(i_args[2] != "" && i_args[3] != "") begin		  		  
	   s_timeout_value = i_args[2].atoi(); // STR to INT
	   if(i_args[3] == "ps" || i_args[3] == "ns" || i_args[3] == "us" || i_args[3] == "ms") begin
 	     s_unit = i_args[3];

             case (s_unit) 
             "ps": begin
               s_max_timeout_cnt = s_timeout_value / CLK_PERIOD;
               $display("Timeout : %d %s",s_timeout_value, s_unit);
		       
             end
	   
             "ns": begin
	        s_max_timeout_cnt = (1000 * s_timeout_value) / (CLK_PERIOD);
	        $display("Timeout : %d %s",s_timeout_value, s_unit);
             end
	   
             "us": begin
               s_max_timeout_cnt = (1000000 * s_timeout_value) / (CLK_PERIOD);
               $display("Timeout : %d %s",s_timeout_value, s_unit);
             end
	   
             "ms": begin
               s_max_timeout_cnt = (1000000000 * s_timeout_value) / (CLK_PERIOD);
               $display("Timeout : %d %s",s_timeout_value, s_unit);
              end
		    
              default: begin
                $display("Error: wrong unit format");		       
              end
		    
            endcase // case (s_unit)

	    o_max_timeout = s_max_timeout_cnt;

           	     
	   end		  
           else begin
            $display("Error: Wrong timeout unity");  
           end				   
	 end
	 else begin
          $display("Wait_event : No timeout");	
	    o_max_timeout = 0;
	    
	 end
	 

	 o_wait_en = s_alias_array[i_args[1]]; // NEED TO RETUNR THE INDEX !


	 $display("Wait for WAIT EVENT ACK ... %t", $time);	 
	   while(vif.wait_done != 1 /*1'b1*/) begin	    
	      #1;
	      $display("time : %t", $time);
 
	   end
	 
      end
	 
   endtask // wait_event
   

 
   endclass // tb_class
   


   

   

   // == INTERNAL SIGNALS ==
   
   wire clk;
   wire ack;
   wire rst_n;

   
   string s_args [`C_CMD_ARGS_NB];   
   wire	  s_args_valid;
   
   wire 	s_ack;
   wire 	s_sel_set;

   // SET INJECTOR signals
   string 	                s_set_alias [`C_SET_ALIAS_NB];
   
   wire [`C_SET_WIDTH - 1:0] 	s_set [`C_SET_ALIAS_NB];

   
   logic [`C_SET_WIDTH - 1:0] 	s_set_task [`C_SET_ALIAS_NB];
   // WAIT EVENT signals
   string 	                s_wait_alias [`C_WAIT_ALIAS_NB];
   wire [`C_WAIT_WIDTH - 1:0] 	s_wait [`C_WAIT_ALIAS_NB];

   // CHECK LEVEL signals
   string 	                s_check_alias [`C_CHECK_ALIAS_NB];
   wire [`C_CHECK_WIDTH - 1:0] 	s_check [`C_CHECK_ALIAS_NB];
   // ========================
   
   
   
   // == CLK GEN INST ==
   clk_gen #(
	.G_CLK_HALF_PERIOD  (`C_TB_CLK_HALF_PERIOD),
	.G_WAIT_RST         (`C_WAIT_RST)
   )
   i_clk_gen (
	      .clk_tb (clk),
              .rst_n  (rst_n)	      
   );
   // ==================

   // == SET INJECTOR ALIAS ==
   assign s_set_alias[0] = "I0";
   assign s_set_alias[1] = "I1";
   assign s_set_alias[2] = "I2";
   assign s_set_alias[3] = "I3";
   assign s_set_alias[4] = "I4";
   // ========================

   // == WAIT EVENT ALIAS ==
   assign s_wait_alias[0] = "RST_N";
   assign s_wait_alias[1] = "O1";
   assign s_wait_alias[2] = "O2";
   assign s_wait_alias[3] = "O3";
   assign s_wait_alias[4] = "O4";
   // ========================

   // == CHECK LEVEL ALIAS ==
   assign s_check_alias[0] = "TOTO0";
   assign s_check_alias[1] = "TOTO1";
   assign s_check_alias[2] = "TOTO2";
   assign s_check_alias[3] = "TOTO3";
   assign s_check_alias[4] = "TOTO4";
   // ========================

   // == WAIT EVENT INPUTS ==
   assign s_wait[0] = rst_n;
   assign s_wait[1] = 1'b0;
   assign s_wait[2] = 1'b0;
   assign s_wait[3] = 1'b0;
   assign s_wait[4] = 1'b0;
   // =======================

   // == CHECK LEVEL INPUTS ==
   assign s_check[0] = 32'hCAFEDECA;
   assign s_check[1] = 16'h5678;
   assign s_check[2] = 8'h72;
   assign s_check[3] = 16'hzzzz;
   assign s_check[4] = 1'bz;   
   // ========================

   
 

   bit   			s_wait_done;
   wire				i_wait_duration_done;
   
   logic 			s_sel_wait;
   logic 			o_sel_check;
   logic 			o_sel_wait_duration;
   logic 			o_sel_set;
   
   string 			line;
   string 			args [`C_CMD_ARGS_NB];
   
   bit  			s_sel_wtr_wtf;
   logic [31:0] 		s_max_timeout;
   int 				s_wait_en;
   

   logic 			s_finish;


   interface test_intf(output tata);
   logic 			toto;
   
   endinterface // test_intf
   
   test_intf s_test_intf();

   assign s_test_intf.toto = 1'b1;
   

   // CREATE CLASS - Configure Parameters
   tb_class #(`C_CMD_ARGS_NB, `C_SET_SIZE, `C_SET_WIDTH, 5, 1, `C_TB_CLK_PERIOD) tb_class_inst;

   
   assign i_wait_duration_done = 1'b0;



   // == INTERFACES ==
   interface wait_event_intf #(
     parameter WAIT_SIZE  = 5,
     parameter WAIT_WIDTH = 1
   );
   
   logic wait_en;   
   logic sel_wtr_wtf;
   logic [31:0] max_timeout;
   logic [WAIT_WIDTH - 1 : 0] wait_signals [WAIT_SIZE];   
   logic 	wait_done;
   
   endinterface // wait_event_int

   // =================

   // == INTERFACES INST ==
   
   wait_event_intf #(.WAIT_SIZE(5), .WAIT_WIDTH(1)) s_wait_event_if();  // WAIT EVENT I/F


   initial begin
    //tb_class_inst = new();
      tb_class_inst  = new(s_wait_event_if);
      
      forever begin
       #1;

         tb_class_inst.tb_sequencer("/home/jorisp/GitHub/Verilog/test_tasks.txt", 
                                   i_wait_duration_done, 
                                   s_set_alias, s_set_task, s_wait_alias, 
                                   s_wait_done, s_sel_wtr_wtf, s_wait_en, 
                                   s_max_timeout);	 
      end            
   end // initial begin
   


   

   // WAIT EVENT TB WRAPPER INST
   wait_event_wrapper #(
			.ARGS_NB    (`C_CMD_ARGS_NB),
			.CLK_PERIOD (`C_TB_CLK_PERIOD)
   )
   i_wait_event_wrapper (
       .clk         (clk),
       .rst_n       (rst_n),

	.wait_event_if (s_wait_event_if)			 
   );
   
   assign    s_wait_event_if.wait_en      = s_wait_en;
   assign    s_wait_event_if.sel_wtr_wtf  = s_sel_wtr_wtf;
   assign    s_wait_event_if.max_timeout  = s_max_timeout;
   assign    s_wait_event_if.wait_signals = s_wait;

endmodule // tb_top
