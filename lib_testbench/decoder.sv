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
   output 	o_sel_set,
   
   // WAIT I/F
   input 	i_wait_done, 
   output 	o_sel_wait,
   
   // CHECK I/F
   output 	o_sel_check,

   // WAIT DURATION I/F
   input 	i_wait_duration_done,
   output       o_sel_wait_duration,
   
   output reg 	o_ack
   );
   

   // INTERNAL SIGNALS
   wire 	s_sel_set;

/* -----\/----- EXCLUDED -----\/-----
   // ACK Management
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_ack <= 1'b1;	 
      end
      else begin

	 // ADD selection
	 if(i_args[0] == "WTR" || i_args[0] == "WTF") begin

	   if(i_wait_done == 1'b1) begin
	      o_ack <= 1'b1;
	   end 
	    o_ack <= 1'b0;
	 end
         else begin
          o_ack <= 1'b1;
	 end	 
      end      
   end
 -----/\----- EXCLUDED -----/\----- */
   

   assign s_sel_set           = (i_args[0] == "SET"  ? 1'b1 : 1'b0);
   assign s_sel_wait          = (i_args[0] == "WTR"  ? 1'b1 : i_args[0] == "WTF" ? 1'b1 : 1'b0);
   assign s_sel_check         = (i_args[0] == "CHK"  ? 1'b1 : 1'b0);
   assign s_sel_wait_duration = (i_args[0] == "WAIT" ? 1'b1 : 1'b0);
   
   
   assign o_ack = (i_args[0] == "WTR" ? (i_wait_done == 1'b1 ? 1'b1 : 1'b0) :  
                    (i_args[0] == "WTF" ? (i_wait_done == 1'b1 ? 1'b1 : 1'b0) : 
                      (i_args[0] == "WAIT" ? (i_wait_duration_done == 1'b1 ? 1'b1 : 1'b0) : 1'b1)));

   // Outputs affectation
   assign o_sel_set           = s_sel_set;
   assign o_sel_wait          = s_sel_wait;
   assign o_sel_check         = s_sel_check;
   assign o_sel_wait_duration = s_sel_wait_duration;
   
   
   
endmodule // decoder
