// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): cover (top).
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <shared.scad>
include <screw_pocket.scad>

h_cover = 27;
P_DIFF = 2*BT;  // TODO: calculate from angle using h_cover and y

// --- cutouts for the sensor pcb   -------------------------------------------

module sensor_cutouts(h) {
  z = h+2*FUZZ;
  // screw holes
  xflip_copy() yflip_copy()
    move([-32,-25,-FUZZ]) xrot(180,cp=[0,0,z/2])
       screw_pocket(h=z, hull=true);
  // LED + app-buttons
  move([-15.4,17,-FUZZ]) cuboid([29.2,12,z], anchor=BOTTOM+CENTER);
  // on + reset
  move([-23.85,-9.2,-FUZZ]) cuboid([11.9,15.2,z], anchor=BOTTOM+CENTER);
  // SCD4x connector
  move([7.45,-0.8,-FUZZ]) cuboid([13.6,22.6,z], anchor=BOTTOM+CENTER);
  // AHT20
  move([18.45,14.1,-FUZZ]) cuboid([8.5,10.2,z], anchor=BOTTOM+CENTER);
  // PDM
  move([18.45,0.25,-FUZZ]) cuboid([8.5,10.1,z], anchor=BOTTOM+CENTER);
  // BH1750
  move([18.45,-12.95,-FUZZ]) cuboid([8.5,10.1,z], anchor=BOTTOM+CENTER);
}

// --- top plate   ------------------------------------------------------------

module top_plate(h=BT) {
  z = h+2*FUZZ;
  difference() {
      prismoid(size1=[XO_BASE, Y_PCB_V2],
                 size2=[XO_BASE, Y_PCB_V2-P_DIFF],
                 shift=[0,P_DIFF/2], h=h,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
    xmove(XI_BASE/2-X_PCB_V2/2)
      sensor_cutouts(h=h);
  }
  // add screw holes
  xmove(XI_BASE/2-X_PCB_V2/2)
    xflip_copy() yflip_copy()
      move([-32,-25,-FUZZ]) xrot(180,cp=[0,0,z/2])
         screw_pocket(h=z, hull=false);
}

// --- cover   ----------------------------------------------------------------

module cover() {
  rect_tube(size=[XO_BASE,YO_BASE], wall=W_BASE, h=H_BASE,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
  zmove(H_BASE-FUZZ)
    rect_tube(size1=[XO_BASE,YO_BASE],
            size2=[XO_BASE,Y_PCB_V2],
            shift=[0,(YO_BASE-Y_PCB_V2)/2],
            wall=W_BASE, h=h_cover-BT,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
  zmove(h_cover+H_BASE-BT-FUZZ) top_plate();
}

// --- cutouts for the lipo_charger   -----------------------------------------

module lipo_charger_cutout() {
  // USB
  // slider
}

// --- final object   ---------------------------------------------------------

//difference() {
//  cover();
//}

top_plate();