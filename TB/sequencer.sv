//                              -*- Mode: Verilog -*-
// Filename        : sequencer.sv
// Description     : sequencer.sv
// Author          : 
// Created On      : Sun Oct 11 23:04:47 2020
// Last Modified By: 
// Last Modified On: Sun Oct 11 23:04:47 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ns/1ns

module sequencer

   (
    input 	  clk,
    input 	  ack,
    
    output string args [5],
    output args_valid
    
   );
   
   string line;
   string arg1;
   string arg2;
   string arg3;
   string arg4;
   string arg5;
   
   int file;
   int i;
   

  initial begin


 
   
   //forever begin
      
     $display("Beginning of sequencer");
     file = $fopen("/home/jorisp/GitHub/Verilog/test.txt", "r");

     while(args[0] != "END_TEST") begin
        $fgets(line, file); // GET ENTIRE LINE
	
//	$fscanf(file,"%s", line);
	
	// RAZ ARGS
	for (i = 0; i < 5; i++) begin
          args[i] = "";	   
	end
	
	$sscanf(line, "%s %s %s %s %s)", args[0], args[1], args[2], args[3], args[4]);
	$display("line : %s", line);
	
	//$fgets(line, file);

        for (i = 0; i < 5; i++) begin
          $display("argi : %s", args[i]);	   
	end
	
	//while(ack != 1'b0) begin
	   
	//end

	//#5;

	// RAZ ARGS
/* -----\/----- EXCLUDED -----\/-----
	for (i = 0; i < 5; i++) begin
          args[i] = "";	   
	end
 -----/\----- EXCLUDED -----/\----- */
	
	
     //end
     end

     
     $fclose(file);

     $display("End of sequencer");
     
     
  end
   

  
endmodule // sequencer

