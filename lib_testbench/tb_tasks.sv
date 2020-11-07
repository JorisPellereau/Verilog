//                              -*- Mode: Verilog -*-
// Filename        : tb_tasks.sv
// Description     : TestBench TASKS
// Author          : JorisP
// Created On      : Sat Nov  7 11:46:18 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov  7 11:46:18 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

//module tb_tasks;

class tb_class;
   

   /* SEQUENCER Task
    * Read The Scenario File
    * Send Args to the Decoder
   */
   task tb_sequencer;

      // PHYSICAL INPUTS
      input string scn_file_path;
      input i_wait_done;
      input i_wait_duration_done;

      output  o_sel_wait;
      output  o_sel_set;
      output  o_sel_check;
      output  o_sel_wait_duration;
      
     

      // LOCAL VARIABLES ?
      int 	   scn_file;      
      string 	   line;
      string 	   args[5];
      

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

	 // Send line to Command Decoder
	 else begin
	    cmd_decoder(line, i_wait_done, i_wait_duration_done, o_sel_set, o_sel_wait, o_sel_check, o_sel_wait_duration, args);	    
	 end

	 if(args[0] == "END_TEST") begin
	    $display("End of test");	    
	    $finish;
	    
	 end
	 
	 
	 
      end      
                  
   endtask // tb_sequencer


   /* COMMAND DECODER TASK
    * Search
    * 
    */
   task cmd_decoder(
      input string  line,
      input 	    i_wait_done,
      input 	    i_wait_duration_done,
      
      output 	    o_sel_set,
      output        o_sel_wait,
      output 	    o_sel_check,
      output 	    o_sel_wait_duration,
      output string args [5]);
      
      begin
	 
	 
      
	 $display("line : %s", line);
	 
      $sscanf(line, "%s %s %s %s %s", args[0], args[1], args[2], args[3], args[4]);
      $display("Args : %s %s %s %s %s", args[0], args[1], args[2], args[3], args[4]);
	 
      if(args[0] == "SET") begin
	 o_sel_set = 1'b1;	 
      end
      else if(args[0] ==  "WTR") begin
	 o_sel_wait = 1'b1;

	 // WAIT ACK For Blocking Commands
	 while(i_wait_done != 1'b1) begin
	    
	 end
	 
      end
      else if(args[0] == "WTF") begin
	 o_sel_wait = 1'b1;
	 // WAIT ACK For Blocking Commands
	 while(i_wait_done != 1'b1) begin
	    
	 end
      end
      else if(args[0] == "CHK") begin
	 o_sel_check = 1'b1;	 
      end
      else if(args[0] == "WAIT") begin
	 o_sel_wait_duration = 1'b1;
	 $display("Wait command detected");
	 
         // WAIT ACK For Blocking Commands
	 while(i_wait_duration_done != 1'b1) begin
	    $display("While Wait");
	    
	 end	 
      end
      else if(args[0] == "END_TEST") begin
	 
      end      
      else begin
	$display("Error: Command not recognized");
	 
	o_sel_set = 1'b0;
        o_sel_wait = 1'b0;
	o_sel_wait = 1'b0;	 
        o_sel_check = 1'b0;
        o_sel_wait_duration = 1'b0;	 
      end

      
      end
      
   
   endtask // cmd_decoder
   
 endclass
  

//endmodule // tb_tasks
