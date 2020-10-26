//                              -*- Mode: Verilog -*-
// Filename        : wait_event.sv
// Description     : Wait Event Testbench Module
// Author          : JorisP
// Created On      : Wed Oct 21 19:46:10 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 21 19:46:10 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module wait_event
  #(  
    parameter ARGS_NB    = 5, 
    parameter WAIT_SIZE  = 5,
    parameter WAIT_WIDTH = 1,
    parameter CLK_PERIOD = 1000 // Unity : ps   
  )
  (
   input 		      clk,
   input 		      rst_n,

   input string 	      i_wait_alias [WAIT_SIZE],
   input 		      i_sel_wait, 
   input 		      i_args_valid, 
   input string 	      i_args [ARGS_NB],

   input [WAIT_WIDTH - 1 : 0] i_wait [WAIT_SIZE],

   output 		      o_wait_done
   
   );


   // INTERNAL signals
   reg [WAIT_WIDTH - 1 : 0]   s_wait [WAIT_SIZE];

   reg 			      s_wtr_wtf_sel; // 0 : WTR - 1 : WTF
   reg 			      s_valid;
   reg 			      s_timeout_en;
   
   reg 			      s_start_timeout;
   
   
   
   string		      s_alias;
   string 		      s_unit; // ps - ns - us - ms
   

   reg [31:0] s_timeout_cnt;
   reg [31:0] s_max_timeout_cnt;
   reg [31:0] s_timeout_value;
   
   

   // DECOD Command

   always @(posedge clk) begin
      if(!rst_n) begin
	 s_wtr_wtf_sel     <= 1'b0;
	 //s_alias           <= "";
	 s_max_timeout_cnt <= 32'h00000000;
	 s_timeout_value   <= 32'h00000000;
	 s_valid <= 1'b0;
	 s_timeout_en <= 1'b0;
	 
      end
      else begin

	 if(i_sel_wait) begin
	    if(i_args_valid) begin

	       // Command Decod
	       if(i_args[0] == "WTR") begin
		  s_wtr_wtf_sel <= 1'b0;		  
	       end
	       else if(i_args[0] == "WTF") begin
		  s_wtr_wtf_sel <= 1'b1;		  
	       end	       
	       else begin
		  $display("Error: Not A Wait Command");		  
	       end

	       // Alias latch
	       s_alias <= i_args[1];
	       
               // Timeout Decod
	       if(i_args[2] != "" && i_args[3] != "") begin		  		  
	          s_timeout_value = i_args[2].atoi(); // STR to INT
		  if(i_args[3] == "ps" || i_args[3] == "ns" || i_args[3] == "us" || i_args[3] == "ms") begin
 		     s_unit = i_args[3];
		     s_timeout_en = 1'b1;
		     
		  end		  
		  else begin
		     $display("Error: Wrong timeout unity");  
		  end				   
	       end
	       else begin
		  $display("Wait_event : No timeout");		  
	       end


	       // Compute Timeout value
	       if(s_timeout_en) begin
		  case (s_unit) 
		    "ps": begin
		       s_max_timeout_cnt = s_timeout_value / CLK_PERIOD;		       
		    end
		    "ns": begin
		       s_max_timeout_cnt = s_timeout_value / (1000 * CLK_PERIOD);
		    end
		    "us": begin
		       s_max_timeout_cnt = s_timeout_value / (1000000 * CLK_PERIOD);
		    end
		    "ms": begin
		       s_max_timeout_cnt = s_timeout_value / (1000000000 * CLK_PERIOD);
		    end
		    
		    default: begin
		       $display("Error: wrong s_unit");		       
		    end
		    
		  endcase // case (s_unit)
		          
	       end
	       
	       s_valid <= 1'b1;
	       
	    end // if (i_args_valid)
	    
            else begin
              s_wtr_wtf_sel <= 1'b0; 
	      s_valid <= 1'b0; 
	     end // else: !if(i_args_valid)	    	 	 
         end // if (i_sel_wait)
	 else begin
	   s_valid <= 1'b0; 
	 end // else: !if(i_sel_wait)	 
      end      
   end
   

   // 
      
         
   
   // LATCH INPUTS
   always @(posedge clk) begin
      if(!rst_n) begin
	 for(int i = 0 ; i < WAIT_WIDTH ; i++) begin
	    for(int j = 0 ; j < WAIT_SIZE ; j++) begin
	      s_wait[j][i] <= 0;
	    end	    
	 end
	 
      end
      else begin

	 for(int j = 0 ; j < WAIT_SIZE ; j++) begin
	   s_wait[j] <= i_wait[j];
	 end	 

      end      
   end
   

   
endmodule // wait_event
