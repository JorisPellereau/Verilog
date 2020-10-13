//                              -*- Mode: Verilog -*-
// Filename        : clk_gen.sv
// Description     : Clock generator
// Author          : JorisP
// Created On      : Mon Oct 12 22:11:26 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 22:11:26 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module clk_gen
   #(
    parameter int G_CLK_HALF_PERIOD = 10
   )
   (
    output reg clk_tb,
    output reg rst_n
   );

   // Clock generation
   initial begin
     clk_tb <= 1'b0;
     forever begin
        //#G_CLK_HALF_PERIOD;
	#500000;	
        clk_tb <= ~ clk_tb;
     end      
   end

   initial begin
      rst_n <= 1'b1;
      #1000000;
      rst_n <= 1'b0;
      #1000000;
      rst_n <= 1'b1;
   end
   
   
/* -----\/----- EXCLUDED -----\/-----
   forever begin
      #G_CLK_HALF_PERIOD;
      clk_tb = ~ clk_tb;
   end
 -----/\----- EXCLUDED -----/\----- */
   

   
   
endmodule // clk_gen
