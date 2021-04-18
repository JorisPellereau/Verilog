onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/clk
add wave -noupdate /tb_top/rst_n
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/clk
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/rst_n
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/i_wait_en
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/i_sel_wtr_wtf
add wave -noupdate -group {WAIT EVENT TB} -radix hexadecimal /tb_top/i_wait_event_wrapper/i_wait_event_tb/i_max_timeout
add wave -noupdate -group {WAIT EVENT TB} -expand /tb_top/i_wait_event_wrapper/i_wait_event_tb/i_wait
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/o_wait_done
add wave -noupdate -group {WAIT EVENT TB} -radix hexadecimal /tb_top/i_wait_event_wrapper/i_wait_event_tb/s_timeout_cnt
add wave -noupdate -group {WAIT EVENT TB} /tb_top/i_wait_event_wrapper/i_wait_event_tb/s_timeout_done
add wave -noupdate -group {SET INJECTOR TB} /tb_top/i_set_injector_wrapper/i_set_injector_tb/clk
add wave -noupdate -group {SET INJECTOR TB} /tb_top/i_set_injector_wrapper/i_set_injector_tb/rst_n
add wave -noupdate -group {SET INJECTOR TB} -radix hexadecimal -childformat {{{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[0]} -radix hexadecimal} {{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[1]} -radix hexadecimal} {{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[2]} -radix hexadecimal} {{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[3]} -radix hexadecimal} {{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[4]} -radix hexadecimal}} -expand -subitemconfig {{/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[0]} {-height 16 -radix hexadecimal} {/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[1]} {-height 16 -radix hexadecimal} {/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[2]} {-height 16 -radix hexadecimal} {/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[3]} {-height 16 -radix hexadecimal} {/tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch[4]} {-height 16 -radix hexadecimal}} /tb_top/i_set_injector_wrapper/i_set_injector_tb/i_set_signals_asynch
add wave -noupdate -radix hexadecimal /tb_top/i0
add wave -noupdate -radix hexadecimal /tb_top/i1
add wave -noupdate -radix hexadecimal /tb_top/i2
add wave -noupdate -radix hexadecimal /tb_top/i3
add wave -noupdate -radix hexadecimal /tb_top/i4
add wave -noupdate /tb_top/s_check_level_if/check_alias
add wave -noupdate -radix hexadecimal -childformat {{{/tb_top/s_check_level_if/check_signals[0]} -radix hexadecimal} {{/tb_top/s_check_level_if/check_signals[1]} -radix hexadecimal} {{/tb_top/s_check_level_if/check_signals[2]} -radix hexadecimal} {{/tb_top/s_check_level_if/check_signals[3]} -radix hexadecimal} {{/tb_top/s_check_level_if/check_signals[4]} -radix hexadecimal}} -subitemconfig {{/tb_top/s_check_level_if/check_signals[0]} {-height 16 -radix hexadecimal} {/tb_top/s_check_level_if/check_signals[1]} {-height 16 -radix hexadecimal} {/tb_top/s_check_level_if/check_signals[2]} {-height 16 -radix hexadecimal} {/tb_top/s_check_level_if/check_signals[3]} {-height 16 -radix hexadecimal} {/tb_top/s_check_level_if/check_signals[4]} {-height 16 -radix hexadecimal}} /tb_top/s_check_level_if/check_signals
add wave -noupdate /tb_top/i_uart_checker_wrapper/uart_checker_if/clk
add wave -noupdate /tb_top/i_uart_checker_wrapper/uart_checker_if/start_tx
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/reset_n}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/clock}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/start_tx}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_data}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_done}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_fsm}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/latch_done_s}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/start_tx_s}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/start_tx_r_edge}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_data_s}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_s}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/cnt_bit_duration}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tick_data}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/cnt_data}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/cnt_bit}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/cnt_stop_bit}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/tx_done_s}
add wave -noupdate -expand -group {TX UART CHECKER 0} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[0]/parity_value}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/reset_n}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/clock}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/start_tx}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_data}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_done}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_fsm}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/latch_done_s}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/start_tx_s}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/start_tx_r_edge}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_data_s}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_s}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/cnt_bit_duration}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tick_data}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/cnt_data}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/cnt_bit}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/cnt_stop_bit}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/tx_done_s}
add wave -noupdate -expand -group {TX UART CHECKER 1} {/tb_top/i_uart_checker_wrapper/i_tx_uart_checker[1]/parity_value}
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/clk
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/G_NB_UART_CHECKER
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/G_DATA_WIDTH
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/clk
add wave -noupdate -expand -group {UART I/F} -expand /tb_top/i_uart_checker_wrapper/uart_checker_if/start_tx
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/tx_data
add wave -noupdate -expand -group {UART I/F} {/tb_top/i_uart_checker_wrapper/uart_checker_if/tx_data[1]}
add wave -noupdate -expand -group {UART I/F} {/tb_top/i_uart_checker_wrapper/uart_checker_if/tx_data[0]}
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/tx_done
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/rx_data
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/rx_done
add wave -noupdate -expand -group {UART I/F} /tb_top/i_uart_checker_wrapper/uart_checker_if/parity_rcvd
add wave -noupdate /tb_top/command_exist
add wave -noupdate /tb_top/uart_alias
add wave -noupdate /tb_top/uart_cmd
add wave -noupdate /tb_top/uart_cmd_args
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 6} {3144151000 ps} 1} {{Cursor 2} {22851800 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 213
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {115524150 ps}
