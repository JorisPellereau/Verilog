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

   output reg		      o_wait_done
   
   );


   // INTERNAL signals
   reg [WAIT_WIDTH - 1 : 0]   s_wait [WAIT_SIZE];

   reg 			      s_wtr_wtf_sel; // 0 : WTR - 1 : WTF
   reg 			      s_valid;
   reg 			      s_timeout_en;
   
   reg 			      s_wtr_detected;
   reg 			      s_wtf_detected;   
      
   string		      s_alias;
   string 		      s_unit; // ps - ns - us - ms
   
   int s_alias_array [string];
   
   int s_max_timeout_cnt;
   int s_timeout_value;
   
   reg [31:0] s_timeout_cnt;
   reg 	      s_timeout_done;

   
   initial
   //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
   $timeformat(-9, 2, " ns", 20);
   

   // DECOD Command

   always @(posedge clk) begin
      if(!rst_n) begin
	 s_wtr_wtf_sel     <= 1'b0;
	 s_max_timeout_cnt <= 0;
	 s_timeout_value   <= 0;
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
		       $display("Timeout : %d %s",s_timeout_value, s_unit);
		       
		    end
		    "ns": begin
		       s_max_timeout_cnt = (1000 * s_timeout_value) / (CLK_PERIOD);
		       $display("Timeout : %d %s",s_timeout_value, s_unit);
		    end
		    "us": begin
		       s_max_timeout_cnt = (1000000 * s_timeout_value) / (CLK_PERIOD);
		       $display("Timeout : %d %s",s_timeout_value, s_unit);
		    end
		    "ms": begin
		       s_max_timeout_cnt = (1000000000 * s_timeout_value) / (CLK_PERIOD);
		       $display("Timeout : %d %s",s_timeout_value, s_unit);
		    end
		    
		    default: begin
		       $display("Error: wrong unit format");		       
		    end
		    
		  endcase // case (s_unit)
		          
	       end
	       
	       s_valid <= 1'b1;
	       
	    end // if (i_args_valid)
	    
            else begin
              //s_wtr_wtf_sel <= 1'b0; 
	      s_valid <= 1'b0; 
	     end // else: !if(i_args_valid)	    	 	 
         end // if (i_sel_wait)
	 else begin
	   s_valid <= 1'b0;
	   s_timeout_en <= 1'b0; 
	 end // else: !if(i_sel_wait)
	 
 	 if(s_wtr_detected == 1'b1 || s_wtf_detected == 1'b1 || s_timeout_done == 1'b1) begin
	    s_timeout_en <= 1'b0;
	    
	 end
	 
      end      
   end
   

   // Edge Detection
   always @(posedge clk) begin
      if(!rst_n) begin
	 
	 for (int i = 0; i < WAIT_SIZE; i++) begin
	   s_alias_array[i_wait_alias[i]] = i;
         end

	 s_wtr_detected <= 1'b0;
	 s_wtf_detected <= 1'b0;
	 
      end
      else begin

	 if(i_sel_wait == 1'b1) begin
	   // WTR selected
	   if(s_wtr_wtf_sel == 1'b0) begin
	        if(i_wait[s_alias_array[i_args[1]]] == 1'b1 && s_wait[s_alias_array[i_args[1]]] == 1'b0) begin
	           $display("Info: Rising Edge detected");
	           s_wtr_detected <= 1'b1;
	        end
	        else begin
		   s_wtr_detected <= 1'b0;
	        end
	      
	   end
	   else begin
	        if(i_wait[s_alias_array[i_args[1]]] == 1'b0 && s_wait[s_alias_array[i_args[1]]] == 1'b1) begin
	           $display("Info: Falling Edge detected");
	           s_wtf_detected <= 1'b1;
	        end
	        else begin
		   s_wtf_detected <= 1'b0;
	        end	      
	
	    end // else: !if(s_wtr_wtf_sel == 1'b0)

	 end // if (i_sel_wait == 1'b1)	 
	 else begin
	   s_wtr_detected <= 1'b0;
	   s_wtf_detected <= 1'b0;
	 end // else: !if(i_sel_wait == 1'b1)
      end // else: !if(!rst_n)
   end // always @ (posedge clk)
   

   
     
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
	       $display("Error: Timeout occurs %t", $time);
	       
	    end	    
	 end
         else begin
	   s_timeout_cnt <= 32'h00000000;
	   s_timeout_done <= 1'b0;
         end // else: !if(s_timeout_en)	 	 	 
      end      
   end
   


   // WAIT DONE Management
   always @(posedge clk) begin
      if(!rst_n) begin
	 o_wait_done <= 1'b0;
      end
      else begin
	 
	    if(s_wtr_detected == 1'b1 && s_wtr_wtf_sel == 1'b0) begin
		 o_wait_done <= 1'b1;		 
	    end
	    else if(s_wtf_detected == 1'b1 && s_wtr_wtf_sel == 1'b1)  begin
      	         o_wait_done <= 1'b1; 
	    end
	    else if(s_timeout_done == 1'b1) begin
	         o_wait_done <= 1'b1;
	    end	 
	    else begin
	      o_wait_done <= 1'b0; 
	    end
      end // else: !if(!rst_n)
   end // always @ (posedge clk)
   

         
endmodule // wait_event


