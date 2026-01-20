// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): base of the case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb.scad>
include <lipo_charger_pcb.scad>

// --- create base-plate to fit all PCBs   -----------------------------------

module plate() {
  cuboid([xo_base,yo_base,b],
          rounding=r_base, edges=[BACK+RIGHT,FRONT+RIGHT], anchor=BOTTOM+CENTER);
  // inner wall
  rect_tube(isize=[xi_base,yi_base], wall=w_base, h=b+h_base,
            rounding=[r_base,0,0,r_base], anchor=BOTTOM+CENTER);
}

// --- module for v2 PCB   ---------------------------------------------------

module v2_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([xi_base/2-x_pcb_v2/2,yi_base/2-y_pcb_v2/2,zm])
          pcb(x_pcb_v2, y_pcb_v2, z, edges=[BACK+RIGHT], screws=!hull);
}

// --- module for LoRa PCB   -------------------------------------------------

module lora_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([-xi_base/2+x_pcb_lora/2,yi_base/2-y_pcb_lora/2,zm])
          pcb(x_pcb_lora, y_pcb_lora, z, edges=[], screws=!hull);
}

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

// --- final object   -------------------------------------------------------

module base() {
  // plate minus all PCBs
  difference() {
    plate();
    v2_pcb(hull=true);
    lora_pcb(hull=true);
    lipo_charger_pcb(hull=true);
    lipo(hull=true);
  }
  // add back PCBs
  color("blue") v2_pcb();
  color("red") lora_pcb();
  color("green") lipo_charger_pcb();
  color("pink") lipo();
}

base();
