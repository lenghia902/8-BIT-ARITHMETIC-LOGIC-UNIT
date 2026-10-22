# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.12-s068_1 on Sat Jan 31 15:38:51 +07 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design ALU

create_clock -name "vclk" -period 0.5 -waveform {0.0 0.25} 
group_path -weight 1.000000 -name in2out -from [list \
  [get_ports {in_a[7]}]  \
  [get_ports {in_a[6]}]  \
  [get_ports {in_a[5]}]  \
  [get_ports {in_a[4]}]  \
  [get_ports {in_a[3]}]  \
  [get_ports {in_a[2]}]  \
  [get_ports {in_a[1]}]  \
  [get_ports {in_a[0]}]  \
  [get_ports {in_b[7]}]  \
  [get_ports {in_b[6]}]  \
  [get_ports {in_b[5]}]  \
  [get_ports {in_b[4]}]  \
  [get_ports {in_b[3]}]  \
  [get_ports {in_b[2]}]  \
  [get_ports {in_b[1]}]  \
  [get_ports {in_b[0]}]  \
  [get_ports input_carry]  \
  [get_ports {alu_opcode[3]}]  \
  [get_ports {alu_opcode[2]}]  \
  [get_ports {alu_opcode[1]}]  \
  [get_ports {alu_opcode[0]}] ] -to [list \
  [get_ports {alu_out[7]}]  \
  [get_ports {alu_out[6]}]  \
  [get_ports {alu_out[5]}]  \
  [get_ports {alu_out[4]}]  \
  [get_ports {alu_out[3]}]  \
  [get_ports {alu_out[2]}]  \
  [get_ports {alu_out[1]}]  \
  [get_ports {alu_out[0]}]  \
  [get_ports {alu_out_flag[4]}]  \
  [get_ports {alu_out_flag[3]}]  \
  [get_ports {alu_out_flag[2]}]  \
  [get_ports {alu_out_flag[1]}]  \
  [get_ports {alu_out_flag[0]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[7]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[6]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[5]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[4]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[3]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[2]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[1]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_a[0]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[7]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[6]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[5]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[4]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[3]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[2]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[1]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {in_b[0]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports input_carry]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_opcode[3]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_opcode[2]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_opcode[1]}]
set_input_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_opcode[0]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[7]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[6]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[5]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[4]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[3]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[2]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[1]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out[0]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out_flag[4]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out_flag[3]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out_flag[2]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out_flag[1]}]
set_output_delay -clock [get_clocks vclk] -add_delay 0.1 [get_ports {alu_out_flag[0]}]
set_max_fanout 15.000 [current_design]
set_max_transition 0.05 [get_clocks vclk]
set_max_capacitance 8.0 [current_design]
set_wire_load_mode "segmented"
