# STR Constants

testbench_setup_generic_str = """
`timescale 1ps/1ps

// Clock and Reset Configuration - Unit in [ps]
`define C_TB_CLK_HALF_PERIOD {0}
`define C_WAIT_RST           {1}
`define C_TB_CLK_PERIOD      {2}

// SET ALIAS Configuration
`define C_SET_ALIAS_NB {3}
`define C_SET_SIZE     {4}
`define C_SET_WIDTH    {5}

// WAIT EVENT Configuration
`define C_WAIT_ALIAS_NB {6}
`define C_WAIT_WIDTH    {7}

// CHECK LEVEL Configuration
`define C_CHECK_ALIAS_NB {8}
`define C_CHECK_SIZE     {9}
`define C_CHECK_WIDTH    {10}

"""

uart_cst_str = """
// UART TESTBENCH Configuration - {0}
`define C_NB_UART_CHECKER_{1}         {2}
`define C_UART_DATA_WIDTH_{3}         {4}
`define C_UART_BUFFER_ADDR_WIDTH_{5}  {6}
`define C_STOP_BIT_NUMBER_{7}         {8}
`define C_POLARITY_{9}                {10}
`define C_PARITY_{11}                 {12}
`define C_BAUDRATE_{13}               {14}
`define C_FIRST_BIT_{15}              {16}
`define C_CLOCK_FREQ_{17}             {18}

"""

data_collector_str = """
// DATA COLLECTOR Configuration - {0}
`define C_NB_DATA_COLLECTOR_{1}         {2}
`define C_DATA_COLLECTOR_DATA_WIDTH_{3} {4}

"""

data_checker_str = """
// DATA CHECKER Configuration - {0}

"""

clk_gen_str = """
`timescale 1ps/1ps

    module clk_gen
       #(
         parameter int G_CLK_HALF_PERIOD = {0},
         parameter int G_WAIT_RST        = {1}
       )
       (
        output reg clk_tb,
        output reg rst_n
       );

       // Clock generation
       initial begin
         clk_tb <= 1'b0;
         forever begin
           #G_CLK_HALF_PERIOD;	
           clk_tb <= ~ clk_tb;
         end      
       end

       // Reset generation
       initial begin
         rst_n <= 1'b0;
         #G_WAIT_RST;
         rst_n <= 1'b0;
         #G_WAIT_RST;
         rst_n <= 1'b1;
       end     
   
endmodule // clk_gen"""
