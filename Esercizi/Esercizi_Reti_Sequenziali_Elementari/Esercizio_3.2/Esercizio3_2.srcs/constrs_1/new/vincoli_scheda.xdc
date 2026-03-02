## -----------------------------------------------------------------------------
## File di Vincoli (Constraints) per Nexys A7-50T
## -----------------------------------------------------------------------------

## Clock signal (Segnale di Clock A a 100 MHz)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { A }]; 
# Questa riga dice a Vivado a che velocità viaggia il clock per calcolare i ritardi
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { A }];

## Switches (Usiamo lo switch 0, il primo a destra, per il segnale S1)
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { S1 }]; 

## LEDs (Usiamo il led 0, il primo a destra sopra lo switch, per l'uscita Y)
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { Y }]; 

## Buttons (Usiamo il bottone Centrale BTNC per il segnale di Enable B)
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { B }]; 