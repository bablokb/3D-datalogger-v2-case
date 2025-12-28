// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic screw-pocket. Print with supports.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

// defaults for M2.5

DI_25 = 4.28;           // inner diameter
DO_25 = DI_25 + 2*w2;   // outer diameter
DS_25 = 2.7;            // screw-hole diameter

// the defaults give a screw-pocket with three layers and outer diameter of 6mm

module screw_pocket(h=0, bh=0.6, do=DO_25, di=DI_25, ds=DS_25, hull=false) {
  difference() {
    // outer cylinder
    cylinder(d=do, h=h,anchor=BOTTOM+CENTER);
    if (!hull) {
      // inner cylinder
      zmove(-fuzz) cylinder(d=di, h=h-bh,anchor=BOTTOM+CENTER);
      // screw-hole
      cylinder(d=ds, h=h+fuzz,anchor=BOTTOM+CENTER);
    }
  }
}

//screw_pocket(h=10, hull=false);