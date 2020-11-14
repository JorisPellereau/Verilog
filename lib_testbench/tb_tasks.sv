//                              -*- Mode: Verilog -*-
// Filename        : tb_tasks.sv
// Description     : TestBench TASKS
// Author          : JorisP
// Created On      : Sat Nov  7 11:46:18 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov  7 11:46:18 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


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
   function new(virtual wait_event_intf vif/*nif*/);
      this.vif = vif/*nif*/;   
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


      // SEQUENCER INFO
      output 			       o_finish;
      
      


				 

      // LOCAL VARIABLES
      int 	   scn_file;      
      string 	   line;
      logic 	   cmd_exists;      
      string 	   args[ARGS_NB];
      

      // OPEN File
      $display("Beginning of sequencer");
      scn_file = $fopen(scn_file_path, "r");

      o_finish = 1'b0;
      
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
	    o_finish = 1'b1;
	    
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
		     wait_event(i_wait_alias, args, i_wait_done, o_sel_wtr_wtf, o_wait_en, o_max_timeout);		     
		  end

		  "WTF": begin
		     wait_event(i_wait_alias, args, i_wait_done, o_sel_wtr_wtf, o_wait_en, o_max_timeout);
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
     input string      i_wait_alias [WAIT_SIZE],
     input string      i_args [ARGS_NB],
     input int	       i_wait_done,
		    
		    
     output bit      o_sel_wtr_wtf,
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
	   while(i_wait_done != 1 /*1'b1*/) begin	    
	      #1;
	      $display("time : %t", $time);
 
	   end
	 
      end
	 
   endtask // wait_event
   

   task /*static*/ task_test(
		  /*input 	       i_wait_done,*/
	        virtual wait_event_intf vif,
		  output bit toto
      );
      begin

	 $display("TASK TEST");
	 #1;

	 //@(posedge vif.wait_done);
	 //$display("i_wait_done INTF = %d", i_wait_done);
	 
	 //while(vif.wait_done /*i_wait_done*/ != 1'b1) begin
	    //$display("i_wait_done = %d", i_wait_done);
	    toto = 1'b0;
	    #1;	    
	 //end
	 $display("TASK TEST : end of while");
	 
	 toto = 1'b1;
      end
      
   endtask // task_test


 
 endclass
