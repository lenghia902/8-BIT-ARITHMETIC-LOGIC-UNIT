# ============================================================================
# SDC for ALU - Combinational Design
# ============================================================================

# ----------------------------------------------------------------------------
# Kiểm tra xem design đã được load chưa
# ----------------------------------------------------------------------------
if {[sizeof_collection [get_designs ALU]] == 0} {
    puts "ERROR: Design ALU not found. Please load the design first."
    return
}

# ----------------------------------------------------------------------------
# Create Virtual Clock
# ----------------------------------------------------------------------------
create_clock -name vclk -period 0.5 -waveform {0 0.25}

# ----------------------------------------------------------------------------
# Set Input Delay
# ----------------------------------------------------------------------------
if {[sizeof_collection [get_ports in_a*]] > 0} {
    set_input_delay 0.1 -clock vclk [get_ports in_a*]
}

if {[sizeof_collection [get_ports in_b*]] > 0} {
    set_input_delay 0.1 -clock vclk [get_ports in_b*]
}

if {[sizeof_collection [get_ports input_carry]] > 0} {
    set_input_delay 0.1 -clock vclk [get_ports input_carry]
}

if {[sizeof_collection [get_ports alu_opcode*]] > 0} {
    set_input_delay 0.1 -clock vclk [get_ports alu_opcode*]
}

# ----------------------------------------------------------------------------
# Set Output Delay
# ----------------------------------------------------------------------------
if {[sizeof_collection [get_ports alu_out]] > 0} {
    set_output_delay 0.1 -clock vclk [get_ports alu_out]
}

if {[sizeof_collection [get_ports alu_out_flag]] > 0} {
    set_output_delay 0.1 -clock vclk [get_ports alu_out_flag]
}

# ----------------------------------------------------------------------------
# DRV Constraints
# ----------------------------------------------------------------------------
set_max_transition 0.05 [get_clocks vclk]
set_max_capacitance 8.0 [current_design]
set_max_fanout 15 [current_design]

# ============================================================================
# End of SDC
# ============================================================================
