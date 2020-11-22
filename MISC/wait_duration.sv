//                              -*- Mode: Verilog -*-
// Filename        : wait_duration.sv
// Description     : Wait a defined duration
// Author          : JorisP
// Created On      : Sun Nov  1 12:43:21 2020
// Last Modified By: JorisP
// Last Modified On: Sun Nov  1 12:43:21 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

module wait_duration
  #(  
    parameter ARGS_NB    = 5, 
    parameter CLK_PERIOD = 1000 // Unity : ps   
  )
  (
   input 		      clk,
   input 		      rst_n,

   input 		      i_sel_wait_duration, 
   input 		      i_args_valid, 
   input string 	      i_args [ARGS_NB],

   output reg		      o_wait_duration_done
   
   );

   // INTERNAL SIGNALS
   string 		      s_unit; // ps - ns - us - ms
   int 			      s_timeout_value;
   int 			      s_max_timeout_cnt;
   
   reg 			      s_timeout_en;
   
   reg [31:0] s_timeout_cnt;
   reg 	      s_timeout_done;
   
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_timeout_value   <= 0;
	 s_max_timeout_cnt <= 0;
	 s_timeout_en      <= 1'b0;
      end
      else begin
	 if(i_sel_wait_duration) begin
	    
	    if(i_args_valid) begin

	       // Command Decod
	       if(i_args[0] != "WAIT") begin
		  $display("Error: Not A Wait Duration Command");		  
	       end
	       else begin

		  // Timeout Decod
	       if(i_args[1] != "" && i_args[2] != "") begin		  		  
	          s_timeout_value = i_args[1].atoi(); // STR to INT
		  if(i_args[2] == "ps" || i_args[2] == "ns" || i_args[2] == "us" || i_args[2] == "ms") begin
 		     s_unit = i_args[2];
		     s_timeout_en = 1'b1;
		     
		  end		  
		  else begin
		     $display("Error: Wrong timeout unity");  
		  end				   
	       end
	       else begin
		  $display("Wait Duration : No timeout");		  
	       end // else: !if(i_args[1] != "" && i_args[2] != "")


	       if(s_timeout_en) begin
		  
		  case (s_unit) 
		    "ps": begin
		       s_max_timeout_cnt = s_timeout_value / CLK_PERIOD;
		       $display("WAIT duration : %d %s",s_timeout_value, s_unit);
		       
		    end
		    "ns": begin
		       s_max_timeout_cnt = (1000 * s_timeout_value) / (CLK_PERIOD);
		       $display("WAIT duration : %d %s",s_timeout_value, s_unit);
		    end
		    "us": begin
		       s_max_timeout_cnt = (1000000 * s_timeout_value) / (CLK_PERIOD);
		       $display("WAIT duration : %d %s",s_timeout_value, s_unit);
		    end
		    "ms": begin
		       s_max_timeout_cnt = (1000000000 * s_timeout_value) / (CLK_PERIOD);
		       $display("WAIT duration : %d %s",s_timeout_value, s_unit);
		    end
		    
		    default: begin
		       $display("Error: wrong unit format");		       
		    end
		    
		  endcase // case (s_unit)
		          
	       end	  
		  
	       end // else: !if(i_args[0] != "WAIT")
	       
	       
	    end // if (i_args_valid)
	    
	    
	 end // if (i_sel_wait_duration)

	 if(s_timeout_done) begin
	    s_timeout_en <= 1'b0;	    
	 end
	 
	 
	 
      end // else: !if(!rst_n)
      
      
   end // always @ (posedge clk)



   // Timeout Management
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_timeout_cnt <= 32'h00000000;
	 s_timeout_done <= 1'b0;
	 
      end
      else begin

	 if(s_timeout_en == 1'b1 && s_timeout_done == 1'b0) begin
	    if(s_timeout_cnt < s_max_timeout_cnt) begin
	       s_timeout_cnt <= s_timeout_cnt + 1; // Inc Timeout Counter
	       s_timeout_done <= 1'b0;
	       
	    end
	    else begin
	       s_timeout_done <= 1'b1;
	       
	    end	    
	 end
         else begin
	   s_timeout_cnt <= 32'h00000000;
	   s_timeout_done <= 1'b0;
         end // else: !if(s_timeout_en)	 	 	 
      end      
   end // always @ (posedge clk)


   // WAIT DURATION DONE MANAGEMENT
/* -----\/----- EXCLUDED -----\/-----
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_wait_duration_done <= 1'b0;	 
      end
      else begin
	 if(s_timeout_done) begin
	    o_wait_duration_done <= 1'b1;
	 end
	 else if(s_timeout_en) begin
	    o_wait_duration_done <= 1'b0;	    
	 end	 
	 
      end // else: !if(!rst_n)      
   end // always @ (posedge clk)
 -----/\----- EXCLUDED -----/\----- */
   
   
   assign o_wait_duration_done = s_timeout_done;
   
endmodule // wait_duration
