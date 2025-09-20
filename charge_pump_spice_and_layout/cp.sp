**** NVM ***********************************************
.protect
.lib 'cic018.l' TT
.temp 25
.unprotect
.include  'latched_cp.spi'
**.include 'hybrid_cp.spi'
.option
+ probe
+ captab
+ post
+ delmax = 1E-12
+ measform = 2
+ measdgt = 6

**** Voltage sources ***********************************************************
VDD VDD VSS DC = 1.8
VSS VSS GND DC = 0

**** CHARGE PUMP Circuit *******************************************************
XCP clk_a clk_b IN VPP / latched_cp
**XCP IN VPP VSS clk_a clk_b / hybrid_cp
CL  VPP VSS 100p
*IL  VPP VSS DC = 500u

**** Input Signals *************************************************************
VIN IN 0 DC = 1.8
Vclk_a clk_a 0 PULSE(0 1.8 100n 10p 10p 24n 50n)
Vclk_b clk_b 0 PULSE(0 1.8 125n 10p 10p 24n 50n)

**** Simulation ****************************************************************
.tran 5p 50u

**** Probe these signals **************************************************
.probe V(clk_a) V(clk_b) V(VPP) I(IL) I(VDD) I(VIN) I(Vclk_a) I(Vclk_b)

*** Measurement ***
.meas tran maxvpp max V(vpp) from=48u to=50u
.meas tran minvpp min V(vpp) from=48u to=50u
.meas tran avgvpp avg V(vpp) from=48u to=50u
.meas tran vripple param=('maxvpp-minvpp')
.meas tran t_steady when V(vpp) = 10
.meas tran t_steady_r PARAM 't_steady - 100n'

*** Input Power Measurements ***
** transient
.meas TRAN P_VIN     AVG 'V(IN)*I(VIN)' FROM=0 TO='t_steady'
.meas TRAN P_CLK_A   AVG 'V(clk_a)*I(Vclk_a)' FROM=0 TO='t_steady'
.meas TRAN P_CLK_B   AVG 'V(clk_b)*I(Vclk_b)' FROM=0 TO='t_steady'
.meas TRAN P_IN_TOTAL PARAM 'P_VIN + P_CLK_A + P_CLK_B'
** steady
.meas TRAN P_VIN_s     AVG 'V(IN)*I(VIN)' from=48u to=50u
.meas TRAN P_CLK_A_s   AVG 'V(clk_a)*I(Vclk_a)' from=48u to=50u
.meas TRAN P_CLK_B_s   AVG 'V(clk_b)*I(Vclk_b)' from=48u to=50u
.meas TRAN P_IN_s_TOTAL PARAM 'P_VIN_s + P_CLK_A_s + P_CLK_B_s'

*** Output Power Measurement ***
** transient
.meas TRAN P_OUT AVG 'V(VPP)*I(IL)' FROM=0 TO='t_steady'
** steady
.meas TRAN P_OUT_s AVG 'V(VPP)*I(IL)' from=48u to=50u

*** Efficiency Calculation ***
** transient
.meas TRAN EFF PARAM '100 * P_OUT / P_IN_TOTAL'
** steady
.meas TRAN EFF_s PARAM '100 * P_OUT_s / P_IN_s_TOTAL'

.end
