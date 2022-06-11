import sys
from PySide2 import QtCore, QtGui, QtWidgets
import numpy as np

from datetime import *


class testbench_creator_class(QtWidgets.QDialog):


    def __init__(self, parent = None):
        QtWidgets.QDialog.__init__(self,parent)

        self.grid_layout = QtWidgets.QGridLayout()
        self.setLayout(self.grid_layout)

        
        # == INIT PARAM ==
        self.last_init_param = None
        self.data_collector_param_list = [["Alias : "                           , "DATA_COLLECTOR_COVERAGE"],
                                          ["Number of parallel collector :"     , "1"],
                                          ["Data Width : "                      , "32"]]
        
        self.data_collector_param_list_qt = self.tb_custom_module_parameters(self.data_collector_param_list)

        self.data_checker_param_list = [["Alias : "                      , "DATA_CHECKER_CRC"],
                                        ["Number parallel checker : "    , "1"],
                                        ["DATA_CHECKER Data Width : "    , "32"]]
        
        self.data_checker_param_list_qt = self.tb_custom_module_parameters(self.data_checker_param_list)

        
        self.uart_param_list = [["Alias : "                     , "UART_XX"],
                                ["Number of parallel UART :"    , "1"],
                                ["Data Width (7-8-9) : "        , "8"],
                                ["Buffer Addr Width : "         , "8"],
                                ["STOP Bit Number (1 or 2) : "  , "1"],
                                ["POLARITY ('0' or '1') : "     , "'1'"],
                                ["PARITY (None - Even - Odd): " , "None"],
                                ["BAUDRATE (bauds): "           , "9600"] ,
                                ["STOP Bit Number : "           , "1"],
                                ["FIRST Bit (LSB or MSB) : "    , "LSB"],
                                ["CLOCK FREQUENCY (Hz) : "      , "20000000"]]

        self.uart_param_list_qt = self.tb_custom_module_parameters(self.uart_param_list)

        self.custom_tb_module_parameters_position = 3
        
        # == TITLE ==
        self.title = QtWidgets.QLabel("TESTBENCH CREATOR")
        
        # == PATH of Generated Testbench ==
        self.tb_path_text    = QtWidgets.QLabel("Path of generated Testbench :")
        self.tb_path_to_edit = QtWidgets.QLineEdit("./tb_sources/XXX")

        # == Selection of Custom Testbench Modules ==
        self.custom_tb_modules_list = QtWidgets.QListWidget()
        
        self.item_list = ["DATA_COLLECTOR", "DATA_CHECKER", "UART"]
        self.custom_tb_modules_list.addItems(self.item_list)

        # == ADD Select Custom Testbench Modules ==
        self.button_add_select_custom_tb_modules = QtWidgets.QPushButton("ADD Custom Testbench Module")
        self.button_del_sel_custom_tb_modules    = QtWidgets.QPushButton("DELETE Custom Testbench Module")

        # == Testbench Info List ==
        self.tb_info_list = QtWidgets.QListWidget()
        self.custom_tb_info_list = []
        
        # == GENERATE BUTTON ==
        self.button_generer_tb = QtWidgets.QPushButton("Generate Testbench")

        # Init Grid
        self.init_grid_layout()
        
        # Update Click
        self.click_update()



        
    def init_grid_layout(self):
        self.grid_layout.addWidget(self.title,             0, 0)
        
        self.grid_layout.addWidget(self.tb_path_text,      1, 0)
        self.grid_layout.addWidget(self.tb_path_to_edit,   1, 1)

        self.grid_layout.addWidget(self.custom_tb_modules_list, 2, 0)

        # == Custom TB Modules display on several lines ==
        self.add_to_grid_layout(qt_param_list = self.data_collector_param_list_qt)

        self.add_to_grid_layout(qt_param_list = self.data_checker_param_list_qt)

        self.add_to_grid_layout(qt_param_list = self.uart_param_list_qt)
                                
        
        self.grid_layout.addWidget(self.button_add_select_custom_tb_modules, self.grid_layout.rowCount(), 0)

        self.grid_layout.addWidget(self.tb_info_list,           self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.button_del_sel_custom_tb_modules, self.grid_layout.rowCount(), 0)
        self.grid_layout.addWidget(self.button_generer_tb,      self.grid_layout.rowCount(), 0)

        self.hide_all_module_param()
        #        self.button_generer_tb.hide()
        #self.grid_layout.addWidget(self.button_add_select_custom_tb_modules,      10, 0)
