# Close any open projects
close_project

# Create a new project
create_project integration_v6 /home/rootmin/Documents/VIVADO_projects/integration_v6 -part xc7z020clg400-1
set_property board_part digilentinc.com:zybo-z7-20:part0:1.2 [current_project]

# Add constraint file
add_files -fileset constrs_1 -norecurse /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/fpga/zybo_z720/constraints.xdc

# Add source files
add_files -norecurse {
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/fpga/zybo_z720/holy_wrapper.v
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/holy_cache.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/control.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/reader.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/packages/axi_if.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/packages/holy_core_pkg.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/regfile.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/external_req_arbitrer.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/alu.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/fpga/zybo_z720/axi_details.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/holy_core.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/signext.sv
    /home/rootmin/Documents/Code/YOUTUBE/HOLY_CORE_COURSE/fpga_edition/src/load_store_decoder.sv
}

# Update compile order
update_compile_order -fileset sources_1

# Create and configure the block design
create_bd_design "design_1"
create_bd_cell -type module -reference holy_wrapper holy_wrapper_0

# Add IP and configure settings
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property CONFIG.GPIO_BOARD_INTERFACE {leds_4bits} [get_bd_cells axi_gpio_0]
endgroup

# Apply board design automation rules
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto"} [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto"} [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/holy_wrapper_0/m_axi} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}} [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface {leds_4bits (4 LEDs)} Manual_Source {Auto}} [get_bd_intf_pins axi_gpio_0/GPIO]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/holy_wrapper_0/m_axi} Slave {/axi_gpio_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}} [get_bd_intf_pins axi_gpio_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk {New Clocking Wizard} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}} [get_bd_pins holy_wrapper_0/clk]
endgroup

# Regenerate layout and connect nets
regenerate_bd_layout
delete_bd_objs [get_bd_nets clk_wiz_1_clk_out1] [get_bd_cells clk_wiz_1]
connect_bd_net [get_bd_pins holy_wrapper_0/clk] [get_bd_pins clk_wiz/clk_out1]

# Configure resets and clock interfaces
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Manual_Source {New External Port (ACTIVE_HIGH)}} [get_bd_pins clk_wiz/reset]
set_property name axi_reset [get_bd_ports reset_rtl]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface {sys_clock (System Clock)} Manual_Source {Auto}} [get_bd_pins clk_wiz/clk_in1]
connect_bd_net [get_bd_ports axi_reset] [get_bd_pins holy_wrapper_0/aresetn]
endgroup

# Make pins external
startgroup
make_bd_pins_external [get_bd_pins holy_wrapper_0/rst_n]
set_property name cpu_reset [get_bd_ports rst_n_0]
endgroup

# Add JTAG to AXI IP
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Clk_master {Auto} Clk_slave {/clk_wiz/clk_out1 (100 MHz)} Clk_xbar {/clk_wiz/clk_out1 (100 MHz)} Master {/jtag_axi_0/M_AXI} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {/axi_smc} master_apm {0}} [get_bd_intf_pins jtag_axi_0/M_AXI]
endgroup

# chage clock period
startgroup
set_property -dict [list \
  CONFIG.CLKOUT1_JITTER {143.688} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
] [get_bd_cells clk_wiz]
endgroup


# Save the block design
save_bd_design

# Clean up existing address segments to avoid overlaps
delete_bd_objs [get_bd_addr_segs]

# Define Address Segments
set_property range 8K [get_bd_addr_segs {jtag_axi_0/Data/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 4K [get_bd_addr_segs {jtag_axi_0/Data/SEG_axi_gpio_0_Reg}]
set_property offset 0x00002000 [get_bd_addr_segs {jtag_axi_0/Data/SEG_axi_gpio_0_Reg}]
set_property offset 0x00000000 [get_bd_addr_segs {jtag_axi_0/Data/SEG_axi_bram_ctrl_0_Mem0}]

# Ensure no address conflicts
assign_bd_address

# Resolve polarity mismatch for aresetn
disconnect_bd_net /reset_rtl_1 [get_bd_pins holy_wrapper_0/aresetn]
connect_bd_net [get_bd_pins holy_wrapper_0/aresetn] [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn]

# Add a System ILA for debugging
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
    [get_bd_intf_nets holy_wrapper_0_m_axi] {AXI_R_ADDRESS "Data and Trigger" AXI_R_DATA "Data and Trigger" \
    AXI_W_ADDRESS "Data and Trigger" AXI_W_DATA "Data and Trigger" AXI_W_RESPONSE "Data and Trigger" \
    CLK_SRC "/clk_wiz/clk_out1" SYSTEM_ILA "Auto" APC_EN "0"} \
]

# Set Debug Parameters
set_property -dict [list \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_NUM_OF_PROBES {11} \
] [get_bd_cells system_ila_0]

# Adjust protocol converter settings to match AXI4Lite requirements
startgroup
set_property -dict [list CONFIG.SI_PROTOCOL.VALUE_SRC USER CONFIG.MI_PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_protocol_convert_0]
set_property -dict [list \
    CONFIG.MI_PROTOCOL {AXI4LITE} \
    CONFIG.SI_PROTOCOL {AXI4} \
    CONFIG.TRANSLATION_MODE {2} \
] [get_bd_cells axi_protocol_convert_0]
endgroup

# Validate Design
validate_bd_design

# Generate Wrapper and Outputs
make_wrapper -files [get_files {design_1.bd}] -top
