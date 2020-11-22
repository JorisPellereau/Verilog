module tb_test;

   // Clock & Reset
   bit clk;
   bit rst_n;


   // Clock generation
   always #5 clk = ~clk;


   // Reset Generation
   initial begin
      reset    = 1;
      #5 reset = 0;
      #5 reset = 1;      
   end
   


   // == DUT INST. ==
   counter_8b counter_8b_inst (
		              .clk        (),
		              .rst_n      (),
		              .i_en_cnt   (),
		              .o_cnt_done ()
   );
   
   

endmodule // tb_test
