//                              -*- Mode: Verilog -*-
// Filename        : i2c_slave_checker.sv
// Description     : Simple I2C Slave checker
// Author          : JorisP
// Created On      : Sun Jul 11 14:42:04 2021
// Last Modified By: JorisP
// Last Modified On: Sun Jul 11 14:42:04 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module i2c_slave_checker (
			  input        clk,
			  input        rst_n,

			  input [6:0]  i_chip_addr,
			  input [7:0]  i_wdata,
			  output       o_wdata_valid, 

			  output [7:0] o_rdata,
			  output       o_rdata_valid,

			  // STATUS
			  output o_chip_addr_ok,

			  // I2C I/F
			  inout        scl,
			  inout        sda
			  
			  );


   // == INTERNAL SIGNALS ==
   logic 			       s_scl; // Latch SCL
   logic 			       s_scl_r_edge;

   logic 			       s_sda;
   logic 			       s_sda_f_edge;
   

   logic 			       s_chip_addr_ok;
   logic 			       s_read_or_write;

   logic 			       s_start_detected;

   logic [6:0] 			       s_chip_addr;
   reg [3:0] 			       s_cnt_8;
   
   logic 			       s_en_sda;
   logic 			       s_sda_out;
   
   
   

   // == LATCH INPUTS ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_scl <= 0;
	 s_sda <= 0;	 
      end
      else begin
	 s_scl <= scl;
	 s_sda <= sda;	 
      end      
   end // always @ (posedge clk)

   assign s_scl_r_edge = scl && ! s_scl;
   assign s_sda_f_edge = ! sda && s_sda;
   
   // == START DETECTION ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_start_detected <= 0;

      end
      else begin
	 if(s_sda_f_edge == 1) begin
	    if(scl == 1) begin
	       s_start_detected <= 1;	       
	    end	    
	 end
      end      
   end
   

   // == CONTROL BYTE DECODE ==
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_chip_addr_ok  <= 0;
	 s_read_or_write <= 0;
	 s_chip_addr     <= 0;	
	 s_cnt_8         <= 0;
	 s_chip_addr_ok  <= 0;
      end
      else begin
	 if(s_start_detected == 1) begin
	    if(s_scl_r_edge == 1) begin

	       if(s_cnt_8 < 7) begin
		  s_chip_addr[0]   <= sda;
		  s_chip_addr[6:1] <= s_chip_addr[5:0];
		  s_cnt_8 <= s_cnt_8 + 1;
		  
	       end
	       else if(s_cnt_8 < 8) begin
		  s_read_or_write <= sda;
		  s_cnt_8         <= s_cnt_8 + 1;
		  s_cnt_8 <= 0;
		  
	       end
	       
	    end // if (s_scl_r_edge == 1)

	    
	 end // if (s_start_detected == 1)
	 else begin
	    s_chip_addr_ok  <= 0;
	    s_read_or_write <= 0;
	    s_chip_addr     <= 0;	
	    s_cnt_8         <= 0;
	    s_chip_addr_ok  <= 0;
	 end // else: !if(s_start_detected == 1)
	 
	 if(s_cnt_8 == 8) begin
	    if(s_chip_addr == i_chip_addr) begin
	       s_chip_addr_ok <= 1;	     
	    end
	    else begin
	       s_chip_addr_ok <= 0;
	    end	    
	    
	 end
  
      end      
   end


   // == SLAVE ACK MNGT ==
   // SDA
   always @(posedge clk) begin
      if(!rst_n) begin
	 s_sda_out <= 0;
	 s_en_sda  <= 0;
	 
      end
      else begin
	 if(s_chip_addr_ok == 1) begin
	    if(s_scl_r_edge == 1) begin
	       s_en_sda <=1;
	       
	    end
	 end
      end
      
   end


   assign sda = (s_en_sda == 1) ? s_sda_out : 1'bz;
   
  
endmodule // i2c_slave_checker
