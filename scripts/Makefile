#
#	Makefile for Compilation & Simulation with modelsim
#

# Repository Organization
# /(ROOT)
# 	|__ /scripts        => Scripts - Makefile
#	|__ /sources        => Design VHD - V files
#	     |__ /lib_x
#	     |__ /lib_y
#	|__ /tb_sources     => TestBench  files
#	|__ /do_files       => Do Files
#	     |__ /run_files => Run .do
#	     |__ /waves     => Waves .do

# MAKEFILE for MAX7219 Tests

# 
ROOT=$(PWD)/..
WORK_DIR_NAME=TB_WORK
WORK_DIR=$(ROOT)/$(WORK_DIR_NAME)

# == SOURCES DIRECTORY ==
SRC_DIR=$(ROOT)/lib_testbench
TB_SRC_DIR=$(ROOT)/tb_sources

SCRIPTS_DIR=$(ROOT)/scripts
RUN_DO_DIR=$(ROOT)/do_files/run_files
TRANSCRIPTS_DIR=$(ROOT)/transcripts
WLF_DIR=$(ROOT)/WLF

# MODELSIM ALIAS
vsim=/opt/intelFPGA/18.1/modelsim_ase/bin/vsim
vlib=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vlib
vmap=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vmap
vcom=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vcom
vlog=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vlog

# Library List
LIB_1=lib_tb
#LIB_2=lib_2
LIB_TB_TOP=lib_tb_top



# .vhd file compilation
#VCOM1=$(vcom) -nologo -work



# .v file compilation
#VLOG1=$(vlog) -nologo -work



all: 
	@echo ""
	@echo "Makefile for compilation & Simulation with Modelsim"
	@echo ""
	@echo "TB Test & Simulation"
	@echo ""
	@echo "======     PROJECT CONFIGURATION      ======"
	@echo "- Create Work Directory : "
	@echo "make create_dir"
	@echo ""
	@echo "- Clean work repository : "
	@echo "make clean"
	@echo ""
	@echo "- Prepare Modelsim Library :"
	@echo "make libs"
	@echo ""
	@echo "============================================"
	@echo ""
	@echo ""
	@echo "====== SOURCES COMPILATIONS           ======"
	@echo ""
	@echo "- Compile TestBench sources - v files :"
	@echo "make compile_tb_v_src"
	@echo ""
	@echo "- Compile all :"
	@echo "make compile_all"
	@echo ""
	@echo "============================================"
	@echo ""
	@echo ""
	@echo "======     RUN TESTS MAX7219          ======"
	@echo "- Run test : run tb test :"
	@echo "make run_tb_test"
	@echo "============================================"



# == PREPARE PROJECT ==
create_dir:
	cd $(ROOT); \
	mkdir $(WORK_DIR_NAME); \
	mkdir transcripts; \
	mkdir do_files; \
	mkdir WLF;
# ======================


# == CLEAN PROJECT ==
clean:
	cd $(WORK_DIR); \
	rm -rRf *;
# ====================


# == PREPARE MODELSIM LIBRARY ==
prepare_libs:
	cd $(WORK_DIR); \
	$(vlib) ./${LIB_1}; \
	$(vlib) ./$(LIB_TB_TOP);

create_libs:
	cd $(WORK_DIR); \
	$(vmap) $(LIB_TB_TOP) ./$(LIB_1);

libs:  prepare_libs create_libs
#=============================




# =====================


# == V FILES LIST ==
src_v=		$(SRC_DIR)/testbench_setup.sv \
		$(SRC_DIR)/sequencer.sv \
		$(SRC_DIR)/clk_gen.sv \
		$(SRC_DIR)/decoder.sv \
		$(SRC_DIR)/set_injector.sv \
		$(SRC_DIR)/wait_event.sv \
		$(SRC_DIR)/wait_duration.sv \
		$(SRC_DIR)/check_level.sv \
		$(SRC_DIR)/tb_seq_wrapper.sv \
		$(SRC_DIR)/tb_top.sv \
		#$(SRC_DIR)/file_3.v \
		#$(SRC_DIR)/file_4.v

# ==================


# == COMPILES V FILES ==
compile_tb_v_files :
	cd $(WORK_DIR); \
	$(vlog) -work $(LIB_TB_TOP) $(src_v)
# ======================

compile_all: clean libs compile_tb_v_files

# == TEST1 ==
entity_test1=test_max7219_cmd_decod
run_test1=run_max7219_cmd_decod.do
trans_test1=test_max7219_cmd_decod.txt
wave_test1=wave_test_max7219_cmd_decod
run_tb_test : clean libs compile_tb_v_files
	cd $(WORK_DIR); \
	$(vsim)  +nowarn3116 -novopt -t ps $(LIB_TB_TOP).tb_top -G/tb_top/i_tb_seq_wrapper_0/SCN_FILE_PATH="/home/jorisp/GitHub/Verilog/test.txt";
# ===========
