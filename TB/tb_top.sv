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
   
   wire 	s_ack;
   wire 	s_sel_set;
   
   
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
       .ack         (s_ack),
       .args        (s_args),
       .args_valid  (s_args_valid)
   );


   // DECODER INST
   decoder i_decoder (
       .clk         (clk),
       .rst_n       (rst_n),
       .i_args        (s_args),
       .i_args_valid  (s_args_valid),
       .o_sel_set (s_sel_set),
       .o_sel_wait (),
       .o_sel_check (),
       .o_ack (s_ack)
		      
   );

   string 	s_set_alias [5];

   wire [31:0] 	s_set [5];
   
   assign s_set_alias[0] = "I0";
   assign s_set_alias[1] = "I1";
   assign s_set_alias[2] = "I2";
   assign s_set_alias[3] = "I3";
   assign s_set_alias[4] = "I4";
   

   // SET INJECTOR INST

   set_injector 
   #(
    .SET_SIZE (5),
    .SET_WIDTH(32)
    )
   i_set_injector
   (
       .clk         (clk),
       .rst_n       (rst_n),
   
       .i_set_alias  (s_set_alias),
       .i_set_sel    (s_sel_set),
    
       .i_args_valid  (s_args_valid),
       .i_args        (s_args),

       .o_set (s_set)

    );
 
endmodule // tb_top
