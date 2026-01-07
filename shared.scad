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

z_pcb = 1.6;  // all PCBs

x_pcb_v2 = 70;
y_pcb_v2 = 56;
y_pcb_usb_off =  -0.91;  // from center, right side
x_pcb_i2c_off =  -7.86;  // from center, top side
x_pcb_uart_off = 28.65;  // from center, top side

x_pcb_lora = 36.5;
y_pcb_lora = 33.0;

x_pcb_lipo = 23.0;
y_pcb_lipo = 35.0;
d_pcb_lipo =  2.4;   // NPT diameter
o_pcb_lipo =  2.5;   // NPT offset

x_pcb_lipo_sw_off =  4 - 2*w2; // from left side
y_pcb_lipo_sw_off =  1.515; //from center, left side
y_pcb_lipo_sw     = 10.4;
z_pcb_lipo_sw     = z_pcb + 4;

x_pcb_lipo_usb_off =  0;
x_pcb_lipo_usb     = 10;

// Lipo holder with screws for cover

x_lipo = 64;
x_lipo_off = 8;
y_lipo = 37;
z_lipo =  6;
x_lipo_screw_off = 4;
x_lipo_cover = x_lipo+2*w2+2*x_lipo_screw_off+DO_25;
y_lipo_cover = 2*DO_25;

// Display holder
x_pcb_display = 68.26;
y_pcb_display = 36.4;

// base:
//  - inner dimensions fit PCBs
//  - added wall (w2)
//  - added rim (w2) for wall of top

w_base  = w2;
r_base  = 3;
xi_base = x_pcb_v2 + 2 + x_pcb_lora;
xo_base = xi_base + 4*w_base + 2*gap;
yi_base = y_pcb_v2 + y_lipo + 4*w2;
yo_base = yi_base + 4*w_base + 2*gap;;
