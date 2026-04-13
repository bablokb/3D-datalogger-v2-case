// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): cover (top) of the case (for revision 0.94)
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <shared_094.scad>
include <screw_pocket.scad>
include <pico_pin_mask.scad>

YZ_SIZE_SLANTED = sqrt((YO_BASE-Y_TOP)^2+H_COVER^2);
echo("H_COVER        = ", H_COVER);
echo("H_TOTOAL       = ", BT + H_BASE + H_COVER + Z_TOP);
echo("YO_BASE        = ", YO_BASE);
echo("Y_TOP          = ", Y_TOP);
echo("yz-size slanted = ", YZ_SIZE_SLANTED);
echo("angle          = ", ANGLE);

assert(YZ_SIZE_SLANTED > Y_PCB_DISPLAY, "increase H_COVER!");

// --- cutouts for the sensor pcb   -------------------------------------------

module sensor_cutouts(h) {
  z = h+2*FUZZ;
  // screw holes
  xflip_copy() yflip_copy()
    move([-X_PCB_V2/2+3,-Y_PCB_V2/2+3,-FUZZ]) xrot(180,cp=[0,0,z/2])
       screw_pocket(h=z, hull=true);
  // LED
  move([-27.4,15.7,-FUZZ]) cuboid([4.8,2,z], anchor=BOTTOM+CENTER);
  // app-buttons
  move([-12.5,16.65,-FUZZ]) cuboid([23,11.7,z], anchor=BOTTOM+CENTER);
  // on + reset
  move([-23.85,-7.55,-FUZZ]) cuboid([11.9,18.7,z], anchor=BOTTOM+CENTER);
  // ENS connector
  move([-2.93,0.36,-FUZZ]) cuboid([3,11.5,z], anchor=BOTTOM+CENTER);
  // SCD40 connector
  move([6.44,9.15,-FUZZ]) cuboid([11,3,z], anchor=BOTTOM+CENTER);
  // AHT20
  move([18.4,14.15,-FUZZ]) cuboid([8.4,10.1,z], anchor=BOTTOM+CENTER);
  // PDM
  move([18.4,0.2,-FUZZ]) cuboid([8.4,10.2,z], anchor=BOTTOM+CENTER);
  // BH1750
  move([18.4,-12.95,-FUZZ]) cuboid([8.4,10.1,z], anchor=BOTTOM+CENTER);
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

// --- cutouts for USB and I2C of PCB   ---------------------------------------

module pcb_cutouts() {
  // I2C0 at right-edge
  move([XO_BASE/2,Y_PCB_I2C0_OFF,Z_PCB_I2C0_OFF-BT])
    cuboid([4*W_BASE,XY_I2C_THT,Z_I2C_THT], anchor=BOTTOM+CENTER);
  // USB at right-edge
  move([XO_BASE/2,Y_PCB_USB_OFF,Z_PCB_USB_OFF])
    cuboid([4*W_BASE,XY_USB,Z_USB], anchor=BOTTOM+CENTER);
  // I2C1 at right-edge
  move([XO_BASE/2,Y_SENSOR_I2C1_OFF,Z_SENSOR_I2C1_OFF])
    cuboid([4*W_BASE,XY_I2C,Z_I2C], anchor=BOTTOM+CENTER);
   // ventilation sides
  D_VENT = 3;  // diameter
  N_VENT = 4;  // count
  move([0,Y_SENSOR_I2C1_OFF,Z_PCB_USB_OFF+Z_USB+D_VENT])
      ycopies(1*XY_USB,n=N_VENT)
        xcyl(l=2*YO_BASE+2*FUZZ,d=D_VENT);
}

// --- final object   ---------------------------------------------------------

module cover_final() {
  difference() {
    cover(ztop=Z_TOP);
    pcb_cutouts();
    // cutout for PH2-socket
    move([+XI_BASE/2,-YI_BASE/2+Y2_PH2/2+O2_PH2,-FUZZ])
          cuboid([8*W2,Y2_PH2+GAP,Z2_PH2+2*FUZZ], anchor=BOTTOM+CENTER);
    // cutout for pins
    move([0,-YO_BASE/2+(YO_BASE-Y_TOP)/2,
            H_BASE+H_COVER/2]) xrot(ANGLE) pico_pin_mask();
  }
}
cover_final();

// intersection for a test print of the top panel
//intersection() {
//  top_plate(h=Z_TOP);
//  move([XO_BASE/2-X_PCB_V2/2,5,-FUZZ])
//    cuboid([X_PCB_V2+20,YO_BASE-30,0.6], anchor=BOTTOM+CENTER);
//}
