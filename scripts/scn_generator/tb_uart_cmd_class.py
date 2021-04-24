#
# Description : UART Testbench module Class for scenario
#
# Author  : J.P
# Date    : 24/04/2021
# Version : 1.0
#
#

import sys


class generic_tb_uart_cmd_class:

    # INIT of the class
    def __init__(self, output_file_path, f):
        self.out_file = output_file_path
        self.f = f


    # UART TX START
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to write via UART
    def TX_START(self, alias, data_list):

        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "

        line_to_print = "UART[" + alias + "] TX_START(" + line_to_print + str(data_list[len(data_list) - 1]) + ")\n"
        self.f.write(line_to_print)


    # UART RX_READ
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to read from UART
    def RX_READ(self, alias, data_list):
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "
        
        line_to_print = "UART[" + alias + "] RX_READ(" + line_to_print + str(data_list[len(data_list) - 1]) + ")\n"
        self.f.write(line_to_print)
