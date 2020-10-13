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

   (
    input 	  clk,
    input 	  rst_n,    
    input 	  ack,
    
    output string args [5],
    output reg	  args_valid
    
   );


   // INTERNAL SIGNALS

   reg 	   wait_ack;
   reg 	   file_open;
   reg 	   end_test;
   reg 	   s_ack;
   
    
   string line;

   int file;
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
   
  


   always @(posedge clk) begin

      if (!rst_n) begin

	 wait_ack <= 1'b0;
	 file_open <= 1'b0;
	 args_valid <= 1'b0;
	 end_test <= 1'b0;
	 
      end
      else begin
	 
   
       // Open File once
	 if(file_open == 1'b0) begin
	    $display("Beginning of sequencer");
	    file = $fopen("/home/jorisp/GitHub/Verilog/test.txt", "r");
	    file_open <= 1'b1;	
	 end


	 // WAIT ACK MNGT
	 if(ack == 1'b1 && s_ack == 1'b0) begin
	    wait_ack <= 1'b0;	    
	 end
	 

	 if(end_test == 1'b1) begin
	    $finish;
            $fclose(file);
            $display("End of sequencer");	
	 end
	 else if(wait_ack == 1'b0) begin
	    $fgets(line, file); // GET ENTIRE LINE
	    
	    // RAZ ARGS
	    for (i = 0; i < 5; i++) begin
               args[i] = "";	   
	    end

	    $sscanf(line, "%s %s %s %s %s)", args[0], args[1], args[2], args[3], args[4]);
	    $display("line : %s", line);
	    args_valid <= 1'b1;
	    
	    // DISPLAY ARGS
	    for (i = 0; i < 5; i++) begin
               $display("argi : %s", args[i]);	   
	    end

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

