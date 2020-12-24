//                              -*- Mode: Verilog -*-
// Filename        : max7219_checker_wrapper.sv
// Description     : MAX7219 Checker/Emulator - Wrapper for Daisy chain Matrix
// Author          : JorisP
// Created On      : Sun Dec 20 18:57:47 2020
// Last Modified By: JorisP
// Last Modified On: Sun Dec 20 18:57:47 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "max7219_checker_pkg.sv"

module max7219_checker_wrapper #(
				 parameter G_NB_MATRIX = 8
				 )
   (
      input  clk,
      input  rst_n,

      // MAX7219 I/F - 1st Matrix
     input  i_max7219_clk,
     input  i_max7219_din,
     input  i_max7219_load,

     input [G_NB_MATRIX - 1 : 0] i_display_reg_matrix_n,
     input                       i_display_screen_matrix
    
    );

   genvar 			 i;  // Genvar for Generater MAX7219_Checker modules

   


   // == INTERNALS SIGNALS ==
   wire [G_NB_MATRIX - 1 : 0] 	 s_max7219_din;
   wire [G_NB_MATRIX - 1 : 0] 	 s_max7219_dout;
   wire [G_NB_MATRIX - 1 : 0] 	 s_frame_received;

   logic 			 s_display_screen_matrix;
   wire 			 s_display_screen_matrix_r_edge;
   
   max7219_register_struct_t max7219_screen_matrix [G_NB_MATRIX - 1 : 0];
   
   
   // =======================

   // Latch Inputs
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_display_screen_matrix <= 1'b0;	 
      end
      else begin
	 s_display_screen_matrix <= i_display_screen_matrix;	 
      end      
   end

   // Rising Edge detection
   assign s_display_screen_matrix_r_edge = i_display_screen_matrix && ! s_display_screen_matrix;
   
   // == GENERATES MATRIX CHECKER and ROUTE I/Os ==
   generate
     for(i = 0 ; i < G_NB_MATRIX ; i++) begin : gen_max7219_checker

	// MAX7219 Checker Instanciation
	max7219_checker #(
			  .G_MATRIX_N  (i)
        )
        i_max7219_checker_0 (
					       .clk    (clk),
					       .rst_n  (rst_n),
					     
					       .i_max7219_clk    (i_max7219_clk),
					       .i_max7219_din    (s_max7219_din[i]),
					       .i_max7219_load   (i_max7219_load),
					       .o_max7219_dout   (s_max7219_dout[i]),

					       .i_display_reg     (i_display_reg_matrix_n[i]),
					       .o_frame_received  (s_frame_received[i])
					     );

	if(i == 0) begin
	  assign s_max7219_din[0] = i_max7219_din; // Din From MAX7219 I/F
	end
	else if(i > 0 && i < G_NB_MATRIX) begin
	   assign s_max7219_din[i] = s_max7219_dout[i - 1];
	end

	// Connected to Internal registers of each MAX7219 checkers
        assign max7219_screen_matrix[i] = gen_max7219_checker[i].i_max7219_checker_0.max7219_reg;
	       	
     end	      
   endgenerate
   // =============================================


   reg [8*8*G_NB_MATRIX - 1 : 0] line_char;
   
   reg [8*G_NB_MATRIX - 1 : 0] line;
   int 			       k;
   int 			       l;
   int 			       m;
   int 			       n;
   
   
   
   // == DISPLAY SCREEN MATRIX ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 line      <= 0;
	 line_char <= 0;
	 
      end
      else begin
	 if(s_display_screen_matrix_r_edge == 1'b1) begin
	    for(k = 0 ; k < 8 ; k++) begin
	       for(l = 0 ; l < G_NB_MATRIX ; l++) begin
		  for(m = 0 ; m < 8 ; m++) begin
		     if(m == 0) begin
  			line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_7[7 - k];
		     end
		     else if(m == 1) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_6[7 - k];	
		     end
		     else if(m == 2) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_5[7 - k];	
		     end
		     else if(m == 3) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_4[7 - k];	
		     end
		     else if(m == 4) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_3[7 - k];	
		     end
		     else if(m == 5) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_2[7 - k];	
		     end
		     else if(m == 6) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_1[7 - k];	
		     end
		     else if(m == 7) begin
		        line[(8*G_NB_MATRIX - 1) - (m+l*8)] = max7219_screen_matrix[l].REG_DIGIT_0[7 - k];	
		     end
		     
		  end
		  
	       end // for (l = 0 ; l < G_NB_MATRIX ; l++)
	       //$display("%B", line);
	       
	       for(n = 0; n < 8*G_NB_MATRIX ; n++) begin	         
		  if(line[n] == 1'b1) begin		     
		     line_char[n*8 +: /*n*8 +*/ 7] = "*";		     
		  end
		  else begin		     
		     line_char[n*8 +: /*n*8 +*/ 7] = " ";
		  end		  		  
	       end
	       
	       $display("%s", line_char);
	       
	       
	       line      <= 0;
	       line_char <= 0;
	       
	       
	    end
	    
	 end	 
      end      
   end
   
   // ===========================
   
   
   
   
   
  
endmodule // max7219_checker_wrapper
