// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): A mask for 2x20 pins.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

Y_DELTA_PINS = 7*2.54/2;
D_PINS = 1.4;

// --- use this to mask pins in other objects   ------------------------------

module pico_pin_mask(z=10) {
  yflip_copy()
    xflip_copy()
      for (i=[0:9]) {
        move([1.27+i*2.54,Y_DELTA_PINS,0]) cyl(h=z, d=D_PINS, anchor=CENTER);
      }
}

//difference() {
//  cuboid([68.26,36.4,0.6], anchor=BOTTOM+CENTER);
//  pico_pin_mask();
//}
