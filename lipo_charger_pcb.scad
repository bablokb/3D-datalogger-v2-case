// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Lipo charger PCB. 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb.scad>

// --- module for LiPo PCB   -------------------------------------------------

module lipo_charger_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  move([X_PCB_LIPO_SW_OFF-XI_BASE/2+X_PCB_LIPO/2,
        -YI_BASE/2+Y_PCB_LIPO/2,zm]) {
          pcb(X_PCB_LIPO, Y_PCB_LIPO, z, o_screw=O_PCB_LIPO,
              edges=[], screws=!hull);
          if (hull) {
            // cutout switch
            move([-X_PCB_LIPO/2,Y_PCB_LIPO_SW_OFF,z])
              cuboid([20,Y_PCB_LIPO_SW,Z_PCB_LIPO_SW],
                anchor=BOTTOM+CENTER);
            // cutout USB
            move([X_PCB_LIPO_USB_OFF,-Y_PCB_LIPO/2,z])
              cuboid([X_PCB_LIPO_usb,20,Z_PCB_LIPO_SW],
                anchor=BOTTOM+CENTER);
          }
        }
}
