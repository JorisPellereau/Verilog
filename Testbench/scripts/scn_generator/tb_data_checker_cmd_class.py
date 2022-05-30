#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 30/05/2022
# Version : 1.0
# Update : 
#

class tb_data_checker_cmd_class:

    # INIT of the class
    def __init__(self, scn_line_list):
        self.scn_line_list = scn_line_list

    # Init File for DATA Checker
    def DATA_CHECKER_INIT(self, alias, index, file_path):
        line_to_print = "DATA_CHECKER[{0}] INIT({1}, {2})".format(alias, index, file_path)
        self.scn_line_list.append(line_to_print)

    # Close File for Data checker
    def DATA_CHECKER_CLOSE(self, alias, index):
        line_to_print = "DATA_CHECKER[{0}] CLOSE({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Start Data checker
    def DATA_CHECKER_START(self, alias, index):
        line_to_print = "DATA_CHECKER[{0}] START({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Stop Data checker
    def DATA_CHECKER_STOP(self, alias, index):
        line_to_print = "DATA_CHECKER[{0}] STOP({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)
    
