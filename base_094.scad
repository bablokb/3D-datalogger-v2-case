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

// --- cable holder   --------------------------------------------------------

module cable_holder(x,y=1,z=4,w=W2,n=1) {
  ycopies(2*y+4*w,n)
    yflip_copy()
      move([0,y+w/2,0])
        cuboid([x,w,z], anchor=BOTTOM+CENTER);
}

// --- module for the PH2 socket   -------------------------------------------

module ph2() {
  move([+XO_BASE/2-X2_PH2,-YI_BASE/2+Y2_PH2/2+O2_PH2,0]) {
    // smaller part (cable connector). This will create only the walls on the
    // x-axis
    xmove(-X1_PH2/2) difference() {
      cuboid([X1_PH2,Y1_PH2+2*W2,Z1_PH2+BT], anchor=BOTTOM+CENTER);
      zmove(O1_PH2+BT)
        cuboid([X1_PH2+2*W2,Y1_PH2,Z1_PH2+BT-O1_PH2+FUZZ], anchor=BOTTOM+CENTER);
    }
    // larger part (socket)
    xmove(X2_PH2/2) difference() {
      cuboid([X2_PH2,Y2_PH2+2*W2,Z2_PH2+BT], anchor=BOTTOM+CENTER);
      move([W2+FUZZ,0,BT])
        cuboid([X2_PH2+3*W2,Y2_PH2,Z2_PH2+FUZZ], anchor=BOTTOM+CENTER);
    }
    // cable holders
    CABLE_GAP = 1;
    move([-3*X1_PH2,0,0]) cable_holder(X1_PH2,CABLE_GAP,n=3);
    move([-XO_BASE/2,0,0]) cable_holder(X1_PH2,CABLE_GAP,n=3);
    move([-0.75*XO_BASE,0,0]) cable_holder(X1_PH2,CABLE_GAP,n=3);
  }
}

// --- final object   -------------------------------------------------------

module base() {
  // plate minus all PCBs
  difference() {
    plate();
    v2_pcb(hull=true);
    lora_pcb(hull=true);
    // cutout for PH2-socket
    move([+XI_BASE/2,-YI_BASE/2+Y2_PH2/2+O2_PH2,BT-FUZZ])
        cuboid([4*W2,Y2_PH2,Z2_PH2+2*FUZZ], anchor=BOTTOM+CENTER);
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
  color("pink") ph2();
}

base();

// Test: matching cutouts
//include <cover_094.scad>
//color("aqua") zmove(BT) cover_final();

//intersection() {
//  base();
//  move([35,-33,0]) cuboid([40,25,H_BASE], anchor=BOTTOM+CENTER);
//}
