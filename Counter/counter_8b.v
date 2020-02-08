

module counter_8b (
		   input clk,
		   input rst_n,
		   input i_en_cnt,

		   output o_cnt_done

		   );
   

   reg [7:0] s_cnt;
   reg      s_cnt_done;
   

   always @(posedge clk) begin

      if(!rst_n) begin
	 s_cnt      <= 2'h0;
	 s_cnt_done <= 1'b0;
	 
      end
      else begin
	 if(i_en_cnt) begin
	    if(s_cnt < 255) begin
	       s_cnt <= s_cnt + 1;
	       s_cnt_done <= 1'b0;
            end	       
 	    else begin
	       s_cnt <= 2'h0;
	       s_cnt_done <= 1'b1;
	    end
	    
	 end
	 else begin
	   s_cnt      <= 2'h0;
	   s_cnt_done <= 1'b0; 
	end	    	 
      end      
   end
   
   assign o_cnt_done = s_cnt_done;
   

endmodule // counter_8b
