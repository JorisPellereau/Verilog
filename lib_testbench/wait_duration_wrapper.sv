//                              -*- Mode: Verilog -*-
// Filename        : wait_duration_wrapper.sv
// Description     : WAIT DURATION TB MODULE WRAPPER
// Author          : JorisP
// Created On      : Sat Nov 21 15:33:42 2020
// Last Modified By: JorisP
// Last Modified On: Sat Nov 21 15:33:42 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!


interface wait_duration_intf #(
      parameter WAIT_CLK_PERIOD = 1000			       
   );
   
   logic clk;
        
endinterface // wait_duration_intf

module wait_duration_wrapper
endmodule // wait_duration_wrapper


