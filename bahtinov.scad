
//          Bahtinov 
//            Mask 
//         Generator
//           _____
//       _---     ---_
//     --    \\ //    --
//    /   \\\\\ /////   \
//   /   \\\\\\ //////   \
//   |  \\\\\\\ ///////  |
//  |   \\\\\\\ ///////   |
//  |                     |
//  |   |||||||||||||||   |
//   |  |||||||||||||||  |
//   \   |||||||||||||   /
//    \   |||||||||||   / 
//     --_   |||||   _--        
//        ---_____---
//
//
///////////////////////////////////////////////////////////
//
// Some notes on implementation:
//
// (0,0) is at the center of the mask.
// "support structures" are the ring around the mask,
// the horizontal and vertical bars (hbar, vbar). 


//
// Dimensions of Mask
//

   // interior diameter, this will be the area of the bars.
dia_int = 80;               

   // exterior diameter, including the stabilizing ring
dia_ext = dia_int + support_width;     

   // width of support structures
support_width = 10 
hbar_width = support_width
vbar_wdith = support_width

//
// Definition of bars, that make up the interference structure
//  

   // angle that the baars are tilted against each other in upper half.
angle = 15;  // degree        

   // define bar dimensions
focal_length = 420    // given in mm

   // Factor to determine step size 
bahtinov_const = 150  // [150-200] 
bahtinov_factor = 1   // [1 or 3]


   // step = bar + empty space  
   // if the step size becomes too small, 
   // increase the bahtinov_factor
step = round(10* focal_length / bahtinov_const * bahtinov_factor)/10

   // portion that will be bar (as part of "step")
portion = 0.5   

/////////////////////
// Implementation
/////////////////////

// ******************************************************************************
// ***   D O   N O T    C H A N G E   B E L O W   T H I S   L I N E   ! ! !   *** 
// ******************************************************************************
// (unless you know what you do, of course)


