#
# Description : UART Testbench module Class for scenario
#
# Author  : J.P
# Date    : 24/04/2021
# Version : 1.0
#
#

import sys

class tb_uart_cmd_class:

    # INIT of the class
    def __init__(self, scn_line_list):#output_file_path, f):
        self.scn_line_list = scn_line_list


    # UART TX START
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to write via UART
    def TX_START(self, alias, data_list):
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "

        line_to_print = "UART[" + alias + "] TX_START(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)


    # UART RX_READ
    # alias : Alias of UART module - A string
    # data_list : a list of Hex data to read from UART
    def RX_READ(self, alias, data_list):
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "
        
        line_to_print = "UART[" + alias + "] RX_READ(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)


    # UART RX_WAIT_DATA
    # alias : Alias of UART module - A string
    # data list : a list of Hex data to read from UART
    def RX_WAIT_DATA(self, alias, data_list):
        line_to_print = ""
        for i in range(0, len(data_list) - 1):
            line_to_print = line_to_print + str(data_list[i]) + " "
            
        line_to_print = "UART[" + alias + "] RX_WAIT_DATA(" + line_to_print + str(data_list[len(data_list) - 1]) + ")"
        self.scn_line_list.append(line_to_print)
