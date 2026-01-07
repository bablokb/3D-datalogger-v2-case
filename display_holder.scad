// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic display-holder.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

// --- plate with screw-holes for display   ----------------------------------

module plate(c, y, w, msize=50, mask=false,
             d_screw=2.7, h_screw=1.4, d2_screw=4.28, o_screw=3) {
  if (!mask) {
    cuboid([c,y,w], anchor=BOTTOM+CENTER);
  } else {
    move([-c/2+o_screw,0,-fuzz]) {
          cylinder(d=d_screw, h=w+2*fuzz,anchor=BOTTOM+CENTER);
          zmove(-msize-fuzz)
            cylinder(d=d2_screw, h=msize+h_screw,anchor=BOTTOM+CENTER);
    }
    move([+c/2-o_screw,0,-fuzz]) {
          cylinder(d=d_screw, h=w+2*fuzz,anchor=BOTTOM+CENTER);
          zmove(-msize-fuzz)
            cylinder(d=d2_screw, h=msize+h_screw,anchor=BOTTOM+CENTER);
    }
  }
}

// --- the holder with walls, plate and screw-holes   ------------------------

module display_holder(x,y,h1,h2,w, open=true) {
  difference() {
    // holder without holes
    union() {
      cuboid([x,y,w], anchor=BOTTOM+CENTER);
      xmove(-x/2) cuboid([w,y,h1], anchor=BOTTOM+CENTER);
      xmove(x/2) cuboid([w,y,h2], anchor=BOTTOM+CENTER);

      // angled plate, rotated at the right side
      c = sqrt((h1-h2)^2+x^2);
      color("blue")
        yrot(-atan((h2-h1)/x),cp=[x/2+w/2,y/2,h2])
          move([-(c-x)/2+w/2,0,h2-w])
            plate(c,y,w);
    }
    // minus holes
    yrot(-atan((h2-h1)/x),cp=[x/2+w/2,y/2,h2])
      move([-(c-x)/2+w/2,0,h2-w])
        plate(c,y,w, mask=true);
  }
}

//x = 30;
//y = 10;
//h1= 30;
//h2= 10;
//w = w4;
//c = sqrt((h1-h2)^2+x^2);

w  = w4;
c  = 36.4;  // y_pcb_display
y  = 10;
h1 = 19;
h2 = w;
x  = sqrt(c^2-(h1-h2)^2);

display_holder(x,y,h1=h1,h2=h2,w=w, open=false);
//difference() {
//  plate(c,y,w,mask=false);
//  plate(c,y,w,mask=true);
//}
