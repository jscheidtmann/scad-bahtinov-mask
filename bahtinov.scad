
// ==========================================
//    Bahtinov Mask Generator for OpenSCAD
// ==========================================
//
// Copyright (C) 2020 Jens Scheidtmann
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ==========================================


//////////////////////////////////////////////////////////////
//
// This project lives at:
//   https://github.com/jscheidtmann/scad-bahtinov-mask
//
// Please see CONTRIBUTING.md, for how to contribute.
// CHANGELOG.md for a high level changelog and version
// information. The principle is explained and prior art is 
// referenced in the README.md.
//
// Some example masks and a stable version of the generator 
// can be downloaded from https://thingiverse.com/thingXXXXXXX
//
//////////////////////////////////////////////////////////////
//
// ************************************
// *** Some notes on implementation ***
// ************************************
//
// (0,0) is at the center of the mask. 
// 
// The "slits" and "bars" are created as repeats of cube elements.
// These are then translated, rotated and "cropped" to form the 
// sectors of the mask. 
// 
// On top of that "support structure" is generated, in order to 
// fuse the bars together and form a 2-manifold ("simple"), 
// that can be exported as STL or DXF.
// 
// "support structures" are 
//  - the ring around the mask,
//  - the horizontal (hbar) and 
//  - vertical bars (vbar). 
// 
// On some elements the tolerance parameter is used to create
// slightly bigger elements, so that OpenSCAD is able to create
// the correct union of elements.
//
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//
// Parameters used in configuration
// 
//            | |<- vbar
//           _____   ____________________________
//       _---     ---_   ________________    |
//     --    \\ //    --              |      |
//    /   \\\\\ /////   \             |      |
//   /   \\\\\\ //////   \            |   dia_ext
//   |  \\\\\\\ ///////  |            |      |
//  |   \\\\\\\ ///////   | __        |      |
//  |                     | __ hbar   |      |
//  |   |||||||||||||||   |           |      |
//   |  |||||||||||||||  |         dia_int   |
//   \   |||||||||||||   /            |      |
//    \   |||||||||||   /             |      |
//     --_   |||||   _-- ________________    |
//        ---_____---  _________________________
//
//
///////////////////////////////////////////////////////////


//
// Dimensions of Mask
//

   // exterior diameter, including the stabilizing ring
dia_ext = 90;     
   // interior diameter, this will be the area of the bars.
dia_int = 80;               

   // width of support structures
hbar = 5;
vbar = 5;

   // thickness of mask
thickness = 1.5;

//
// Definition of bars, that make up the interference structure
//  

   // angle that the bars are tilted against each other in upper half.
angle = 15;  // degrees        

   // define bar dimensions
focal_length = 420;    // given in mm

   // Factor to determine step size 
bahtinov_const = 150;  // [150-200] 
bahtinov_factor = 1;   // [1 or 3]


   // step = bar + empty space  

   // if the step size becomes too small, 
   // increase the bahtinov_factor.
   // 
   // rounded to next 1/10th of a mm
   // WARNING: If this is extremly small, rendering time will be slow
step = round(10* focal_length / bahtinov_const * bahtinov_factor)/10;

   // portion that will be bar (as part of "step")
portion = 1/2;   

/////////////////////
// Implementation
/////////////////////

// Increase resolution of circles.
$fa = 1;

// ************************************************
// ***       D O   N O T    C H A N G E         ***
// ***  B E L O W   T H I S   L I N E   ! ! !   *** 
// ************************************************
//       (unless you know how, of course)

   // tolerance to add for telling SCAD which things to merge
tolerance = 0.01;

   // some derived things
radius = dia_int / 2;
radius_ext = dia_ext / 2;

no_bars = ceil(radius / step)+1; 
   // Note: half of them, due to radius

// Reapeat the bars.
// module bar_grid(n_bars, step, portion, length, thickness) {
//    for (pos = [-no_bars*step : step : no_bars*step])
//       translate([0,pos + step/4,0])
//          cube([radius + tolerance,portion * step,thickness]);
// }


// Step 0)
// Make sure the bars are cut off in Step 4
difference(){

    union() {
        // Step 1)
        // The bars (lower half)
        for (pos = [-no_bars*step : step : no_bars*step])
           translate([-radius-tolerance,pos + step/4,0])
              cube([radius + tolerance,portion * step,thickness]);

        // Step 2)
        // The bars (rilted to right, top right)
        difference() {
            rotate([0,0,-angle/2]) 
            for (pos = [-no_bars*step : step : no_bars*step])
               translate([0,pos + step/4,0])
                  cube([radius + tolerance,portion * step,thickness]);

            translate([0,0,-thickness/2])
                cube([dia_int,dia_int,2*thickness]);
            translate([-dia_int,-dia_int,-thickness/2])
                cube([dia_int,2*dia_int,2*thickness]);
        };

        // Step 3)
        // The bars (tilted to left, top left)
        difference() {
            rotate([0,0,angle/2]) 
            for (pos = [-no_bars*step : step :  no_bars*step])
               translate([0,pos + step/4,0])
                  cube([radius + tolerance,portion * step,thickness]);

            translate([0,-dia_int,-thickness/2])
                cube([dia_int,dia_int,2*thickness]);
            translate([-dia_int,-dia_int,-thickness/2])
                cube([dia_int,2*dia_int,2*thickness]);
        };
    };
    
    // Step 4)
    // Chop off bars.
    translate([0,0,-thickness])
        difference() {
            cylinder(r=radius_ext*2, h=thickness*2);
            cylinder(r=radius_ext, h=thickness*2);
        };
    
};
// Step 5) 
// Support Structure: Ring
difference() {
    cylinder(r=radius_ext,h=thickness);
    cylinder(r=radius,h=thickness+tolerance);
}; 

// Step 6)
// Support Structure: Horizontal Bar
translate([-hbar/2,-radius-tolerance,0])
   cube([hbar,dia_int+2*tolerance,thickness]);

// Step 7)
// Support Structure: Vertical Bar
translate([0,-hbar/2,0])
   cube([radius+tolerance,hbar,thickness]);



