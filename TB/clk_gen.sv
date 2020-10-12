//                              -*- Mode: Verilog -*-
// Filename        : clk_gen.sv
// Description     : Clock generator
// Author          : JorisP
// Created On      : Mon Oct 12 22:11:26 2020
// Last Modified By: JorisP
// Last Modified On: Mon Oct 12 22:11:26 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ns

module clk_gen
   #(
    parameter int G_CLK_HALF_PERIOD = 10
   )
   (
    output reg clk_tb
   );

   
   initial begin
    clk_tb = 1'b0;
   end
   
   //always #G_CLK_HALF_PERIOD clk_tb = ~ clk_tb;      

   
   
endmodule // clk_gen
