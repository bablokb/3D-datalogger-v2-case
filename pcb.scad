// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): generic PCB.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <screw_pocket.scad>

// --- generic module to create space for a PCB   ----------------------------

module pcb(x, y, z=BT, h_screw=3, o_screw=3, r=3, edges="Z", screws=true) {
  difference() {
    // solid space
    cuboid([x,y,z], rounding=r, edges=edges, anchor=BOTTOM+CENTER);
    // mask screw-pockets
    if (screws) {
      xflip_copy()
        yflip_copy() move([-x/2+o_screw,-y/2+o_screw,-FUZZ])
          screw_pocket(h=h_screw, hull=true);
    }
  }
  // add screw-pockets
  if (screws) {
    xflip_copy()
      yflip_copy() move([-x/2+o_screw,-y/2+o_screw,-FUZZ])
        screw_pocket(h=h_screw, hull=false);
  }
}

