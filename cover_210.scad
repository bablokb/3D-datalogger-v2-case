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
include <shared_210.scad>
include <screw_pocket.scad>
include <pico_pin_mask.scad>

echo("H_COVER        = ", H_COVER);
echo("H_TOTOAL       = ", BT + H_BASE + H_COVER + Z_TOP);
echo("YO_BASE        = ", YO_BASE);
echo("Y_TOP          = ", Y_TOP);
echo("yz-size slanted = ", sqrt((YO_BASE-Y_TOP)^2+H_COVER^2));
echo("angle          = ", ANGLE);

// --- cutouts for the sensor pcb   -------------------------------------------

module sensor_cutouts(h) {
  z = h+2*FUZZ;
  // screw holes
  xflip_copy() yflip_copy()
    move([-X_PCB_V2/2+3,-Y_PCB_V2/2+3,-FUZZ]) xrot(180,cp=[0,0,z/2])
       screw_pocket(h=z, hull=true);
  // LED + app-buttons
  move([-15.4,17,-FUZZ]) cuboid([29.2,12,z], anchor=BOTTOM+CENTER);
  // on + reset
  move([-23.95,-7.55,-FUZZ]) cuboid([12.1,18.7,z], anchor=BOTTOM+CENTER);
  // SCD4x connector
  move([6.95,-0.8,-FUZZ]) cuboid([12.6,22.6,z], anchor=BOTTOM+CENTER);
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
      move([-X_PCB_V2/2+3,-Y_PCB_V2/2+3,-FUZZ]) xrot(180,cp=[0,0,z/2])
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

module lipo_charger_cutouts() {
  // USB
  move([-XO_BASE/2+X_PCB_LIPO/2 + X_PCB_LIPO_SW_OFF,
        -YO_BASE/2,-FUZZ])
    cuboid([XY_USB,4*W_BASE,H_BASE+Z_USB], anchor=BOTTOM+CENTER);
  // slider
  move([-XO_BASE/2,
        -YI_BASE/2+Y_PCB_LIPO/2+Y_PCB_LIPO_SW_OFF,-FUZZ])
    cuboid([4*W_BASE,Y_PCB_LIPO_SW,H_BASE+Z_PCB_LIPO_SW/2], anchor=BOTTOM+CENTER);
}

// --- cutouts for USB and I2C of PCB   ---------------------------------------

module pcb_cutouts() {
  // I2C1 at back-edge
  move([-X_PCB_I2C1_OFF,YO_BASE/2,Z_PCB_I2C1_OFF])
    cuboid([XY_I2C,4*W_BASE,Z_I2C], anchor=BOTTOM+CENTER);
  // I2C0 at right-edge
  move([XO_BASE/2,Y_PCB_I2C0_OFF,Z_PCB_I2C0_OFF])
    cuboid([4*W_BASE,XY_I2C,Z_I2C], anchor=BOTTOM+CENTER);
  // USB at right-edge (enlarged to merge with sensor-pcb I2C)
  move([XO_BASE/2,Y_PCB_USB_OFF-0.2,Z_PCB_USB_OFF])
    cuboid([4*W_BASE,XY_USB+0.4,Z_USB+1.8], anchor=BOTTOM+CENTER);
  // I2C1 at right-edge
  move([XO_BASE/2,Y_SENSOR_I2C1_OFF,Z_SENSOR_I2C1_OFF])
    cuboid([4*W_BASE,XY_I2C,Z_I2C], anchor=BOTTOM+CENTER);
}

// --- final object   ---------------------------------------------------------

difference() {
  cover(ztop=Z_TOP);
  lipo_charger_cutouts();
  pcb_cutouts();
  move([0,-YO_BASE/2+(YO_BASE-Y_TOP)/2,
          H_BASE+H_COVER/2]) xrot(ANGLE) pico_pin_mask();
}

// intersection for a test print of the top panel
//intersection() {
//  top_plate(h=Z_TOP);
//  move([XO_BASE/2-X_PCB_V2/2,10,-FUZZ])
//    cuboid([X_PCB_V2+10,YO_BASE-40,0.6], anchor=BOTTOM+CENTER);
//}
