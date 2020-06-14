//`include "max7219_emul.sv"

module max7219_matrix_emul
  #(
    parameter G_MATRIX_NB = 2
    )
   (
      input clk,
      input rst_n,
      input i_max7219_clk,
      input i_max7219_din,
      input i_max7219_load
    );
   
   
   typedef struct //packed
   {
       logic [8*8 - 1 : 0]   display_matrix_0 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_1 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_2 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_3 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_4 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_5 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_6 [7:0];
       logic [8*8 - 1 : 0]   display_matrix_7 [7:0];
  
            
   } max7219_display_matrix_t;

   max7219_display_matrix_t max7219_display_matrix;

   

   // == INTERNAL WIRES ==
   wire [G_MATRIX_NB - 1 : 0] s_max7219_din;
   wire [G_MATRIX_NB - 1 : 0] s_max7219_dout;

   wire [8*8 - 1 : 0] 	      s_matrix_2_display [7:0] [G_MATRIX_NB - 1 : 0];
   wire [8*8 - 1 : 0] 	      s_matrix_0 [7:0];
   
   wire [G_MATRIX_NB - 1 : 0] s_matrix_char_val;
   
   wire 		      s_val;
   

   assign max7219_display_matrix.display_matrix_0 = max7219_emul_inst_0.s_matrix_char;
   assign max7219_display_matrix.display_matrix_1 = max7219_emul_inst_1.s_matrix_char;

     // == MATRIX 0 INST
     max7219_emul #(
		     .G_MATRIX_I  (0),
                     .G_VERBOSE   (4'd0)
      )
      max7219_emul_inst_0 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (i_max7219_din),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[0]),
			 
			 .o_matrix_char_val  (s_matrix_char_val[0])
			 
      );

   // == MATRIX 1 INST
   max7219_emul #(
		     .G_MATRIX_I  (1),
                     .G_VERBOSE   (4'd0)
      )
      max7219_emul_inst_1 (
			 .clk             (clk),
			 .rst_n           (rst_n),
			 .i_max7219_clk   (i_max7219_clk),
			 .i_max7219_din   (s_max7219_dout[0]),
			 .i_max7219_load  (i_max7219_load),
			 .o_max7219_dout  (s_max7219_dout[1]),			
 
			 .o_matrix_char_val  ()
			 
      );



   assign s_val = s_matrix_char_val[0];   

   reg [G_MATRIX_NB*8*8-1 : 0] s_line_2_display;
   
   // == DISPLAY MATRIX IN TRANSCRIPT
   always @(posedge clk) begin
      if(!rst_n) begin
	 
      end
      else begin
	 if(s_val) begin
	    for(int j = 0 ; j < G_MATRIX_NB ; j++) begin
	       for(int k = 7 ; k >= 0 ; k--) begin
		  s_line_2_display = {max7219_display_matrix.display_matrix_0[k], max7219_display_matrix.display_matrix_1[k]};
		  
		  $display("%s", s_line_2_display);	  
	       end	       
	    end
	    
	 end	 
      end      
   end
   
  
endmodule // max7219_matrix_emul
