#
# Description : Class of GENERIC TESTBENCH COMMAND
#
# Author  : J.P
# Date    : 01/03/2021
# Version : 1.0
#
#
# Example 1 : 

import sys


class generic_tb_cmd_class:


    # INIT of the class
    def __init__(self, output_file_path, f):
        self.out_file = output_file_path
        self.f = f


    # Print the SET command with Data in HEXA
    # data : integer
    def SET(self, alias, data):

        line_to_print = "SET " + alias + " " + hex(data) + "\n"
        self.f.write(line_to_print)


    # Print END_TEST at the end of the test
    def END_TEST(self):#, self.out_file):
        line_to_print = "END_TEST"
        self.f.write(line_to_print) 
