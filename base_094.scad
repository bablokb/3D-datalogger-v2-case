// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): base of the case (for revision 0.94)
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared_094.scad>
include <pcb.scad>
//include <wall_locks.scad>

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
          pcb(X_PCB_V2, Y_PCB_V2, z, h_screw=BT+H_PCB_V2_SCREW,
              edges=[BACK+RIGHT], screws=!hull);
}

// --- module for LoRa PCB   -------------------------------------------------

module lora_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  move([-XI_BASE/2+X_PCB_LORA/2,YI_BASE/2-Y_PCB_LORA/2,zm])
          pcb(X_PCB_LORA, Y_PCB_LORA, z, edges=[], screws=!hull);
}

// --- module for the battery   ----------------------------------------------

module bat() {
  x = X_BAT + 2*W2;
  y = Y_BAT + 2*W2;
  move([XI_BASE/2-x/2+W2,-YI_BASE/2+y/2,0]) {
    // bat-holder (wall with cutout for cable)
    difference() {
      rect_tube(h=Z_BAT+BT, size=[x,y], wall=W2, anchor=BOTTOM+CENTER);
      move([-x/2,y/2,0]) cuboid([5,5,Z_BAT+BT+FUZZ], anchor=BOTTOM+CENTER);
      move([+X_BAT/2,0,0])
        cuboid([4*W2,y+2*FUZZ,Z_BAT+BT+FUZZ], anchor=BOTTOM+CENTER);
    }
  }
}

// --- final object   -------------------------------------------------------

module base() {
  // plate minus all PCBs
  difference() {
    plate();
    v2_pcb(hull=true);
    lora_pcb(hull=false);
    // cutout for battery
    move([+XI_BASE/2,-YI_BASE/2+Y_BAT/2+W2,BT-FUZZ])
        cuboid([4*W2,Y_BAT,H_BASE+2*FUZZ], anchor=BOTTOM+CENTER);
    // cutout for I2C0 (THT)
    move([XI_BASE/2,Y_PCB_I2C0_OFF,Z_PCB_I2C0_OFF])
      cuboid([4*W_BASE,XY_I2C_THT,Z_I2C_THT], anchor=BOTTOM+CENTER);
  // USB at right-edge (too high to be relevant)
  //move([XO_BASE/2,Y_PCB_USB_OFF,Z_PCB_USB_OFF])
    //cuboid([4*W_BASE,XY_USB,Z_USB], anchor=BOTTOM+CENTER);    
  }
  // add back PCBs
  color("blue") v2_pcb();
  color("red") lora_pcb();
  color("pink") bat();
}

base();
