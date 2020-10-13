//                              -*- Mode: Verilog -*-
// Filename        : tb_top.sv
// Description     : Testbench TOP
// Author          : JorisP
// Created On      : Mon Oct 12 21:51:03 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 21:51:03 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps


// TB TOP
module tb_top;
   

   // INTERNAL SIGNALS
   wire clk;
   wire ack;
   wire rst_n;
   
  string s_args [5];
   
   wire	  s_args_valid;
   
   reg 	s_ack;
   
   
   ///assign ack = s_ack;
   
   // CLK GEN INST
   clk_gen #(
	.G_CLK_HALF_PERIOD (10)
   )
   i_clk_gen (
	      .clk_tb (clk),
              .rst_n (rst_n)	      
   );

   
   

   // SEQUENCER INST
   sequencer i_sequencer(
       .clk         (clk),
       .rst_n       (rst_n),
       .ack         (1'b0),
       .args        (s_args),
       .args_valid  (s_args_valid)
   );


   // DECODER INST
   decoder i_decoder (
       .clk         (clk),
       .rst_n       (rst_n),
       .i_args      (s_args),
       .i_args_valid (s_args_valid),
       .o_sel_set (),
       .o_sel_wait (),
       .o_sel_check (),
       .o_ack ()
		      
   );
   

   initial begin

      s_ack = 1'b0;
      //ack = 1'b0;
      
     
  end



 
endmodule // tb_top
