//                              -*- Mode: Verilog -*-
// Filename        : decoder.sv
// Description     : Decoder
// Author          : JorisP
// Created On      : Tue Oct 13 23:05:07 2020
// Last Modified By: JorisP
// Last Modified On: Tue Oct 13 23:05:07 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ps/1ps

module decoder
  #(
    parameter ARGS_NB = 5
  )
  (
   input 	clk,
   input 	rst_n,

   input string i_args[ARGS_NB],
   input 	i_args_valid,

   // SET I/F

   output o_sel_set,
   // WAIT I/F

   output o_sel_wait,
   // CHECK I/F

   output o_sel_check,
   
   output 	o_ack
   );
   

   // INTERNAL SIGNALS
   wire 	s_sel_set;


   assign s_sel_set   = (i_args[0] == "SET" ? 1'b1 : 1'b0);
   assign s_sel_wait  = (i_args[0] == "WTR" ? 1'b1 : i_args[0] == "WTF" ? 1'b1 : 1'b0);
   assign s_sel_check = (i_args[0] == "CHK" ? 1'b1 : 1'b0);
   
   assign o_ack = (i_args[0] == "WTR" ? 1'b0 : 1'b1);

   // Outputs affectation
   assign o_sel_set = s_sel_set;
   
   
endmodule // decoder
