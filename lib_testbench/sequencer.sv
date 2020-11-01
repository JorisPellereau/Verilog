//                              -*- Mode: Verilog -*-
// Filename        : sequencer.sv
// Description     : sequencer.sv
// Author          : 
// Created On      : Sun Oct 11 23:04:47 2020
// Last Modified By: 
// Last Modified On: Sun Oct 11 23:04:47 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ps/1ps

module sequencer
  
   #(
     parameter ARGS_NB = 5,
     parameter SCN_FILE_PATH = "test.txt"
   )
   (
    input 	  clk,
    input 	  rst_n,    
    input 	  ack,
    
    output string args [ARGS_NB],
    output reg	  args_valid
    
   );


   // INTERNAL SIGNALS

   reg 	   wait_ack;
   reg 	   file_open;
   reg 	   end_test;
   reg 	   s_ack;
   
    
   string line;

   int scn_file;
   int i;
   

   // Latch Inputs 
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_ack <= 1'b0;	 
      end
      else begin
	 s_ack <= ack;	 
      end      
   end
   
  integer code ;
   integer error_code;
   


   always @(posedge clk) begin
 
      if (!rst_n) begin

	 wait_ack   <= 1'b0;
	 file_open  <= 1'b0;
	 args_valid <= 1'b0;
	 end_test   <= 1'b0;
	 scn_file <= 0;
	 
      end
      else begin
	 
   
       // Open File once
	 if(file_open == 1'b0) begin
	    $display("Beginning of sequencer");
	    scn_file = $fopen(SCN_FILE_PATH, "r");
	    file_open <= 1'b1;	
	 end


	 // WAIT ACK MNGT
	 if(ack == 1'b1) begin // && s_ack == 1'b0) begin
	    wait_ack <= 1'b0;	    
	 end
	 

	 if(end_test == 1'b1) begin
            $fclose(scn_file);
            $display("End of sequencer");
      	    $finish;
	 end
	 //else if(wait_ack == 1'b0) begin
	 else if(ack == 1'b1) begin
	    code = $fgets(line, scn_file); // GET ENTIRE LINE
	    //$display("code : %d", code);

	    //error_code = $ferror(scn_file, line);
	    
	    
	    // RAZ ARGS
	    for (i = 0; i < ARGS_NB; i++) begin
               args[i] = "";	   
	    end

	    
	    $sscanf(line, "%s %s %s %s %s)", args[0], args[1], args[2], args[3], args[4]);
	    //$display("line : %s", line);
	    args_valid <= 1'b1;
	    
	    // DISPLAY ARGS
	    /*for (i = 0; i < ARGS_NB; i++) begin
               $display("argi : %s", args[i]);	   
	    end*/

	    wait_ack <= 1'b1;

	    // Test of End of test
	    if(args[0] == "END_TEST") begin
	       end_test <= 1'b1;	   
            end
	    
	 end
	 else begin
	    args_valid <= 1'b0;	
	 end
	 
	 
      end // else: !if(!rst_n)
      

 
   end // always @ (posedge clk)

   

  
endmodule // sequencer