#        self.grid_layout.replaceWidget(self.button_generer_tb, self.button_add_select_custom_tb_modules)

    def add_to_grid_layout(self, qt_param_list):

        # Update for the 1st time        
        for i in range(0, len(qt_param_list)):
            nb_row = self.grid_layout.rowCount()
            self.grid_layout.addWidget(qt_param_list[i][0], nb_row, 0)
            self.grid_layout.addWidget(qt_param_list[i][1], nb_row, 1)

       
            
    
    def print_debug(self):
        print("DEBUG !!!")


    
    def click_update(self):
        self.button_generer_tb.clicked.connect(self.generate_testbench)

        # == ITEM LIST CLICK ==
        self.custom_tb_modules_list.itemClicked.connect(self.list_click_mngt)

        # == ADD Custom TB Module Mngt ==
        self.button_add_select_custom_tb_modules.clicked.connect(self.add_sel_module_to_tb_info_list)


    # == FUNCTION on CLICK ==

    def add_sel_module_to_tb_info_list(self):

        # Get info of selected TB Module 

        if(self.custom_tb_modules_list.currentRow() == 0):
       
            print("Data collector Added !")

            info_tmp = self.get_custom_module_info(qt_param_list = self.data_collector_param_list_qt) # Get Info
            
            
        elif(self.custom_tb_modules_list.currentRow() == 1):
            None
            print("DAta checker Added !")
        elif(self.custom_tb_modules_list.currentRow() == 2):
            print("UART added !")
            None
            
    def generate_testbench(self):
        print("testtesttest !!!")

        
    def list_click_mngt(self):

        if(self.custom_tb_modules_list.currentRow() == 0):
            print("DATA_COLLECTOR selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.data_collector_param_list_qt, "SHOW")

            
        elif(self.custom_tb_modules_list.currentRow() == 1):
           
            print("DATA_CHECKER selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.data_checker_param_list_qt, "SHOW")

        elif(self.custom_tb_modules_list.currentRow() == 2):
           
            print("UART selected !")
            self.hide_all_module_param()
            self.tb_custom_module_parameters_show_or_hide(self.uart_param_list_qt, "SHOW")
            
        else:
            print("error !!")


    # ====================================


    # == TOOLS ==
    def tb_custom_module_parameters(self, param_list = [["DATA_COLLECTOR Alias : "     , "TOTO"],
                                                        ["DATA_COLLECTOR Number :"     , "1"],
                                                        ["DATA_COLLECTOR Data Width : ", "32"]]):
        
        qt_param_list = []
        for i in range(0, len(param_list)):
            qt_param_list.append([QtWidgets.QLabel(param_list[i][0]), QtWidgets.QLineEdit(param_list[i][1])])        
        
        return qt_param_list


    def tb_custom_module_parameters_show_or_hide(self, param_list, show_or_hide = "HIDE"):
        for i in param_list:
            for j in i:                
                j.hide() if show_or_hide == "HIDE" else j.show()


    def hide_all_module_param(self):
        self.tb_custom_module_parameters_show_or_hide(self.data_collector_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.data_checker_param_list_qt, "HIDE")
        self.tb_custom_module_parameters_show_or_hide(self.uart_param_list_qt, "HIDE")


    def get_custom_module_info(self, qt_param_list):

        custom_module_info_list = []

        for i in qt_param_list:
            custom_module_info_list.append([i[0].text(), i[1].text()])

        return custom_module_info_list


    def add_info_to_list(self, info_list):
        if(info_list not in self.custom_tb_info_list):
            self.custom_tb_info_list.append(info_list)
            self.tb_info_list.addItem(str(info_list))

    def remove_info_to_list(self, current_info):

        # Get Row of current item
        self.custom_tb_info_list.getItem()
        if(current_info in self.custom_tb_info_list):
            self.custom_tb_info_list.remove(current_info)
                
    # == FILE STR ==
    def clk_gen_generator(self):


        clk_gen_str = """//                              -*- Mode: Verilog -*-"
    // Filename        : clk_gen.sv
    // Description     : Clock generator
    // Author          : {0}
    // Created On      : {1}

    `timescale 1ps/1ps

    module clk_gen
       #(
         parameter int G_CLK_HALF_PERIOD = 10,
         parameter int G_WAIT_RST        = 10
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
