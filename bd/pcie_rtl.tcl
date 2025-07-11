
##############
# RTL
##############

create_bd_cell -type module -reference axi_const_rd axi_const_rd
set_property -dict [list \
  CONFIG.DATA_WIDTH {128} \
  CONFIG.ADDR_WIDTH {64} \
  CONFIG.CONST_DATA {0xbeefcafe} \
] [get_bd_cells axi_const_rd]


make_bd_intf_pins_external [get_bd_intf_pins axi_const_rd/s_axi]

set s_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 300000000 s_axi_aclk ]
set_property -dict [ list \
  CONFIG.ASSOCIATED_BUSIF {s_axi} \
] $s_axi_aclk
create_bd_port -dir I -type rst s_axi_aresetn

connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_const_rd/axi_clk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_const_rd/axi_resetn]

# Dummy ports for Vitis

create_bd_port -dir O -type intr interrupt

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

set m_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 300000000 m_axi_aclk ]
set_property -dict [ list \
  CONFIG.ASSOCIATED_BUSIF {m_axi} \
  CONFIG.ASSOCIATED_RESET {m_axi_aresetn} \
] $m_axi_aclk
create_bd_port -dir I -type rst m_axi_aresetn
