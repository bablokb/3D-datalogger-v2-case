// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): LoRa-PCB.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb.scad>

// --- module for LoRa PCB   -------------------------------------------------

module lora_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([-xi_base/2+x_pcb_lora/2,yi_base/2-y_pcb_lora/2,zm])
          pcb(x_pcb_lora, y_pcb_lora, z, edges=[], screws=!hull);
}
