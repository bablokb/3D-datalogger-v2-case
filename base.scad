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
  cuboid([XO_BASE,YO_BASE,BT],
          rounding=R_BASE, edges=[BACK+RIGHT,FRONT+RIGHT], anchor=BOTTOM+CENTER);
  // inner wall
  rect_tube(isize=[XI_BASE,YI_BASE], wall=W_BASE, h=BT+H_BASE,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
}

// --- module for v2 PCB   ---------------------------------------------------

module v2_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  move([XI_BASE/2-X_PCB_V2/2,YI_BASE/2-Y_PCB_V2/2,zm])
          pcb(X_PCB_V2, Y_PCB_V2, z, edges=[BACK+RIGHT], screws=!hull);
}

// --- module for LoRa PCB   -------------------------------------------------

module lora_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  move([-XI_BASE/2+X_PCB_LORA/2,YI_BASE/2-Y_PCB_LORA/2,zm])
          pcb(X_PCB_LORA, Y_PCB_LORA, z, edges=[], screws=!hull);
}

// --- module for the lipo   -------------------------------------------------

module lipo(hull=false) {
  x = X_LIPO + 2*W2;
  y = Y_LIPO + 2*W2;
  move([XI_BASE/2-x/2-X_LIPO_OFF,-YI_BASE/2+y/2,0]) {
    // lipo-holder (wall with cutout for cable)
    if (!hull) {
      difference() {
        rect_tube(h=Z_LIPO+BT, size=[x,y], wall=W2, anchor=BOTTOM+CENTER);
        move([-x/2,y/2,0]) cuboid([5,5,Z_LIPO+BT+FUZZ], anchor=BOTTOM+CENTER);
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
