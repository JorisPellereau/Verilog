#
# Description : Class for scenario
#
# Author  : J.P
# Date    : 28/11/2021
# Version : 1.0
# Update : 
#

class tb_data_collector_cmd_class:

    # INIT of the class
    def __init__(self, scn_line_list):
        self.scn_line_list = scn_line_list

    # Init File for DATA Collector
    def DATA_COLLECTOR_INIT(self, alias, index, file_path):
        line_to_print = "DATA_COLLECTOR[{0}] INIT({1}, {2})".format(alias, index, file_path)
        self.scn_line_list.append(line_to_print)

    # Close File for Data collector
    def DATA_COLLECTOR_CLOSE(self, alias, index):
        line_to_print = "DATA_COLLECTOR[{0}] CLOSE({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Start Data colector
    def DATA_COLLECTOR_START(self, alias, index):
        line_to_print = "DATA_COLLECTOR[{0}] START({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)

    # Stop Data collector
    def DATA_COLLECTOR_STOP(self, alias, index):
        line_to_print = "DATA_COLLECTOR[{0}] STOP({1})".format(alias, index)
        self.scn_line_list.append(line_to_print)
    
