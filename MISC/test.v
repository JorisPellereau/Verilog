//                              -*- Mode: Verilog -*-
// Filename        : test.v
// Description     : test of verilog file
// Author          : 
// Created On      : Tue May  7 10:55:48 2019
// Last Modified By: 
// Last Modified On: Tue May  7 10:55:48 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!


`timescale 1ns/1ns // step 1ns resolution 1 ns


// Module de test
module test;

   // Inputs of the module to test
   reg reset_n;
   reg clock;
   reg start;
   reg en;
   reg [7:0] duty_cycle;

   // Output of the module
   wire      pwm_o;
   
   
   // Instance
   pwm pwm_inst(
		reset_n,
		clock,
		start,
		en,
		duty_cycle,
		pwm_o);
   

   initial
     begin

	$display("Simulation of the PWM");
	reset_n <= 1;
	clock <= 0;	
	start <= 0;
	en <= 0;
	duty_cycle <= 200;

	#5 reset_n <= 0;
	#5 reset_n <= 1;

	en <= 1;

	#500;
	
	
     end // initial begin


   // Clock generation
   always
     #10 clock = !clock;
   
   
endmodule // test
