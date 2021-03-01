#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 01/03/2021
# Version : 1.0
#
#
# Example 1 : 

import sys
import generic_tb_cmd_class

class scn_class:

    # INIT of the class
    def __init__(self, output_file_path):
        self.out_file = output_file_path
        self.f = self.open_scn_file( self.out_file)       
        self.generic_tb_cmd = generic_tb_cmd_class.generic_tb_cmd_class( self.out_file, self.f)


    # Open PY SCN file in append mode
    def open_scn_file(self, out_file):
        f = open(out_file, "w")
        return f;

    # Print a Custom Line in SCN
    def print_line(self, line_2_print):
        self.f.write(line_2_print)
        

    
    # Close PY SCN file and print END_TEST
    def END_TEST(self):
        self.generic_tb_cmd.END_TEST()
        self.f.close()
        
