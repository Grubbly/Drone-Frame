// Tristan Van Cise
// CS 680 - 3D Printing and Robotics
// Homework 2 - OpenSCAD
// 09/16/2018
//
// Modularish drone frame designed for racing sized quad-copters
// with CC3D sized flight controllers (3mm X 3mm) and 
// KV2600 BR2205 motors.
//


/*******************************************************************
*   // Change to true to see a rough model of the assembled frame  *
*                                                                  *
*/    show_assembled_model = true;                                /*
*                                                                  *
********************************************************************/

// General Variables
screwSize = 3; // m3 by default
enclosure_extrude_height = 2;

// CAUTION: Smaller thickness could lead to
// screws boring through motor coils
drone_arm_thickness = 4; 

// Circle Edge Smoothness
$fa = 1;
$fs = 0.1;

// Motor mount
motor_key_radius = 8;
motor_mount_radius = 20;
motor_screw_distance_from_center = 8.5;
motor_mount_to_arm_transition_length = 27;

// Arm
arm_width = 20;
arm_length = 60;
distance_to_arm_end = 1.5*motor_mount_to_arm_transition_length+(arm_length);
  
// Body
body_width = 45;
body_height = 90;
arm_angle_from_body = 45;

// Enclosure
enclosure_width  = 60;
enclosure_height = 45;
enclosure_thickness = 2;
antenna_radius = 2;
   
/*************/
/** Modules **/
/*************/

module motor_mount_base() {
    difference() {
        hull() {
            circle(r=motor_mount_radius);
            motor_mount_to_arm_transition_piece();
        }
        circle(r=motor_key_radius);
    }
}   

module motor_mount_to_arm_transition_piece() {
    translate([0,motor_mount_to_arm_transition_length,0])
        square([arm_width,motor_mount_to_arm_transition_length],center=true);
}

// The holes for the motors are ellipses due to
// varying motor screw hole distances from
// different manufacturers.
module motor_screw_holes() {
    translate([-motor_screw_distance_from_center,-motor_screw_distance_from_center]) {
        motor_screw_ellipse(screwSize+2,screwSize);
        
        translate([2*motor_screw_distance_from_center,0]) 
            mirror([0,1,0]) 
                motor_screw_ellipse(screwSize+2,screwSize);
    }
    
    translate([motor_screw_distance_from_center,motor_screw_distance_from_center]) {
        motor_screw_ellipse(screwSize+2,screwSize);
        
        translate([-2*motor_screw_distance_from_center,0])
            mirror([0,1,0])
                motor_screw_ellipse(screwSize+2,screwSize);
    }
}    
    
module motor_screw_ellipse(radiusX,radiusY) {
    rotate([0,0,45])
        resize([radiusX,radiusY])
            circle(r=10);
}

module motor_mount() {
    difference() {
        motor_mount_base();
        motor_screw_holes();
    }
}

module arm() {
    
    translate([0,1.5*motor_mount_to_arm_transition_length+(0.5*arm_length),0])
    square([arm_width,arm_length],center=true);
}


module arm_to_body_screw_holes() {
    align_to_corners_on_body() {
    linear_extrude(height = 7, center = true, convexity = 10) {
        translate([5,distance_to_arm_end-5])
            circle(r=0.5*screwSize,center=true);
        
        translate([-5,distance_to_arm_end-5])
            circle(r=0.5*screwSize,center=true);
        
        translate([0,distance_to_arm_end-10])
            circle(r=0.5*screwSize,center=true);
    }
    }
}

module cc3d_screw_holes() {
    translate([15,15])
        circle(r=0.5*screwSize,center=true);
    translate([-15,15])
        circle(r=0.5*screwSize,center=true);
    translate([15,-15])
        circle(r=0.5*screwSize,center=true);
    translate([-15,-15])
        circle(r=0.5*screwSize,center=true);
}

