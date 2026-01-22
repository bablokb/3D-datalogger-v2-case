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
P_DIFF = 2*b;  // TODO: calculate from angle using h_cover and y

// --- cutouts for the sensor pcb   -------------------------------------------

module sensor_cutouts(h) {
  z = h+2*fuzz;
  // screw holes
  xflip_copy() yflip_copy()
    move([-32,-25,-fuzz]) xrot(180,cp=[0,0,z/2])
       screw_pocket(h=z, hull=true);
  // LED + app-buttons
  move([-15.4,17,-fuzz]) cuboid([29.2,12,z], anchor=BOTTOM+CENTER);
  // on + reset
  move([-23.85,-9.2,-fuzz]) cuboid([11.9,15.2,z], anchor=BOTTOM+CENTER);
  // SCD4x connector
  move([7.45,-0.8,-fuzz]) cuboid([13.6,22.6,z], anchor=BOTTOM+CENTER);
  // AHT20
  move([18.45,14.1,-fuzz]) cuboid([8.5,10.2,z], anchor=BOTTOM+CENTER);
  // PDM
  move([18.45,0.25,-fuzz]) cuboid([8.5,10.1,z], anchor=BOTTOM+CENTER);
  // BH1750
  move([18.45,-12.95,-fuzz]) cuboid([8.5,10.1,z], anchor=BOTTOM+CENTER);
}

// --- top plate   ------------------------------------------------------------

module top_plate(h=b) {
  z = h+2*fuzz;
  difference() {
      prismoid(size1=[xo_base, y_pcb_v2],
                 size2=[xo_base, y_pcb_v2-P_DIFF],
                 shift=[0,P_DIFF/2], h=b,
            rounding=[r_base,0,0,r_base], anchor=BOTTOM+CENTER);
    xmove(xi_base/2-x_pcb_v2/2)
      sensor_cutouts(h=h);
  }
  // add screw holes
  xmove(xi_base/2-x_pcb_v2/2)
    xflip_copy() yflip_copy()
      move([-32,-25,-fuzz]) xrot(180,cp=[0,0,z/2])
         screw_pocket(h=z, hull=false);
}

// --- cover   ----------------------------------------------------------------

module cover() {
  rect_tube(size=[xo_base,yo_base], wall=w_base, h=h_base,
            rounding=[r_base,0,0,r_base], anchor=BOTTOM+CENTER);
  zmove(h_base-fuzz)
    rect_tube(size1=[xo_base,yo_base],
            size2=[xo_base,y_pcb_v2],
            shift=[0,(yo_base-y_pcb_v2)/2],
            wall=w_base, h=h_cover-b,
            rounding=[r_base,0,0,r_base], anchor=BOTTOM+CENTER);
  zmove(h_cover+h_base-b-fuzz) top_plate();
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