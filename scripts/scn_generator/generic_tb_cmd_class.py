#
# Description : Class of GENERIC TESTBENCH COMMAND
#
# Author  : J.P
# Date    : 01/03/2021
# Version : 1.0
#
#

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

        

    # Print WTR commands
    # Timeout is optionnal
    def WTR(self, alias, timeout = 'none', unity = 'none'):
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTR " + alias + "\n"
            self.f.write(line_to_print)
        else:
             line_to_print = "WTR " + alias + " " + str(timeout) + " " + unity + "\n"
             self.f.write(line_to_print)


    # Print WTF commands
    # Timeout is optionnal
    def WTF(self, alias, timeout = 'none', unity = 'none'):
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTF " + alias + "\n"
            self.f.write(line_to_print)
        else:
             line_to_print = "WTF " + alias + " " + str(timeout) + " " + unity + "\n"
             self.f.write(line_to_print)


    # Print WTRS commands
    # Timeout is optionnal
    def WTRS(self, alias, timeout = 'none', unity = 'none'):
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTRS " + alias + "\n"
            self.f.write(line_to_print)
        else:
             line_to_print = "WTRS " + alias + " " + str(timeout) + " " + unity + "\n"
             self.f.write(line_to_print)


    # Print WTFS commands
    # Timeout is optionnal
    def WTFS(self, alias, timeout = 'none', unity = 'none'):
        if(timeout == 'none' and unity == 'none'):            
            line_to_print = "WTFS " + alias + "\n"
            self.f.write(line_to_print)
        else:
             line_to_print = "WTFS " + alias + " " + str(timeout) + " " + unity + "\n"
             self.f.write(line_to_print)

    # Print CHK Commands
    # data : int
    # test : "OK" or "ERROR"
    def CHK(self, alias, data, test):
        line_to_print = "CHK " + alias + " " + hex(data) + " " + test + "\n"
        self.f.write(line_to_print)

        

    # Print WAIT commands
    # duree : int
    # unity : "ps", "ns", "us", "ms"
    def WAIT(self, duree, unity):
        line_to_print = "WAIT " + str(duree) + " " + unity + "\n"
        self.f.write(line_to_print)


    # Print Modelsim Command
    def MODELSIM_CMD(self, modelsim_cmd):
        line_to_print = "MODELSIM_CMD" + " (\"" + modelsim_cmd + "\")" + "\n"
        self.f.write(line_to_print)

    # Print END_TEST at the end of the test
    def END_TEST(self):#, self.out_file):
        line_to_print = "END_TEST"
        self.f.write(line_to_print) 
