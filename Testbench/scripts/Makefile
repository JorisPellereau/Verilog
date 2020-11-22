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

# MAKEFILE for TESTBENCH TEST

# 
ROOT=$(PWD)/..
WORK_DIR_NAME=TB_WORK
WORK_DIR=$(ROOT)/$(WORK_DIR_NAME)

# == SOURCES DIRECTORY ==
SRC_DIR=$(ROOT)/../lib_testbench

SCRIPTS_DIR=$(ROOT)/scripts
RUN_DO_DIR=$(ROOT)/do_files/run_files
TRANSCRIPTS_DIR=$(ROOT)/transcripts
WLF_DIR=$(ROOT)/WLF
SCN_DIR=$(ROOT)/scenarios

# MODELSIM ALIAS
vsim=/opt/intelFPGA/18.1/modelsim_ase/bin/vsim
vlib=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vlib
vmap=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vmap
vcom=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vcom
vlog=/opt/intelFPGA/18.1/modelsim_ase/linuxaloem/vlog

# Library List
LIB_TESTBENCH=lib_tb
LIB_TB_TOP=lib_tb_top




# == VSIM ARGS ==
VSIM_ARGS+=-novopt -t ps
VSIM_ARGS+=+nowarn3116
VSIM_G_ARGS+=-G/tb_top/SCN_FILE_PATH=$(SCN_DIR)/
# ===============


all: 
	@echo ""
	@echo "Makefile for compilation & Simulation with Modelsim"
	@echo ""
	@echo "TB Test & Simulation"
	@echo ""
	@echo "== PROJECT CONFIGURATION =="
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
	@echo "== TESTBENCH SOURCES COMPILATIONS =="
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
	@echo "== RUN TEST TESTBENCH =="
	@echo "- Run TB test :"
	@echo "make run_tb_test TEST=[TEST_NAME]"
	@echo "========================"



# == PREPARE PROJECT ==
create_dir:
	cd $(ROOT); \
	mkdir $(WORK_DIR_NAME); \
	mkdir transcripts; \
	mkdir do_files; \
	mkdir WLF;
	mkdir scenarios; \
	cd ./do_files; \
	mkdir run_files; \
	mkdir waves; \
# ======================


# == CLEAN PROJECT ==
clean:
	cd $(WORK_DIR); \
	rm -rRf *;
# ====================


# == PREPARE MODELSIM LIBRARY ==
prepare_libs:
	cd $(WORK_DIR); \
	$(vlib) ./${LIB_TESTBENCH}; \
	$(vlib) ./$(LIB_TB_TOP);

create_libs:
	cd $(WORK_DIR); \
	$(vmap) $(LIB_TB_TOP) ./$(LIB_TESTBENCH);

libs:  prepare_libs create_libs
#=============================




# =====================


# == V FILES LIST ==
src_v+=$(SRC_DIR)/testbench_setup.sv
src_v+=$(SRC_DIR)/clk_gen.sv
src_v+=$(SRC_DIR)/wait_event_tb.sv
src_v+=$(SRC_DIR)/wait_event_wrapper.sv
src_v+=$(SRC_DIR)/set_injector_tb.sv
src_v+=$(SRC_DIR)/set_injector_wrapper.sv
src_v+=$(SRC_DIR)/wait_duration_wrapper.sv
src_v+=$(SRC_DIR)/check_level_wrapper.sv
src_v+=$(SRC_DIR)/tb_tasks.sv
src_v+=$(SRC_DIR)/tb_top.sv


# ==================


# == COMPILES V FILES ==
compile_tb_v_files :
	cd $(WORK_DIR); \
	$(foreach list, $(src_v), $(vlog) -work $(LIB_TESTBENCH) $(list);)

# ======================

compile_all: clean libs compile_tb_v_files

# == RUN TESTBENCH TEST ==
run_tb_test : clean libs compile_tb_v_files
	cd $(WORK_DIR); \
	$(vsim) $(VSIM_ARGS) -l $(TRANSCRIPTS_DIR)/$(TEST)_transcript.txt $(LIB_TB_TOP).tb_top $(VSIM_G_ARGS)$(TEST).txt -do $(RUN_DO_DIR)/$(TEST)_run.do;
# ========================

