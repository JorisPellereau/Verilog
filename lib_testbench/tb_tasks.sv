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
   

   /* SEQUENCER Task
    * Read The Scenario File
    * Send Args to the Decoder
   */
   task tb_sequencer;

      // PHYSICAL INPUTS
      input string scn_file_path;
      input i_wait_done;
      input i_wait_duration_done;
     

      // SET INJECTOR I/F
      input string i_set_alias [SET_SIZE];      
      output logic [SET_WIDTH - 1 : 0] o_set       [SET_SIZE];
      
      
     

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
		  end

		  "WTF": begin
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
     input string 	        i_wait_alias [WAIT_SIZE],
     input [WAIT_WIDTH - 1 : 0] i_wait [WAIT_SIZE],
     output reg		        o_wait_done
   );
      begin
	 
   endtask // wait_event
   
      
   
   
 endclass
  
