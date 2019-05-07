onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group pwm /test/pwm_inst/reset_n
add wave -noupdate -expand -group pwm /test/pwm_inst/clock
add wave -noupdate -expand -group pwm /test/pwm_inst/start
add wave -noupdate -expand -group pwm /test/pwm_inst/en
add wave -noupdate -expand -group pwm -expand /test/pwm_inst/duty_cycle
add wave -noupdate -expand -group pwm /test/pwm_inst/pwm_o
add wave -noupdate -expand -group pwm /test/pwm_inst/start_s
add wave -noupdate -expand -group pwm /test/pwm_inst/start_re
add wave -noupdate -expand -group pwm /test/pwm_inst/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1182194019 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {2520000945 ps}