module arm_end_screw_holes() {
    linear_extrude(height = 7, center = true, convexity = 10) {
        translate([5,distance_to_arm_end-5])
            circle(r=0.5*screwSize,center=true);
        
        translate([-5,distance_to_arm_end-5])
            circle(r=0.5*screwSize,center=true);
        
        translate([0,distance_to_arm_end-10])
            circle(r=0.5*screwSize,center=true);
    }
}

module drone_arm() { 
    motor_mount();
    difference() {
        arm();
        arm_end_screw_holes();
    }
}

module align_arm(x=1,y=1,angle) {
    translate([x*(0.5*body_width+arm_length),y*(0.5*body_height+arm_length),0]) { 
        rotate([0,0,angle]) {
            children();
        }
    }
}

module body_base() {
    difference() {
        square([body_width,body_height],center=true);
        cc3d_screw_holes();
    }
}


module align_to_corners_on_body() {
    align_arm(1,-1,arm_angle_from_body) 
        children();
    
    align_arm(-1,-1,-arm_angle_from_body) 
        children();
    
    align_arm(-1,1,180+arm_angle_from_body) 
        children();
    
    align_arm(1,1,-180-arm_angle_from_body) 
        children();
}

module body_and_arms() {
    
    body_base();
    align_to_corners_on_body() {
        translate([0,0,-0.32*3])
        drone_arm();
    }
    
}

module body_and_arms_difference() {
    difference() {
    linear_extrude(height = drone_arm_thickness+1, center = true, convexity = 5)
    body_base();
    align_to_corners_on_body() {
        translate([0,0,-0.32*3])
        linear_extrude(height = drone_arm_thickness, convexity = 5)
        drone_arm();
    }
    }
}

module enclosure_wall() {
    union() {
    difference() {
        union() {
            linear_extrude(height = enclosure_extrude_height, convexity = 10, center=true)
            square([enclosure_height,enclosure_width],center=true);
            rotate([0,90,0]) {
                translate([0.5*enclosure_extrude_height, 0.5*enclosure_width-5, 0.5*enclosure_height-1]) {
                    difference() {
                        linear_extrude(height = 2, convexity = 10, center=true)
                        square([5,5]);
                            translate([2.5,2.5])
                                cylinder(r=0.5*screwSize, h=3, center=true);
                    }
                    
                    translate([0, -enclosure_width+5,0]){
                        difference() {
                            linear_extrude(height = 2, convexity = 10, center=true)
                            square([5,5]);
                                translate([2.5,2.5])
                                    cylinder(r=0.5*screwSize, h=3, center=true);
                        }
                    }
                }
            }
                translate([-13.35+2*(13.35/20),20+0.25*(20/13.35),-0.5*enclosure_extrude_height]) {
                    rotate([-15,90,0]){
                        
                    difference() {
                    linear_extrude(height = 2, convexity = 10, center=true)
                    square([5,5]);
                        translate([2.5,2.5])
                            cylinder(r=0.5*screwSize, h=3, center=true);
                    }
                    
                    translate([0,-50,0]) {
                        difference() {
                            linear_extrude(height = 2, convexity = 10, center=true)
                            square([5,5]);
                            translate([2.5,2.5])
                                cylinder(r=0.5*screwSize, h=3, center=true);
                        }
                    }
                    }
                }
            
       }
       difference() {
           translate([enclosure_height/4,0,0])
            linear_extrude(height = 20, convexity = 10, center=true)
               square([(enclosure_height/2)+1,enclosure_width/1.5],center=true);
           translate([7,-25,0]) 
            rotate([0,0,15]) 
                linear_extrude(height = 20, convexity = 10, center=true) {
                    square([5,50]);
                }
            }
       
       // side slice
       translate([-40,0,0]) 
            rotate([0,0,15]) 
                linear_extrude(height = 20, convexity = 10, center=true) {
                    square([55,80],center=true);
                }
                
       // velcro
       translate([-7+0.5*1.75,4+(4/14),0]) 
            rotate([0,90,15]) 
                linear_extrude(height = 1, convexity = 10, center=true) {
                    square([22,22],center=true);
                }
   }
   
   }
}

