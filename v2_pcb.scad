// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Datalogger v2 PCB.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb.scad>

// --- module for v2 PCB   ---------------------------------------------------

module v2_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([xi_base/2-x_pcb_v2/2,yi_base/2-y_pcb_v2/2,zm])
          pcb(x_pcb_v2, y_pcb_v2, z, edges=[BACK+RIGHT], screws=!hull);
}
