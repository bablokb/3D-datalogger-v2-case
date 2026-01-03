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

module display_holder(xbot,y,xtop,h,w, open=true) {
  difference() {
    prismoid(size1=[xbot,y], size2=[xtop,y], h=h, shift=[-(xbot-xtop)/2,0],
             anchor=BOTTOM+CENTER);
    if (open) {
      move([-2*w,0,w])
        prismoid(size1=[xbot-w,y+2*fuzz],
                        size2=[xtop-w,y+2*fuzz], h=h, shift=[-(xbot-xtop)/2,0],
                        anchor=BOTTOM+CENTER);
    } else {
      move([-w,0,w])
        prismoid(size1=[xbot-4*w,y+2*fuzz],
                        size2=[xtop-w,y+2*fuzz], h=h-2*w, shift=[-(xbot-3*w-xtop)/2,0],
                        anchor=BOTTOM+CENTER);
    }
  }
}

display_holder(30,10,w4,h=20,w=w4, open=false);
