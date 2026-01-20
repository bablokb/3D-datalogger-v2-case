// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Holder for LiPo.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

// --- module for the lipo   -------------------------------------------------

module lipo(hull=false) {
  x = x_lipo + 2*w2;
  y = y_lipo + 2*w2;
  move([xi_base/2-x/2-x_lipo_off,-yi_base/2+y/2,0]) {
    // lipo-holder (wall with cutout for cable)
    if (!hull) {
      difference() {
        rect_tube(h=z_lipo+b, size=[x,y], wall=w2, anchor=BOTTOM+CENTER);
        move([-x/2,y/2,0]) cuboid([5,5,z_lipo+b+fuzz], anchor=BOTTOM+CENTER);
      }
    }
  }
}
