// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Generic module creating wall-locks. Use as a mask
//                      for the outer-wall and as-is for the inner wall.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-datalogger-v2-case
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

module wall_lock(x,y, count=3, d=W2, l=3, space=0, mask=false) {
  // x,y   : (outer) dimensions of walls
  // count : number of locks. Can be a scalar of vector.
  // d     : diameter of lock. Should be 2xwall-width
  // l     : length of lock
  // space: space between locks (default: evenly spaced). Can be a scalar of vector.

  d_lock  = mask ? d+GAP : d;
  l_lock  = mask ? l+GAP : l; 
  counts  = is_list(count)  ? count  : [count,count,count,count];
  spaces = is_list(space) ? space : [space,space,space,space];

  // back (north)
  ymove(y/2) xcopies(spaces[0] == 0 ? x/(counts[0]+1):spaces[0],
                     counts[0]) xcyl(l=l_lock,d=d_lock);
  // right (east)
  xmove(x/2) ycopies(spaces[1] == 0 ? x/(counts[1]+1):spaces[1],
                     counts[1]) ycyl(l=l_lock,d=d_lock);
  // front (south)
  ymove(-y/2) xcopies(spaces[2] == 0 ? x/(counts[2]+1):spaces[2],
                      counts[2]) xcyl(l=l_lock,d=d_lock);
  // left (west)
  xmove(-x/2) ycopies(spaces[3] == 0 ? x/(counts[3]+1):spaces[3],
                      counts[3]) ycyl(l=l_lock,d=d_lock);
}

//x = 30; y = 20;
//wall_lock(30,20);
//color("blue") zmove(2.5) wall_lock(30,20,count=[3,2,1,2]);
//color("red") zmove(5) wall_lock(30,20,count=[3,2,1,2],
//                                       space=[x/4+3,y-8,0,y-8]);
