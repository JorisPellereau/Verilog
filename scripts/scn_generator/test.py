import sys



import generic_tb_cmd_class
import scn_class

# Create SCN Class
generic_cmd_scn_xx = scn_class.scn_class("toto.txt")


# Print SET
generic_cmd_scn_xx.print_line("-- TTOTOTOTOTO\n")
generic_cmd_scn_xx.print_line("-- \n")
                         

for i in range(0, 100):
    generic_cmd_scn_xx.generic_tb_cmd.SET("TOTO", i)

generic_cmd_scn_xx.print_line("-- END OF SIMULATION\n\n")
generic_cmd_scn_xx.END_TEST()
