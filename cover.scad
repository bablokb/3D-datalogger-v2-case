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

Y_TOP_ADD = 5;
Y_TOP   = Y_PCB_V2 + Y_TOP_ADD + 2*W_BASE + GAP;
Z_TOP   = BT;
H_COVER = YO_BASE-Y_TOP;
P_DIFF  = Z_TOP / (H_COVER/(YO_BASE-Y_TOP));

echo("H_COVER        = ", H_COVER);
echo("H_TOTOAL       = ", BT + H_BASE + H_COVER + Z_TOP);
echo("YO_BASE        = ", YO_BASE);
echo("Y_TOP          = ", Y_TOP);
echo("yz-size slanted = ", sqrt((YO_BASE-Y_TOP)^2+H_COVER^2));
echo("angle          = ", atan(H_COVER/(YO_BASE-Y_TOP)));

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
  y_off = Y_TOP/2 - Y_PCB_V2/2 - 2*W_BASE - GAP;
  difference() {
    prismoid(size1=[XO_BASE, Y_TOP],
                 size2=[XO_BASE, Y_TOP-P_DIFF],
                 shift=[0,P_DIFF/2], h=h,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
    move([XI_BASE/2-X_PCB_V2/2,
          y_off,0]) sensor_cutouts(h=h);
  }
  // add screw holes
  move([XI_BASE/2-X_PCB_V2/2,y_off,0])
    xflip_copy() yflip_copy()
      move([-32,-25,-FUZZ]) xrot(180,cp=[0,0,z/2])
         scale(1+FUZZ) screw_pocket(h=z, hull=false);
}

// --- cover   ----------------------------------------------------------------

module cover(ztop=BT) {
  // lower wall
  rect_tube(size=[XO_BASE,YO_BASE], wall=W_BASE, h=H_BASE,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
  // slanted wall
  zmove(H_BASE-FUZZ)
    rect_tube(size1=[XO_BASE,YO_BASE],
            size2=[XO_BASE,Y_TOP],
            shift=[0,(YO_BASE-Y_TOP)/2],
            wall=W_BASE, h=H_COVER,
            rounding=[R_BASE,0,0,R_BASE], anchor=BOTTOM+CENTER);
  // top plate
  move([0,(YO_BASE-Y_TOP)/2,H_COVER+H_BASE-FUZZ]) top_plate(h=ztop);
}

// --- cutouts for the lipo_charger   -----------------------------------------

module lipo_charger_cutout() {
  // USB
  // slider
}

// --- final object   ---------------------------------------------------------

//difference() {
//  cover(ztop=Z_TOP);
//}

top_plate(h=Z_TOP);