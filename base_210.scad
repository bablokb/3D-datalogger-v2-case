// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): base of the case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared_210.scad>
include <pcb.scad>

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

// --- module for LiPo PCB   -------------------------------------------------

module lipo_charger_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  move([X_PCB_LIPO_SW_OFF-XI_BASE/2+X_PCB_LIPO/2,
        -YI_BASE/2+Y_PCB_LIPO/2,zm]) {
          pcb(X_PCB_LIPO, Y_PCB_LIPO, z,
              h_screw=H_PCB_LIPO_SCREW,
              o_screw=O_PCB_LIPO,
              edges=[], screws=!hull);
          if (hull) {
            // cutout switch
            move([-X_PCB_LIPO/2,Y_PCB_LIPO_SW_OFF,
                                         H_PCB_LIPO_SCREW+Z_PCB-GAP])
              cuboid([20,Y_PCB_LIPO_SW,GAP+Z_PCB_LIPO_SW],
                anchor=BOTTOM+CENTER);
            // cutout USB
            move([X_PCB_LIPO_USB_OFF,-Y_PCB_LIPO/2,
                                        H_PCB_LIPO_SCREW])
              cuboid([XY_USB,20,Z_PCB+Z_USB],
                anchor=BOTTOM+CENTER);
          }
        }
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

// --- cutouts for USB and I2C of PCB   ---------------------------------------

module pcb_cutouts() {
  // I2C1 at back-edge
  move([X_PCB_I2C1_OFF,YI_BASE/2,Z_PCB_I2C1_OFF+BT])
    cuboid([XY_I2C,4*W_BASE,Z_I2C], anchor=BOTTOM+CENTER);
  // I2C0 at right-edge
  move([XI_BASE/2,Y_PCB_I2C0_OFF,Z_PCB_I2C0_OFF+BT])
    cuboid([4*W_BASE,XY_I2C,Z_I2C], anchor=BOTTOM+CENTER);
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
    // remove cutouts
    pcb_cutouts();
  }
  // add back PCBs
  color("blue") v2_pcb();
  color("red") lora_pcb();
  color("green") lipo_charger_pcb();
  color("pink") lipo();
}

base();
