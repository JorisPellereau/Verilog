//                              -*- Mode: Verilog -*-
// Filename        : pwm.v
// Description     : test of pwm in verilog
// Author          : 
// Created On      : Mon May  6 11:43:45 2019
// Last Modified By: 
// Last Modified On: Mon May  6 11:43:45 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!


module pwm (
	    reset_n,  // 
	    clock,
	    start,
	    en,
	    duty_cycle,
	    pwm_o);

   //  Inputs
   input reset_n;
   input clock;
   input start;
   input en;
   input [7:0] duty_cycle;
   
   
   // Outputs
   output      pwm_o;

   // Wires
   reg 	       start_s;
   wire        start_re;
   

   // Regs
   reg [7:0]   counter;

   // Output affectation
   assign pwm_o = (counter <= duty_cycle) ? 1 : 0;
   

   /* -----\/----- EXCLUDED -----\/-----
    always @(posedge clock)
    begin
    if(!reset_n) 
    start_s <= 0;	 
    else 
    start_s <= start;
     end
    -----/\----- EXCLUDED -----/\----- */
   

   // This process countes
   always @(posedge clock) begin
      if (!reset_n)
	counter <= 8'b0;
      else if(en)
        counter <= counter + 1;
   end
   
   
endmodule // pwm



