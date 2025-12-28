// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

// --- generic module to create space for a PCB   ----------------------------

module pcb(x, y, z=b, d_screw=2.5, o_screw=3, r=3, edges="Z", screws=true) {
  difference() {
    // solid space
    cuboid([x,y,z], rounding=r, edges=edges, anchor=BOTTOM+CENTER);
    // minus screw-holes
    if (screws) {
      xflip_copy()
        yflip_copy() move([-x/2+o_screw,-y/2+o_screw,-fuzz]) 
          cylinder(d=d_screw, h=b+2*fuzz,anchor=BOTTOM+CENTER);
    }
  }
}

// --- module for v2 PCB   ---------------------------------------------------

module v2_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([xi_base/2-x_pcb_v2/2,yi_base/2-y_pcb_v2/2,zm])
          pcb(x_pcb_v2, y_pcb_v2, z, edges=[BACK+RIGHT], screws=!hull);
}

// --- module for LoRa PCB   -------------------------------------------------

module lora_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([-xi_base/2+x_pcb_lora/2,yi_base/2-y_pcb_lora/2,zm])
          pcb(x_pcb_lora, y_pcb_lora, z, edges=[], screws=!hull);
}

// --- module for LiPo PCB   -------------------------------------------------

module lipo_pcb(hull=false) {
  z = hull ? b+2*fuzz : b;
  zm = hull ? -fuzz : 0;
  move([-xi_base/2+x_pcb_lipo/2,-yi_base/2+y_pcb_lipo/2,zm])
          pcb(x_pcb_lipo, y_pcb_lipo, z, edges=[], screws=!hull);
}

// --- create base-plate to fit all PCBs   -----------------------------------

module plate() {
  h = 4;
  cuboid([xo_base,yo_base,b],
          rounding=r_base, edges=[BACK+RIGHT,FRONT+RIGHT], anchor=BOTTOM+CENTER);
  // rect_tube does not define edges, so build it ourselves
  zmove(b-fuzz) difference() {
    cuboid([xi_base+2*w2,yi_base+2*w2,h],
            rounding=r_base, edges=[BACK+RIGHT,FRONT+RIGHT], anchor=BOTTOM+CENTER);    
    zmove(-fuzz) cuboid([xi_base,yi_base,h+2*fuzz],
            rounding=r_base, edges=[BACK+RIGHT,FRONT+RIGHT], anchor=BOTTOM+CENTER);
  }
}

// --- final object   -------------------------------------------------------

module base() {
  // plate minus all PCBs
  difference() {
    plate();
    v2_pcb(hull=true);
    lora_pcb(hull=true);
    lipo_pcb(hull=true);
  }
  // add back PCBs
  color("blue") v2_pcb();
  color("red") lora_pcb();
  color("green") lipo_pcb();
}

base();

//
