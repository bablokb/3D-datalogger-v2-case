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

XY_USB = 10;   // USB cutout size (X or Y dimension)
Z_USB  =  6;   // USB cutout size (Z dimension)

XY_I2C =  9;
Z_I2C  =  3.6;

Z_PCB = 1.6;  // all PCBs

X_PCB_V2 = 70;
Y_PCB_V2 = 56;
H_PCB_V2_SCREW = 6;      // hight screw-pocket above BT (base-thickness)

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
Z_PCB_LIPO_SW     = 4;    // measured: 3
H_PCB_LIPO_SCREW  = 3;    // this is actually the default

X_PCB_LIPO_USB_OFF =  0;

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
H_BASE  = 10;
XI_BASE = X_PCB_V2 + 2 + X_PCB_LORA;
XO_BASE = XI_BASE + 4*W_BASE + 2*GAP;
YI_BASE = Y_PCB_V2 + Y_LIPO + 4*W2;
YO_BASE = YI_BASE + 4*W_BASE + 2*GAP;


// cover

H_COVER = 30;
Y_TOP   = YO_BASE - H_COVER;   // will force  angle=45°
Z_TOP   = BT;
P_DIFF  = Z_TOP / (H_COVER/(YO_BASE-Y_TOP));
ANGLE   = atan(H_COVER/(YO_BASE-Y_TOP));

// offsets for USB and I2C
CX_PCB_OFF     = XO_BASE/2 - 2*W_BASE - GAP - X_PCB_V2/2;   // x center offset
CY_PCB_OFF     = YO_BASE/2 - 2*W_BASE - GAP - Y_PCB_V2/2;   // y center offset
Y_PCB_USB_OFF =   CY_PCB_OFF + 0.91;  // from center, right side
Z_PCB_USB_OFF =   H_PCB_V2_SCREW + Z_PCB + 10;

Y_PCB_I2C0_OFF =  CY_PCB_OFF + 0.91;  // from center, right side
Z_PCB_I2C0_OFF =  H_PCB_V2_SCREW + Z_PCB;

X_PCB_I2C1_OFF =  CX_PCB_OFF - 7.86;  // from center, top side
Z_PCB_I2C1_OFF =  Z_PCB_I2C0_OFF;

// I2C on sensor-pcb is centered
// Z-offset calculated from total height (except panel)
Y_SENSOR_I2C1_OFF =  CY_PCB_OFF;
Z_SENSOR_I2C1_OFF =  H_BASE + H_COVER - Z_PCB - Z_I2C;

