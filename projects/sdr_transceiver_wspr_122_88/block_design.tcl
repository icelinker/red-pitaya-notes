# Create clk_wiz
cell xilinx.com:ip:clk_wiz pll_0 {
  PRIMITIVE PLL
  PRIM_IN_FREQ.VALUE_SRC USER
  PRIM_IN_FREQ 122.88
  PRIM_SOURCE Differential_clock_capable_pin
  CLKOUT1_USED true
  CLKOUT1_REQUESTED_OUT_FREQ 122.88
  CLKOUT2_USED true
  CLKOUT2_REQUESTED_OUT_FREQ 245.76
  CLKOUT2_REQUESTED_PHASE -112.5
  CLKOUT3_USED true
  CLKOUT3_REQUESTED_OUT_FREQ 245.76
  CLKOUT3_REQUESTED_PHASE -67.5
  USE_RESET false
} {
  clk_in1_p adc_clk_p_i
  clk_in1_n adc_clk_n_i
}

# Create processing_system7
cell xilinx.com:ip:processing_system7 ps_0 {
  PCW_IMPORT_BOARD_PRESET cfg/red_pitaya.xml
} {
  M_AXI_GP0_ACLK pll_0/clk_out1
}

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
  make_external {FIXED_IO, DDR}
  Master Disable
  Slave Disable
} [get_bd_cells ps_0]

# Create xlconstant
cell xilinx.com:ip:xlconstant const_0

# Create proc_sys_reset
cell xilinx.com:ip:proc_sys_reset rst_0 {} {
  ext_reset_in const_0/dout
}

# ADC

# Create axis_red_pitaya_adc
cell pavel-demin:user:axis_red_pitaya_adc adc_0 {
  ADC_DATA_WIDTH 16
} {
  aclk pll_0/clk_out1
  adc_dat_a adc_dat_a_i
  adc_dat_b adc_dat_b_i
  adc_csn adc_csn_o
}

# DAC

# Create axis_red_pitaya_dac
cell pavel-demin:user:axis_red_pitaya_dac dac_0 {
  DAC_DATA_WIDTH 14
} {
  aclk pll_0/clk_out1
  ddr_clk pll_0/clk_out2
  wrt_clk pll_0/clk_out3
  locked pll_0/locked
  dac_clk dac_clk_o
  dac_rst dac_rst_o
  dac_sel dac_sel_o
  dac_wrt dac_wrt_o
  dac_dat dac_dat_o
}

# CFG

# Create axi_cfg_register
cell pavel-demin:user:axi_cfg_register cfg_0 {
  CFG_DATA_WIDTH 608
  AXI_ADDR_WIDTH 32
  AXI_DATA_WIDTH 32
}

# GPIO

# Delete input/output port
delete_bd_objs [get_bd_ports exp_p_tri_io]

# Create output port
create_bd_port -dir O -from 7 -to 0 exp_p_tri_io

# Create port_slicer
cell pavel-demin:user:port_slicer out_slice_0 {
  DIN_WIDTH 608 DIN_FROM 23 DIN_TO 16
} {
  din cfg_0/cfg_data
  dout exp_p_tri_io
}

# Delete input/output port
delete_bd_objs [get_bd_ports exp_n_tri_io]

# Create input port
create_bd_port -dir I -from 3 -to 0 exp_n_tri_io

# Create port_slicer
cell pavel-demin:user:port_slicer pps_slice_0 {
  DIN_WIDTH 4 DIN_FROM 3 DIN_TO 3
} {
  din exp_n_tri_io
  dout ps_0/GPIO_I
}

# RX 0

# Create port_slicer
cell pavel-demin:user:port_slicer rst_slice_0 {
  DIN_WIDTH 608 DIN_FROM 7 DIN_TO 0
} {
  din cfg_0/cfg_data
}

# Create port_slicer
cell pavel-demin:user:port_slicer cfg_slice_0 {
  DIN_WIDTH 608 DIN_FROM 575 DIN_TO 32
} {
  din cfg_0/cfg_data
}

module rx_0 {
  source projects/sdr_transceiver_wspr_122_88/rx.tcl
} {
  slice_0/din rst_slice_0/dout
  slice_1/din cfg_slice_0/dout
  slice_2/din cfg_slice_0/dout
  slice_3/din cfg_slice_0/dout
  slice_4/din cfg_slice_0/dout
  slice_5/din cfg_slice_0/dout
  slice_6/din cfg_slice_0/dout
  slice_7/din cfg_slice_0/dout
  slice_8/din cfg_slice_0/dout
  slice_9/din cfg_slice_0/dout
  slice_10/din cfg_slice_0/dout
  slice_11/din cfg_slice_0/dout
  slice_12/din cfg_slice_0/dout
  slice_13/din cfg_slice_0/dout
  slice_14/din cfg_slice_0/dout
  slice_15/din cfg_slice_0/dout
  slice_16/din cfg_slice_0/dout
  slice_17/din cfg_slice_0/dout
  slice_18/din cfg_slice_0/dout
  slice_19/din cfg_slice_0/dout
  slice_20/din cfg_slice_0/dout
  slice_21/din cfg_slice_0/dout
  slice_22/din cfg_slice_0/dout
  slice_23/din cfg_slice_0/dout
  slice_24/din cfg_slice_0/dout
  slice_25/din cfg_slice_0/dout
  slice_26/din cfg_slice_0/dout
  slice_27/din cfg_slice_0/dout
  slice_28/din cfg_slice_0/dout
  slice_29/din cfg_slice_0/dout
  slice_30/din cfg_slice_0/dout
  slice_31/din cfg_slice_0/dout
  slice_32/din cfg_slice_0/dout
}

