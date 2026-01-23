// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared dimensions. 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <screw_pocket.scad>

Z_PCB = 1.6;  // all PCBs

X_PCB_V2 = 70;
Y_PCB_V2 = 56;
H_PCB_V2_SCREW = 6;      // hight screw-pocket above BT (base-thickness)
Y_PCB_USB_OFF =  -0.91;  // from center, right side
X_PCB_I2C_OFF =  -7.86;  // from center, top side
X_PCB_UART_OFF = 28.65;  // from center, top side

X_PCB_LORA = 36.5;
Y_PCB_LORA = 33.0;

X_PCB_LIPO = 23.0;
Y_PCB_LIPO = 35.0;
D_PCB_LIPO =  2.4;   // NPT diameter
O_PCB_LIPO =  2.5;   // NPT offset

X_PCB_LIPO_SW_OFF =  4 - 2*W2; // from left side
Y_PCB_LIPO_SW_OFF =  1.515; //from center, left side
Y_PCB_LIPO_SW     = 10.4;
Z_PCB_LIPO_SW     = Z_PCB + 4;

X_PCB_LIPO_USB_OFF =  0;
X_PCB_LIPO_usb     = 10;

// Lipo holder with screws for cover

X_LIPO = 64;
X_LIPO_OFF = 8;
Y_LIPO = 37;
Z_LIPO =  6;
X_LIPO_SCREW_OFF = 4;
X_LIPO_COVER = X_LIPO+2*W2+2*X_LIPO_SCREW_OFF+DO_25;
Y_LIPO_COVER = 2*DO_25;

// Display holder
X_PCB_DISPLAY = 68.26;
Y_PCB_DISPLAY = 36.4;

// base:
//  - inner dimensions fit PCBs
//  - added wall (W2)
//  - added rim (W2) for wall of top

W_BASE  = W2;
R_BASE  = 3;
H_BASE  = 4;
XI_BASE = X_PCB_V2 + 2 + X_PCB_LORA;
XO_BASE = XI_BASE + 4*W_BASE + 2*GAP;
YI_BASE = Y_PCB_V2 + Y_LIPO + 4*W2;
YO_BASE = YI_BASE + 4*W_BASE + 2*GAP;
