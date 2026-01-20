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
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([x_pcb_lipo_sw_off-xi_base/2+x_pcb_lipo/2,
        -yi_base/2+y_pcb_lipo/2,zm]) {
          pcb(x_pcb_lipo, y_pcb_lipo, z, o_screw=o_pcb_lipo,
              edges=[], screws=!hull);
          if (hull) {
            // cutout switch
            move([-x_pcb_lipo/2,y_pcb_lipo_sw_off,z])
              cuboid([20,y_pcb_lipo_sw,z_pcb_lipo_sw],
                anchor=BOTTOM+CENTER);
            // cutout USB
            move([x_pcb_lipo_usb_off,-y_pcb_lipo/2,z])
              cuboid([x_pcb_lipo_usb,20,z_pcb_lipo_sw],
                anchor=BOTTOM+CENTER);
          }
        }
}
