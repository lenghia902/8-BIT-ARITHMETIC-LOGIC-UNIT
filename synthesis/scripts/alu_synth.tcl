# Genus 21.12 - ALU synthesis flow (reconstructed from genus.log13)
# Chay tu thu muc synthesis/ :  genus -f scripts/alu_synth.tcl
# Luu y: can tu chuan bi thu vien .lib (OSU FreePDK / GPDK045), khong dua len repo.
set_db init_lib_search_path ./LIBS/lib/max
set_db init_hdl_search_path ../rtl
set_db design_process_node 45
set_db design_power_effort high
set_db syn_global_effort high
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db opt_area_recovery true
set_db opt_fix_fanout_load true
set_db opt_area_recovery_setup_target_slack 0.05
set_db opt_all_end_points true

read_libs ./LIBS/lib/max/fast_vdd1v2_basicCells.lib   ;# bo sung them .lib neu can
read_hdl -language v2001 -v ALU.v
elaborate
write_db -all_root_attributes ./outputs/ALU.elaborate.db

update_names -map {{"[" "_"} {"]" ""}} -inst -force
update_names -map {{"[" "_"} {"]" ""}} -port_bus
update_names -map {{"[" "_"} {"]" ""}} -hport_bus
read_sdc ./sdc/ALU_sdc.sdc
report_timing -lint -verbose > ./reports/timing_lint.rpt
check_design -all > ./reports/check_design.rpt
define_cost_group -name in2out -design ALU
path_group -from [all_inputs] -to [all_outputs] -group in2out -name in2out

syn_generic
write_hdl -lec > ./outputs/ALU.generic.v
write_sdc > ./outputs/ALU.generic.sdc
syn_map
write_hdl -lec > ./outputs/ALU.map.v
write_sdc > ./outputs/ALU.map.sdc
syn_opt

report_timing -max_paths 100 > ./reports/report_timing.rpt
report_power > ./reports/report_power.rpt
report_area -detail > ./reports/report_area.rpt   ;# log goc ghi nham vao alu_scripts.tcl
exit
