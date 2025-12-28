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
include <screw_pocket.scad>

// --- generic module to create space for a PCB   ----------------------------

module pcb(x, y, z=b, h_screw=3, o_screw=3, r=3, edges="Z", screws=true) {
  difference() {
    // solid space
    cuboid([x,y,z], rounding=r, edges=edges, anchor=BOTTOM+CENTER);
    // mask screw-pockets
    if (screws) {
      xflip_copy()
        yflip_copy() move([-x/2+o_screw,-y/2+o_screw,-fuzz]) 
          screw_pocket(h=h_screw, hull=true);
    }
  }
  // add screw-pockets
  if (screws) {
    xflip_copy()
      yflip_copy() move([-x/2+o_screw,-y/2+o_screw,-fuzz])
        screw_pocket(h=h_screw, hull=false);
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
//lipo_pcb(hull=true);
