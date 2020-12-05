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
        parameter CLK_PERIOD = 1000, // Unity : ps

	// CHECK LEVEL PARAMETER
	parameter CHECK_SIZE  = 5,
	parameter CHECK_WIDTH = 32
      );


   // == VIRTUAL I/F ==
   virtual wait_event_intf     wait_event_vif;
   virtual set_injector_intf #(SET_SIZE, SET_WIDTH)  set_injector_vif;
   virtual wait_duration_intf  wait_duration_vif;
   virtual check_level_intf    check_level_vif;   
   // =================

   // == Interface passed in Virtual I/F ==
   function new(virtual wait_event_intf     wait_nif, 
                virtual set_injector_intf #(SET_SIZE, SET_WIDTH)  set_nif, 
                virtual wait_duration_intf  wait_duration_nif,
                virtual check_level_intf    check_level_nif);
      
      wait_event_vif    = wait_nif;
      set_injector_vif  = set_nif;
      wait_duration_vif = wait_duration_nif;
      check_level_vif   = check_level_nif;      
   endfunction // new

   // ====================================
   
      
   
   // == TASKS ==   

   /* SEQUENCER Task
    * Read The Scenario File
    * Send Args to the Decoder
   */
   task tb_sequencer(

        input string scn_file_path // SCENARIO FILE PATH

      );
      
     begin
	
         			 

      // LOCAL VARIABLES
      int 	   scn_file;      
      string 	   line;
      logic 	   cmd_exists;      
      string 	   args[ARGS_NB];
      

      logic 	   end_test;

      
      
      end_test = 1'b0;


      // INIT SET INJECTOR
      set_injector_init(set_injector_vif);
	
      
      // OPEN File
      $display("Beginning of sequencer");
      scn_file = $fopen(scn_file_path, "r");


      
      // While END_TEST not Reach
      while(end_test == 1'b0) begin
      
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
	    end_test = 1'b1;
 
	   $finish;
	 end
	 
	 // Send line to Command Decoder
	 else begin
	    cmd_decoder(line, cmd_exists, args);

            if(cmd_exists) begin

	       case(args[0])
        
		  "SET": begin
		     set_injector(set_injector_vif, args);		     
		  end

		  "WTR": begin
		     wait_event(wait_event_vif, args);		     
		  end

		  "WTF": begin
		     wait_event(wait_event_vif, args);
		  end

                  "WAIT": begin
		     wait_duration(wait_duration_vif, args);		     
                  end

		  "CHK" : begin
		    check_level(check_level_vif, args);
		  end  
	 
		  
		  default: $display("");
		 
	       endcase // case (args[0])	       	       
            end	    
	 end // else: !if( {line.getc(0), line.getc(1), line.getc(2), line.getc(3), line.getc(4), line.getc(5), line.getc(6), line.getc(7)} == "END_TEST")

	 
	 	 
      end // while (end_test == 1'b0)
      
     end // task tb_sequencer(
      
                       
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
       
        $display("%s", line);
	 
        $sscanf(line, "%s %s %s %s %s", args[0], args[1], args[2], args[3], args[4]);
	 
        if(args[0] == "SET") begin
     	  o_cmd_exists = 1'b1;	 
        end
        else if(args[0] == "WTR") begin
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

   /* SET INJECTOR INIT TASK
    *  SET initial valueto the SET INJECTOR outputs
    * 
    * 
    */
   task set_injector_init (
      virtual set_injector_intf #(SET_SIZE, SET_WIDTH) set_injector_vif
   );
      begin
	 set_injector_vif.set_signals_asynch = set_injector_vif.set_signals_asynch_init_value; 
      end
   endtask // set_injector_init
   
		  


   /* SET INJECTOR TASK
    * Read Args From Decoder task and set output as combinational
    * 
    */
   task set_injector(
     virtual set_injector_intf #(SET_SIZE, SET_WIDTH) set_injector_vif,
     input string 		      i_args [ARGS_NB]
   );
      begin

	 // LOCAL VARIABLES
	 int 	 s_alias_array [string];
         int     s_str_len;
	 string  s_str;

	 // INIT ALIAS
	 for (int i = 0; i < SET_SIZE; i++) begin
	   s_alias_array[set_injector_vif.set_alias[i]] = i;
         end
	 
	 // Case : 0x at the beginning of the Args
	 if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
           s_str_len = i_args[2].len();                    // Find Length		  
           s_str     = i_args[2].substr(2, s_str_len - 1); // Remove 0x	

	   set_injector_vif.set_signals_asynch[s_alias_array[i_args[1]]] = s_str.atohex();	  
	 end
	 
	 // Decimal args
	 else begin
	   set_injector_vif.set_signals_asynch[s_alias_array[i_args[1]]]  = i_args[2].atoi();	  
	 end

      end
      
      $display("");      
      	 
   endtask // set_injector


   /* TASK WAIT EVENT
    *   Set configuration for WAIT EVENT TB module
    *   Wait for WAIT EVENT TB module response
    */
   task wait_event (

     virtual           wait_event_intf wait_event_vif,		    
     input string      i_args [ARGS_NB]
   );
      begin

	 string 		      s_unit; // ps - ns - us - ms
	 int s_timeout_value;
	 int s_max_timeout_cnt;
         int s_alias_array [string];
	 
	 // INIT ALIAS ARRAY
	 for (int i = 0; i < WAIT_SIZE; i++) begin
	   s_alias_array[wait_event_vif.wait_alias[i]] = i;
         end

	 // Command Decod
	 if(i_args[0] == "WTR") begin
	    wait_event_vif.sel_wtr_wtf = 1'b0;	    
	    $display("Waiting for a rising edge ...");
		  
	 end
	 else if(i_args[0] == "WTF") begin
	    wait_event_vif.sel_wtr_wtf = 1'b1;
	    $display("Waiting for a falling edge ...");
	    
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

           wait_event_vif.max_timeout = s_max_timeout_cnt;
           	     
	   end		  
           else begin
            $display("Error: Wrong timeout unity");  
           end				   
	 end
	 else begin
          $display("Wait_event : No timeout");	
	    wait_event_vif.max_timeout = 0;
	    
	 end

         wait_event_vif.wait_en = s_alias_array[i_args[1]];
	 wait_event_vif.en_wait_event = 1'b1;
	 
         @(posedge wait_event_vif.wait_done);
         wait_event_vif.en_wait_event = 1'b0;
      end

      $display("");
      
   endtask // wait_event

   
   task wait_duration (
	virtual      wait_duration_intf wait_duration_vif, 	       
        input string i_args [ARGS_NB]       	              		       
   );
      
      begin

	 string        s_unit; // ps - ns - us - ms
	 int           s_timeout_value;
	 int           s_max_timeout_cnt;
	 int 	       s_cnt;	 
	 logic 	       s_cnt_done;

	 s_cnt_done = 1'b0;
	 s_cnt      = 0;
	 

	 if(i_args[1] != "" && i_args[2] != "") begin		  		  
	   s_timeout_value = i_args[1].atoi(); // STR to INT
           if(i_args[2] == "ps" || i_args[2] == "ns" || i_args[2] == "us" || i_args[2] == "ms") begin
             s_unit = i_args[2];
		     
           end		  
           else begin
             $display("Error: Wrong timeout unity");  
           end				   
	 end
	 else begin
           $display("Wait Duration : No timeout");		  
	 end // else: !if(i_args[1] != "" && i_args[2] != "")


	 case (s_unit) 
          "ps": begin
            s_max_timeout_cnt = s_timeout_value / (CLK_PERIOD);
            $display("WAIT duration : %d %s",s_timeout_value, s_unit);		       
          end
	   
          "ns": begin
            s_max_timeout_cnt = (1000 * s_timeout_value) / (CLK_PERIOD);
            $display("WAIT duration : %d %s",s_timeout_value, s_unit);
          end
	   
          "us": begin
            s_max_timeout_cnt = (1000000 * s_timeout_value) / (CLK_PERIOD);
            $display("WAIT duration : %d %s",s_timeout_value, s_unit);
          end
	   
          "ms": begin
            s_max_timeout_cnt = (1000000000 * s_timeout_value) / (CLK_PERIOD);
            $display("WAIT duration : %d %s",s_timeout_value, s_unit);
          end
		    
          default: begin
            $display("Error: wrong unit format");		       
          end
		    
         endcase // case (s_unit)


	 // WAIT until end of counter
	 while(s_cnt_done == 1'b0) begin
	    @(posedge wait_duration_vif.clk); // WAIT FOR RISING EDRE of CLK
	    if(s_cnt < s_max_timeout_cnt) begin
	       s_cnt = s_cnt + 1;
	    end
	    else begin
	       s_cnt_done = 1'b1;	       	       
	    end	    
	 end
	 	 	 
      end

      $display("");
   endtask // wait_duration


   
   task check_level (
        virtual check_level_intf    check_level_vif,
        input string i_args [ARGS_NB]
   );
      begin

	 // ASSOCIATIVE ARRAY
         int 	 s_alias_array [string];
         reg [CHECK_WIDTH - 1 : 0]     s_check_value;
         string 		       s_str;     
         int 			       s_str_len;
	 
	 // INIT ALIAS
	 for (int i = 0; i < CHECK_SIZE; i++) begin
	   s_alias_array[check_level_vif.check_alias[i]] = i;
         end

	 // Case : 0x at the beginning of the Args
	 if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x") begin
		  
	   s_str_len     = i_args[2].len(); // Find Length		  
           s_str         = i_args[2].substr(2, s_str_len - 1); // Remove 0x
           s_check_value = s_str.atohex(); // Set Correct Hex value
	 end
	 // DECIMAL ARGS
	 else begin
           s_check_value = s_str.atoi;
		  
	 end // else: !if( {i_args[2].getc(0),  i_args[2].getc(1)} == "0x")


	 // Test if ALIAS Name Exist else Error
	 if(s_alias_array.exists(i_args[1])) begin
	 // CHECK VALUE
	 // OK Expected
	   if(i_args[3] == "OK") begin

             if(check_level_vif.check_signals[s_alias_array[i_args[1]]] == s_check_value) begin
               $display("CHECK %s = 0x%x - Expected : 0x%x => OK", i_args[1], check_level_vif.check_signals[s_alias_array[i_args[1]]], s_check_value);
		     
	     end
	     else begin
               $display("Error: %s = 0x%x - Expected : 0x%x", i_args[1], check_level_vif.check_signals[s_alias_array[i_args[1]]], s_check_value);
	     end		  
	   end
	   // ERROR Expected
	   else if(i_args[3] == "ERROR") begin
		  
             if(check_level_vif.check_signals[s_alias_array[i_args[1]]] != s_check_value) begin
               $display("CHECK %s != 0x%x  => OK", i_args[1],  s_check_value);
		     
	     end
	     else begin
               $display("Error: %s = 0x%x", i_args[1], s_check_value);
	     end
	   end
	   // Error no Expected state value
	   else begin
             $display("Error: Args[3] of CHECK command not defined");
		  
	   end // else: !if(i_args[3] == "ERROR")
	       
	 end // if (s_alias_array.exists(i_args[1]))
	 else begin
           $display("Error: %s alias doesn't exists", i_args[1]);
		  
	 end // else: !if(s_alias_array.exists(i_args[1]))
	 	 
      end

      $display("");
      
   endtask // check_level
   
      

 endclass
