//                              -*- Mode: Verilog -*-
// Filename        : testbench_setup.sv
// Description     : Testbench Constant Setup
// Author          : JorisP
// Created On      : Wed Oct 21 19:51:54 2020
// Last Modified By: JorisP
// Last Modified On: Wed Oct 21 19:51:54 2020
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ps/1ps

// Clock and Reset Configuration
`define C_TB_CLK_HALF_PERIOD 1000  // 1000 ps = 1 ns
`define C_WAIT_RST           2000  // 2000 ps = 2 ns

// TESTBENCH SEQUENCER Configuration
`define C_CMD_ARGS_NB 5

// SET ALIAS Configuration
`define C_SET_ALIAS_NB 5
`define C_SET_SIZE     5
`define C_SET_WIDTH    32

// WAIT EVENT Configuration
`define C_WAIT_ALIAS_NB 5
`define C_WAIT_WIDTH    1
