//                              -*- Mode: Verilog -*-
// Filename        : uart_checker_wrapper.sv
// Description     : UART Injector Checker
// Author          : JorisP
// Created On      : Sat Apr 17 19:02:36 2021
// Last Modified By: JorisP
// Last Modified On: Sat Apr 17 19:02:36 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

interface uart_checker_intf #(
			      parameter G_NB_UART_CHECKER = 1,
			      parameter G_DATA_WIDTH      = 8			      
			      );

   logic clk;   

   // TX UART command
   logic start_tx                     [G_NB_UART_CHECKER - 1 : 0];
   logic [G_DATA_WIDTH - 1:0] tx_data [G_NB_UART_CHECKER - 1 : 0];
   logic 		      tx_done [G_NB_UART_CHECKER - 1 : 0];


   // RX UART command
   logic [G_DATA_WIDTH - 1:0] rx_data     [G_NB_UART_CHECKER - 1 : 0];
   logic 		      rx_done     [G_NB_UART_CHECKER - 1 : 0];
   logic 		      parity_rcvd [G_NB_UART_CHECKER - 1 : 0];   

   // ALIASES
   int 		      uart_checker_alias [string];
   
endinterface // uart_checker_intf


module uart_checker_wrapper #(

			      parameter G_NB_UART_CHECKER = 1,
			      parameter G_STOP_BIT_NUMBER = 1,
			      parameter G_POLARITY        = 1,
			      parameter G_PARITY          = 0,
			      parameter G_BAUDRATE        = 0,
			      parameter G_DATA_WIDTH      = 8,
			      parameter G_FIRST_BIT       = 0,
			      parameter G_CLOCK_FREQ      = 20000000
   )
   (
    input  clk,
    input  rst_n,

    input  [G_NB_UART_CHECKER - 1 : 0] i_rx,
    output [G_NB_UART_CHECKER - 1 : 0] o_tx, 

    // UART CHECKER INTERFACE
    uart_checker_intf uart_checker_if
    
    );


   // TX UART INST
   tx_uart #(
	     .stop_bit_number (G_STOP_BIT_NUMBER),
	     .parity          (G_PARITY),
	     .baudrate        (G_BAUDRATE),
	     .data_size       (G_DATA_WIDTH),
	     .polarity        (G_POLARITY),
	     .first_bit       (G_FIRST_BIT),
	     .clock_frequency (G_CLOCK_FREQ)
	     )
   i_tx_uart_checker [uart_checker_if.G_NB_UART_CHECKER - 1 : 0] (
								  .reset_n  (rst_n),
								  .clock    (clk),
								  .start_tx (uart_checker_if.start_tx),
								  .tx_data  (uart_checker_if.tx_data),						
								  .tx       (o_tx),
								  .tx_done  (uart_checker_if.tx_done)
								  );
   


   // RX UART INST
   rx_uart #(
	     .stop_bit_number (G_STOP_BIT_NUMBER),
	     .parity          (G_PARITY),
	     .baudrate        (G_BAUDRATE),
	     .data_size       (G_DATA_WIDTH),
	     .polarity        (G_POLARITY),
	     .first_bit       (G_FIRST_BIT),
	     .clock_frequency (G_CLOCK_FREQ)
	     )
   i_rx_uart_checker [uart_checker_if.G_NB_UART_CHECKER - 1 : 0] (
								  .reset_n      (rst_n),
								  .clock        (clk),
								  .rx           (i_rx),
								  .rx_data      (uart_checker_if.rx_data),
								  .rx_done      (uart_checker_if.rx_done),
								  .parity_rcvd  (uart_checker_if.parity_rcvd)
								  );
endmodule // uart_checker_wrapper