# TX 0

# Create port_slicer
cell pavel-demin:user:port_slicer rst_slice_1 {
  DIN_WIDTH 608 DIN_FROM 15 DIN_TO 8
} {
  din cfg_0/cfg_data
}

# Create port_slicer
cell pavel-demin:user:port_slicer cfg_slice_1 {
  DIN_WIDTH 608 DIN_FROM 607 DIN_TO 576
} {
  din cfg_0/cfg_data
}

module tx_0 {
  source projects/sdr_transceiver_wspr_122_88/tx.tcl
} {
  slice_0/din rst_slice_1/dout
  slice_1/din cfg_slice_1/dout
  slice_2/din cfg_slice_1/dout
  zeroer_0/M_AXIS dac_0/S_AXIS
}

# PPS

# Create port_slicer
cell pavel-demin:user:port_slicer rst_slice_2 {
  DIN_WIDTH 608 DIN_FROM 24 DIN_TO 24
} {
  din cfg_0/cfg_data
}

# Create axis_pps_counter
cell pavel-demin:user:axis_pps_counter cntr_0 {} {
  pps_data pps_slice_0/dout
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# Create axis_data_fifo
cell xilinx.com:ip:axis_data_fifo fifo_0 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 4
  FIFO_DEPTH 1024
  HAS_RD_DATA_COUNT true
} {
  S_AXIS cntr_0/M_AXIS
  s_axis_aclk pll_0/clk_out1
  s_axis_aresetn rst_slice_2/dout
}

# Create axi_axis_reader
cell pavel-demin:user:axi_axis_reader reader_0 {
  AXI_DATA_WIDTH 32
} {
  S_AXIS fifo_0/M_AXIS
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# STS

# Create dna_reader
cell pavel-demin:user:dna_reader dna_0 {} {
  aclk pll_0/clk_out1
  aresetn rst_0/peripheral_aresetn
}

# Create xlconcat
cell xilinx.com:ip:xlconcat concat_0 {
  NUM_PORTS 19
  IN0_WIDTH 32
  IN1_WIDTH 64
  IN2_WIDTH 16
  IN3_WIDTH 16
  IN4_WIDTH 16
  IN5_WIDTH 16
  IN6_WIDTH 16
  IN7_WIDTH 16
  IN8_WIDTH 16
  IN9_WIDTH 16
  IN10_WIDTH 16
  IN11_WIDTH 16
  IN12_WIDTH 16
  IN13_WIDTH 16
  IN14_WIDTH 16
  IN15_WIDTH 16
  IN16_WIDTH 16
  IN17_WIDTH 16
  IN18_WIDTH 16
} {
  In0 const_0/dout
  In1 dna_0/dna_data
  In2 rx_0/fifo_generator_0/rd_data_count
  In3 rx_0/fifo_generator_1/rd_data_count
  In4 rx_0/fifo_generator_2/rd_data_count
  In5 rx_0/fifo_generator_3/rd_data_count
  In6 rx_0/fifo_generator_4/rd_data_count
  In7 rx_0/fifo_generator_5/rd_data_count
  In8 rx_0/fifo_generator_6/rd_data_count
  In9 rx_0/fifo_generator_7/rd_data_count
  In10 rx_0/fifo_generator_8/rd_data_count
  In11 rx_0/fifo_generator_9/rd_data_count
  In12 rx_0/fifo_generator_10/rd_data_count
  In13 rx_0/fifo_generator_11/rd_data_count
  In14 rx_0/fifo_generator_12/rd_data_count
  In15 rx_0/fifo_generator_13/rd_data_count
  In16 rx_0/fifo_generator_14/rd_data_count
  In17 rx_0/fifo_generator_15/rd_data_count
  In18 fifo_0/axis_rd_data_count
}

# Create axi_sts_register
cell pavel-demin:user:axi_sts_register sts_0 {
  STS_DATA_WIDTH 384
  AXI_ADDR_WIDTH 32
  AXI_DATA_WIDTH 32
} {
  sts_data concat_0/dout
}

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
  Master /ps_0/M_AXI_GP0
  Clk Auto
} [get_bd_intf_pins sts_0/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_sts_0_reg0]
set_property OFFSET 0x40000000 [get_bd_addr_segs ps_0/Data/SEG_sts_0_reg0]

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
  Master /ps_0/M_AXI_GP0
  Clk Auto
} [get_bd_intf_pins cfg_0/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_cfg_0_reg0]
set_property OFFSET 0x40001000 [get_bd_addr_segs ps_0/Data/SEG_cfg_0_reg0]

for {set i 0} {$i <= 15} {incr i} {

  # Create all required interconnections
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
    Master /ps_0/M_AXI_GP0
    Clk Auto
  } [get_bd_intf_pins rx_0/reader_$i/S_AXI]

  set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_reader_${i}_reg0]
  set_property OFFSET 0x400[format %02X [expr $i + 2]]000 [get_bd_addr_segs ps_0/Data/SEG_reader_${i}_reg0]

}

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
  Master /ps_0/M_AXI_GP0
  Clk Auto
} [get_bd_intf_pins tx_0/writer_0/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_writer_0_reg0]
set_property OFFSET 0x40012000 [get_bd_addr_segs ps_0/Data/SEG_writer_0_reg0]

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
  Master /ps_0/M_AXI_GP0
  Clk Auto
} [get_bd_intf_pins reader_0/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_reader_0_reg01]
set_property OFFSET 0x40013000 [get_bd_addr_segs ps_0/Data/SEG_reader_0_reg01]
