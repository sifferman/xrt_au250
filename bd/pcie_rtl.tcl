
##############
# RTL
##############

create_bd_cell -type module -reference axi_const_rd axi_const_rd
set_property -dict [list \
  CONFIG.DATA_WIDTH {128} \
  CONFIG.ADDR_WIDTH {64} \
  CONFIG.CONST_DATA {0xbeefcafe} \
] [get_bd_cells axi_const_rd]

make_bd_intf_pins_external  [get_bd_intf_pins axi_const_rd/s_axi]
create_bd_port -dir I clk_i
connect_bd_net [get_bd_ports clk_i] [get_bd_pins axi_const_rd/axi_clk]
create_bd_port -dir I -type rst rst_ni
connect_bd_net [get_bd_ports rst_ni] [get_bd_pins axi_const_rd/axi_resetn]
