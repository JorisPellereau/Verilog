//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ns

// MODULE to instantiate
/* -----\/----- EXCLUDED -----\/-----
module sequencer
   (
    input clk	 
   );
endmodule // sequencer


module clk_gen
   #(
    parameter int G_CLK_HALF_PERIOD = 10
   )
   (
    output clk_tb
   );
endmodule // clk_gen
 -----/\----- EXCLUDED -----/\----- */

// TB TOP
module tb_top;
   

   // INTERNAL SIGNALS
   wire clk;
   wire ack;

   reg 	s_ack;
   
   
   ///assign ack = s_ack;
   
   // CLK GEN INST
   clk_gen #(
	.G_CLK_HALF_PERIOD (10)
   )
   i_clk_gen (
	      .clk_tb (clk)	      
   );

   
   

   // SEQUENCER INST
   sequencer i_sequencer(
       .clk (clk),
       .ack (1'b0)
   );



   initial begin

      s_ack = 1'b0;
      //ack = 1'b0;
      
     
  end



 
endmodule // tb_top
