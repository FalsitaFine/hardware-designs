# contraints file (.xdc file) for lab 4
# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
#set_property PACKAGE_PIN V17 [get_ports {a[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[0]}]
#set_property PACKAGE_PIN V16 [get_ports {a[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[1]}]
#set_property PACKAGE_PIN W16 [get_ports {a[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[2]}]
#set_property PACKAGE_PIN W17 [get_ports {a[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[3]}]
#set_property PACKAGE_PIN W15 [get_ports {a[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[4]}]
#set_property PACKAGE_PIN V15 [get_ports {a[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[5]}]
#set_property PACKAGE_PIN W14 [get_ports {a[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[6]}]
#set_property PACKAGE_PIN W13 [get_ports {a[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {a[7]}]

set_property PACKAGE_PIN V2 [get_ports {SW[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[7]}]
set_property PACKAGE_PIN T3 [get_ports {SW[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]
set_property PACKAGE_PIN T2 [get_ports {SW[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
set_property PACKAGE_PIN R3 [get_ports {SW[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
set_property PACKAGE_PIN W2 [get_ports {SW[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
set_property PACKAGE_PIN U1 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property PACKAGE_PIN T1 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN R2 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]







# leds
set_property PACKAGE_PIN U16 [get_ports {q[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[0]}]
set_property PACKAGE_PIN E19 [get_ports {q[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[1]}]
set_property PACKAGE_PIN U19 [get_ports {q[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[2]}]
set_property PACKAGE_PIN V19 [get_ports {q[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[3]}]
set_property PACKAGE_PIN W18 [get_ports {q[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[4]}]
set_property PACKAGE_PIN U15 [get_ports {q[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[5]}]
set_property PACKAGE_PIN U14 [get_ports {q[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[6]}]
set_property PACKAGE_PIN V14 [get_ports {q[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[7]}]

set_property PACKAGE_PIN W7 [get_ports {seg_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[7]}]
set_property PACKAGE_PIN W6 [get_ports {seg_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[6]}]
set_property PACKAGE_PIN U8 [get_ports {seg_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[5]}]
set_property PACKAGE_PIN V8 [get_ports {seg_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[4]}]
set_property PACKAGE_PIN U5 [get_ports {seg_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[3]}]
set_property PACKAGE_PIN V5 [get_ports {seg_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[2]}]
set_property PACKAGE_PIN U7 [get_ports {seg_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[1]}]
set_property PACKAGE_PIN V7 [get_ports {seg_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[0]}]

set_property PACKAGE_PIN W4 [get_ports {anode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]
set_property PACKAGE_PIN V4 [get_ports {anode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]
set_property PACKAGE_PIN U4 [get_ports {anode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
set_property PACKAGE_PIN U2 [get_ports {anode[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]


#Buttons

set_property PACKAGE_PIN W19 [get_ports BNT[0]]
set_property IOSTANDARD LVCMOS33 [get_ports BNT[0]]

set_property PACKAGE_PIN U18 [get_ports BNT[1]]
set_property IOSTANDARD LVCMOS33 [get_ports BNT[1]]

set_property PACKAGE_PIN T17 [get_ports BNT[2]]
set_property IOSTANDARD LVCMOS33 [get_ports BNT[2]]