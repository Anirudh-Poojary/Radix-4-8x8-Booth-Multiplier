# --- SLOW CORNER SYNTHESIS ---
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib/

# Target the Slow library (Low Voltage, High Temp)
set_db library slow.lib

read_hdl {./booth_mult_8x8_top.v}
elaborate

# Apply constraints (10ns or 5ns period)
read_sdc ./constraints_baseline.sdc

# Synthesis Stages
syn_generic
syn_map
syn_opt

# Naming files with _slow suffix to avoid overwriting baseline
write_hdl > booth_mult_netlist_slow.v
write_sdc > booth_mult_tool_slow.sdc

gui_show

# Generating Reports for the Paper
report_timing > reports/timing_slow.rpt
report_power  > reports/power_slow.rpt
report_area   > reports/area_slow.rpt
report_gates  > reports/gates_slow.rpt
