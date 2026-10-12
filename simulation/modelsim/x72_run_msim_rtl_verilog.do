transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/janej/Documents/Quartus/ECE2072/project\ 2026 {C:/Users/janej/Documents/Quartus/ECE2072/project 2026/tick_FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/janej/Documents/Quartus/ECE2072/project\ 2026 {C:/Users/janej/Documents/Quartus/ECE2072/project 2026/sign_extender.v}
vlog -vlog01compat -work work +incdir+C:/Users/janej/Documents/Quartus/ECE2072/project\ 2026 {C:/Users/janej/Documents/Quartus/ECE2072/project 2026/components_tb.v}

