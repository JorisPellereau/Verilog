# Verilog
Verilog and SystemVerilog Files

## Testbench
Testbench in SystemVerilog.
Script and scenario for the testbench :
* **doc** : Documentation for the Testbench
* **do_files** : Do files for run and waves
* **scenarios** : Testbench scenarios
* **scripts** : Makefile for Testbench utilization
* **transcripts** : Transcripts output results

> Testbench Architecture :![TB_ARCHI](https://github.com/JorisPellereau/Verilog/blob/master/Testbench/doc/TB_ARCHI.png)

## lib_testbench
Repository with Testbench SV files :

* **testbench_setup.sv** : File with constants for the configuration of TB modules.
* **clk_gen.sv**         : Simple clock generator for DUT and TB modules.
* **wait_event_tb.sv**   : Rising Edge / Falling Edge signal detector.
* **wait_event_wrapper.sv** : Wrapper for the connection between wait_event_tb module and task sequencer via an interface.
* **set_injector_tb.sv** : Signals resynchronizator.
* **set_injector_wrapper.sv** : Wrapper for the connection between, set_injector_tb module a task sequencer via an interface.
* **wait_duration_wrapper.sv** : Wait duration interface for the connection with task sequencer.
* **check_level_wrapper.sv** : Check level interface for the connection with task sequencer.
* **tb_tasks.sv** : A class with Testbench tasks.
* **tb_top.sv** : Testbench TOP module.