module counter_sunk_screw_hole() {
    
        translate([0,0,-2.5])
            cylinder(r=0.75*screwSize, h=2);
        cylinder(r=0.5*screwSize, h=5, center=true);
    
}

module enclosure_roof_and_screws(shift_factor=0) {
    difference() {
    translate([0,0,31.5+shift_factor]) {
        rotate([15,0,0]) {
            linear_extrude(height = 2, center = true, convexity = 10)
            difference() {
                square([30-enclosure_extrude_height,62],center=true);
                
                translate([0,-25,0])
                    circle(r=antenna_radius, center=true);
            }
        }
    }
    
    // NEEDS REFACTOR
    translate([15,0,22.5]) { 
        rotate([0,90,0]) {
            translate([-13.35-shift_factor,20,-0.5]) { 
                rotate([-15,90,0]) {
                    translate([2.5+1,2.5]){
                        counter_sunk_screw_hole();
                        translate([24-2,0,0])
                            counter_sunk_screw_hole();
                            translate([24-2,-50,0])
                                counter_sunk_screw_hole();
                                translate([0,-50,0])
                                    counter_sunk_screw_hole();
                    }
                }
            }
        }
    }
}
}

module body_enclosure(shift_factor=0) {
    union() {
        difference() {
            translate([15,0,22.5+shift_factor]) {
                rotate([0,90,0]) {
                    
                    enclosure_wall();
                }
                mirror([0,0,1]) {
                    rotate([0,-90,0]) 
                    translate([0,0,30])
                   
                    enclosure_wall();
                }
            }
        
        }
    
        enclosure_roof_and_screws(shift_factor);
    }   
}

module enclosure_to_body_screw_holes(){
    translate([15-enclosure_extrude_height-1.25,0.5*enclosure_height+5,0])
    cylinder(r=0.5*screwSize, h=7, center=true);
    
    translate([15-enclosure_extrude_height-1.25,-0.5*enclosure_height-5,0])
    cylinder(r=0.5*screwSize, h=7, center=true);
    
    mirror([1,0,0])
    translate([15-enclosure_extrude_height-1.25,0.5*enclosure_height+5,0])
    cylinder(r=0.5*screwSize, h=7, center=true);
    
    mirror([1,0,0])
    translate([15-enclosure_extrude_height-1.25,-0.5*enclosure_height-5,0])
    cylinder(r=0.5*screwSize, h=7, center=true);
}

module four_arms_separated() {
    translate([73,40-arm_length/2]) {
        linear_extrude(height=drone_arm_thickness, center=true, convexity=5) {
            drone_arm();
            translate([-35,40+distance_to_arm_end/2 - 7])
            rotate([0,0,180])
            drone_arm();
            mirror([1,0,0]) {
            translate([146,40-distance_to_arm_end/2 + 7]){
                drone_arm();
                translate([-35,40+distance_to_arm_end/2 - 7])
                rotate([0,0,180])
                drone_arm();
            }
            }
        }
    }
}

module two_enclosure_walls_separated() {
        union() {
            translate([40,-50,0])
            rotate([0,180,-45]) {
            enclosure_wall();
            }
            mirror([0,0,1]) {
            translate([-40,-50,0])
            rotate([0,0,45])
            enclosure_wall();
        }
    }
}

module segmented_drone_frame() {
    
    difference() {
        body_and_arms_difference();
        arm_to_body_screw_holes();
        enclosure_to_body_screw_holes();
    }
    
    two_enclosure_walls_separated();
  
    translate([0,70,-30])
    rotate([-15,0,0])
    enclosure_roof_and_screws();
     
    four_arms_separated();
}

module drone_frame() {
    difference() {
        linear_extrude(height = 5, center = true, convexity = 5)
        body_and_arms();
        arm_to_body_screw_holes();
        enclosure_to_body_screw_holes();
    } 
    body_enclosure(drone_arm_thickness-1.5);
}
    

if(show_assembled_model)
    drone_frame();
else
    segmented_drone_frame();
