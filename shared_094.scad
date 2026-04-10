// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared dimensions for v2 0.94/2.00 version
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <screw_pocket.scad>

XY_USB = 10;   // USB cutout size (X or Y dimension)
Z_USB  =  6;   // USB cutout size (Z dimension)

XY_I2C =  9;
Z_I2C  =  3.6;

XY_I2C_THT = 10.3;
Z_I2C_THT = 5;

Z_PCB = 1.6;  // all PCBs

X_PCB_V2 = 60;
Y_PCB_V2 = 46;
H_PCB_V2_SCREW = 6;      // hight screw-pocket above BT (base-thickness)

X_PCB_LORA = 36.5;
Y_PCB_LORA = 33.0;

// Bat holder

X_BAT = 64;
Y_BAT = 28.5;
Z_BAT = 15;

// Display holder
X_PCB_DISPLAY = 68.26;
Y_PCB_DISPLAY = 36.4;

// base:
//  - inner dimensions fit PCBs
//  - added wall (W2)
//  - added rim (W2) for wall of top

W_BASE  = W2;
R_BASE  = 3;
H_BASE  = 10;
XI_BASE = X_PCB_V2 + 2 + X_PCB_LORA;
XO_BASE = XI_BASE + 4*W_BASE + 2*GAP;
YI_BASE = Y_PCB_V2 + Y_BAT + 4*W2;
YO_BASE = YI_BASE + 4*W_BASE + 2*GAP;

// cover

H_COVER = 30;
Y_TOP   = YO_BASE - H_COVER;   // will force  angle=45°
Z_TOP   = BT;
P_DIFF  = Z_TOP / (H_COVER/(YO_BASE-Y_TOP));
ANGLE   = atan(H_COVER/(YO_BASE-Y_TOP));

// offsets for USB and I2C
// center (offset) of pcb in case
C_PCB_OFF     = YO_BASE/2 - 2*W_BASE - GAP - Y_PCB_V2/2;
Y_PCB_USB_OFF =   C_PCB_OFF + 5.91;  // from center, right side
Z_PCB_USB_OFF =   H_PCB_V2_SCREW + Z_PCB + 13.8;

Y_PCB_I2C0_OFF =  C_PCB_OFF + 6.14;  // from center, right side
Z_PCB_I2C0_OFF =  BT + H_PCB_V2_SCREW - Z_I2C_THT;

// I2C on sensor-pcb is centered
// Z-offset calculated from total height (except panel)
Y_SENSOR_I2C1_OFF =  C_PCB_OFF;
Z_SENSOR_I2C1_OFF =  H_BASE + H_COVER - Z_PCB - Z_I2C;
