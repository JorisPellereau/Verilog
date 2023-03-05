//`include "/home/linux-jp/Documents/GitHub/Verilog/Testbench/sources/lib_tb_utils/tb_utils_class.sv"

class tb_master_axi4lite_class #(
				 parameter G_NB_MASTER_AXI4LITE  = 2,
				 parameter G_AXI4LITE_ADDR_WIDTH = 32,
				 parameter G_AXI4LITE_DATA_WIDTH = 32
		      );


   /* ===============
    * == VARIABLES ==
    * ===============
    */

   string MASTER_AXI4LITE_COMMAND_TYPE = "MASTER_AXI4LITE"; // Commande Type   
   string MASTER_AXI4LITE_ALIAS;                 // Alias of Current Master AXI4LITE Testbench Module

   // == UTILS ==
//   tb_utils_class utils = new(); // Utils Class   
   // ===========
   
   
   // == VIRTUAL I/F ==
   // DATA_COLLECTOR interface
   virtual master_axi4lite_intf #(G_AXI4LITE_ADDR_WIDTH, G_AXI4LITE_DATA_WIDTH) master_axi4lite_vif;   
   // =================


   // == CONSTRUCTOR ==
   function new(virtual master_axi4lite_intf #(G_AXI4LITE_ADDR_WIDTH, G_AXI4LITE_DATA_WIDTH) master_axi4lite_nif,
		string MASTER_AXI4LITE_ALIAS);
      this.master_axi4lite_vif   = master_axi4lite_nif;
      this.MASTER_AXI4LITE_ALIAS = MASTER_AXI4LITE_ALIAS;      
   endfunction // new   
   // =================


   // == LIST of DATA CHECKER COMMANDS ==
   // MASTER_AXI4LITE[alias] WRITE(DATA, ADDR, RESP)

   // DATA_CHECKER[alias] START(i)

   // DATA_CHECKER[alias] STOP(i)

   // DATA_CHECKER[alias] CLOSE(i)

   // DATA_CHECKER[alias] CONFIG(i, USE_VALID)
   // ===================================


   // List of Command of DATA_CHECKER
   int 		       MASTER_AXI4LITE_CMD_ARRAY [string] = '{
							      "WRITE" : 0,
							      "READ"  : 1
							      };


endclass // tb_master_axi4_class
