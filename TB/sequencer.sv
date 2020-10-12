//                              -*- Mode: Verilog -*-
// Filename        : sequencer.sv
// Description     : sequencer.sv
// Author          : 
// Created On      : Sun Oct 11 23:04:47 2020
// Last Modified By: 
// Last Modified On: Sun Oct 11 23:04:47 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!



module sequencer

  initial begin

     file = $fopen("test.txt", "r");
     while(!$feof(file)) begin
	$fgets(line, file);
	$display("Line : %s", line);	
     end
     
     $fclose(file);
     
  end
   

  
endmodule // sequencer

