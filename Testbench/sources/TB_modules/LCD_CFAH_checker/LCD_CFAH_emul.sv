//                              -*- Mode: Verilog -*-
// Filename        : LCD_CFAH_emul.sv
// Description     : LCD FAH Emulator-Checker
// Author          : Linux-JP
// Created On      : Sat Nov 19 22:29:42 2022
// Last Modified By: Linux-JP
// Last Modified On: Sat Nov 19 22:29:42 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module LCD_CFAH_emul (
		      input 	       clk,
		      input 	       rst_n,

		      // Physical Interface
		      input 	       i_rs,
		      input 	       i_rw,
		      input 	       i_en,
		      inout [7:0]      io_data,

		      // Check Interface
		      input [7:0]      i_wdata, // Wdata for read operation
		      output reg [7:0] o_rdata, // Data received
		      output reg       o_rdata_val
		      );


   // Internal signals
   logic   s_en;
   wire    s_en_f_edge;

   // Pipe signal on clk
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_en <= 0;	 
      end
      else begin
	 s_en <= i_en;	 
      end
   end

   // Falling edge detection
   assign s_en_f_edge = ! s_en && i_en;
      
   // Read data during Write operation
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_rdata <= 0;
	 o_rdata_val <= 0;
	 
      end
      else begin
	 if(s_en_f_edge == 1) begin
	    o_rdata <= io_data;
	    o_rdata_val <= 1;	    
	 end
	 else begin
	    o_rdata_val <= 0;	    
	 end
      end
   end // always @ (posedge clk)

   // Write data during Read operation
   assign io_data = (i_rw) ? i_wdata : 8'bz;

   // == TIMING CHECKER ==
   time time_rs;
   time time_en_r_edge;
   time time_en_r_edge_p; // Last Timing
   time time_en_f_edge;
   
   always @(posedge i_rs or negedge i_rs) begin
      time_rs = $time;      
   end

   // tAS check and tcycE check
   always @(posedge i_en) begin

      if(!rst_n) begin
 	 time_en_r_edge_p <= 0;	 
      end
      else begin
	 time_en_r_edge = $time;
	 if((time_en_r_edge - time_rs) < 40) begin
	    $display("Error: tAS timing < 40 : %t" %(time_en_r_edge - time_rs));	 
	 end

	 // Check when second r edge and next are detected
	 if(time_en_r_edge_p != 0) begin
	    if( (time_en_r_edge_p - time_en_r_edge) < 500)   begin
	       $display("Error: tAS timing < 500 : %t" %(time_en_r_edge_p - time_en_r_edge));	       
	    end
	 end
	 time_en_r_edge_p = time_en_r_edge; // update
	 
      end
   end

   // PWEH Check
   always @(negedge i_en) begin
      time_en_f_edge = $time;
      if((time_en_f_edge - time_en_r_edge) < 230) begin
	 $display("Error: tPWEH timing < 230 : %t" %(time_en_f_edge - time_en_r_edge));	 
      end
   end

   // tAH check
   always @(negedge i_en) begin

      @(posedge i_rs or negedge i_rs);
      if(($time - time_en_f_edge) < 10) begin
	 $display("Error: tAH timing < 10 : %t" %($time - time_en_f_edge));	 
      end      
   end

   // 
   // ====================
   
   
endmodule // LCD_CFAH_emul
