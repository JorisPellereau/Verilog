module max7219_emul
  #(
    )
   (
      input clk,
      input rst_n,
      input i_max7219_clk,
      input i_max7219_din,
      input i_max7219_load,

      output i_max7219_dout  
    );



   // TYPES
   typedef struct packed
   {
      logic [7:0] REG_NO_OP;
      logic [7:0] REG_DIGIT_0;
      logic [7:0] REG_DIGIT_1;
      logic [7:0] REG_DIGIT_2;
      logic [7:0] REG_DIGIT_3;
      logic [7:0] REG_DIGIT_4;
      logic [7:0] REG_DIGIT_5;
      logic [7:0] REG_DIGIT_6;
      logic [7:0] REG_DIGIT_7;
      logic [7:0] REG_DECODE_MODE;
      logic [7:0] REG_INTENSITY;
      logic [7:0] REG_SCAN_LIMIT;
      logic [7:0] REG_SHUTDOWN;
      logic [7:0] REG_DISPLAY_TEST;
      
   } max7219_register_struct_t;
   

   // INTERNAL WIRES
   logic    [15:0] s_max7219_data;
   logic    [3:0]  s_cnt_15;

   logic    s_max7219_clk; // Latch i_max7219_clk
   logic    s_cnt_15_done;
   logic    s_reg_updated; // REGISTER UPDATED FLAG
   

   wire     s_max7219_clk_r_edge;

   max7219_register_struct_t max7219_reg;

   // == ALWAYS BLOCKS ==

   // LATCH INPUTS
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_clk <= 1'b0;	
      end
      else begin
	 s_max7219_clk <= i_max7219_clk;	 
      end      
   end

   // Rising Edge detection
   assign s_max7219_clk_r_edge = i_max7219_clk && ! s_max7219_clk;




   // DIN LATCH
   always @(posedge clk) begin
      if (!rst_n) begin
	 s_max7219_data <= 16'h0000;
	 s_cnt_15       <= 4'h0;
	 s_cnt_15_done  <= 1'b0;
	 
      end
      else begin
         s_cnt_15_done <= 1'b0; // PULSE
	
         // MSB FIRST 
	 if(s_max7219_clk_r_edge) begin
	    s_max7219_data[0]    <= i_max7219_data;
	    s_max7219_data[15:1] <= s_max7219_data[14:0];
	    
	    if(s_cnt_15 < 4'hF) begin
	       s_cnt_15 <= s_cnt_15 + 1;
	    end
	    else begin
	       s_cnt_15 <= 0;
	       s_cnt_15_done <= 1'b1;	       
	    end	    	    
	 end	 	 
      end 
     
   end // always @ (posedge clk)
   
   
   

   // MAX7219 REGISTER UPDATE ON LOAD
   
   always @(posedge clk) begin
      if (!rst_n) begin
	 max7219_reg.REG_NO_OP        = 8'h00;
	 max7219_reg.REG_DIGIT_0      = 8'h00;
	 max7219_reg.REG_DIGIT_1      = 8'h00;
	 max7219_reg.REG_DIGIT_2      = 8'h00;
	 max7219_reg.REG_DIGIT_3      = 8'h00;
	 max7219_reg.REG_DIGIT_4      = 8'h00;
	 max7219_reg.REG_DIGIT_5      = 8'h00;
	 max7219_reg.REG_DIGIT_6      = 8'h00;
	 max7219_reg.REG_DIGIT_7      = 8'h00;
	 max7219_reg.REG_DECODE_MODE  = 8'h00;
	 max7219_reg.REG_INTENSITY    = 8'h00;      
	 max7219_reg.REG_SCAN_LIMIT   = 8'h00;
	 max7219_reg.REG_SHUTDOWN     = 8'h00;
	 max7219_reg.REG_DISPLAY_TEST = 8'h00;
	 s_reg_updated                = 1'b0;
	 
      end
      else begin

	 // LATCH DIN in right register
	 if (i_max7219_load) begin

	    // DECODAGE
	    case (s_max7219_data[11:8])
	      4'h0 : max7219_reg.REG_NO_OP        = s_max7219_data[7:0]);
	      4'h1 : max7219_reg.REG_DIGIT_0      = s_max7219_data[7:0]);
              4'h2 : max7219_reg.REG_DIGIT_1      = s_max7219_data[7:0]);
              4'h3 : max7219_reg.REG_DIGIT_2      = s_max7219_data[7:0]);
              4'h4 : max7219_reg.REG_DIGIT_3      = s_max7219_data[7:0]);
	      4'h5 : max7219_reg.REG_DIGIT_4      = s_max7219_data[7:0]);
              4'h6 : max7219_reg.REG_DIGIT_5      = s_max7219_data[7:0]);
	      4'h7 : max7219_reg.REG_DIGIT_6      = s_max7219_data[7:0]);
              4'h8 : max7219_reg.REG_DIGIT_7      = s_max7219_data[7:0]);
	      4'h9 : max7219_reg.REG_DECODE_MODE  = s_max7219_data[7:0]);
	      4'hA : max7219_reg.REG_INTENSITY    = s_max7219_data[7:0]);
	      4'hB : max7219_reg.REG_SCAN_LIMIT   = s_max7219_data[7:0]);
	      4'hC : max7219_reg.REG_SHUTDOWN     = s_max7219_data[7:0]);
	      4'hF : max7219_reg.REG_DISPLAY_TEST = s_max7219_data[7:0]);    
	      default : $display("ERROR in Register @");
	      
	    endcase // case (s_max7219_data[11:8])
	    s_reg_updated = 1'b1;
	    
	 else begin
	   s_reg_updated = 1'b0; 
	 end 
	    
       end   
      end // else: !if(!rst_n)
   end // always @ (posedge clk)
   
   
    // DISPLAY REGITERS IN TRANSCRIPT
    always @(posedge clk) begin
       if(!rst_n) begin
	  
       end
       else begin
	  if(s_reg_updated) begin
	     $display("Register @0: No-Op        : %h" , max7219_reg.REG_NO_OP);
	     $display("Register @1: Digit_0      : %h" , max7219_reg.REG_DIGIT_0);
             $display("Register @2: Digit_1      : %h" , max7219_reg.REG_DIGIT_1);
             $display("Register @3: Digit_2      : %h" , max7219_reg.REG_DIGIT_2);
             $display("Register @4: Digit_3      : %h" , max7219_reg.REG_DIGIT_3);
	     $display("Register @5: Digit_4      : %h" , max7219_reg.REG_DIGIT_4);
             $display("Register @6: Digit_5      : %h" , max7219_reg.REG_DIGIT_5);
	     $display("Register @7: Digit_6      : %h" , max7219_reg.REG_DIGIT_6);
             $display("Register @8: Digit_7      : %h" , max7219_reg.REG_DIGIT_7);
	     $display("Register @9: Decode_Mode  : %h" , max7219_reg.REG_DECOD_MODE);
	     $display("Register @A: Intensity    : %h" , max7219_reg.REG_INTENSITY);
	     $display("Register @B: Scan_Limit   : %h" , max7219_reg.REG_SCAN_LIMIT);
	     $display("Register @C: Shutdown     : %h" , max7219_reg.REG_SHUTDOWN);
	     $display("Register @F: Display_Test : %h" , max7219_reg.REG_DISPLAY_TEST);
	  end	  
       end       
    end
   



   
   // =====================
endmodule // max7219_emul
