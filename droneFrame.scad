// General Variables
screwSize = 3; // m3 by default

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
        motor_screw_ellipse(screwSize+1,screwSize);
        
        translate([2*motor_screw_distance_from_center,0]) 
            mirror([0,1,0]) 
                motor_screw_ellipse(screwSize+1,screwSize);
    }
    
    translate([motor_screw_distance_from_center,motor_screw_distance_from_center]) {
        motor_screw_ellipse(screwSize+1,screwSize);
        
        translate([-2*motor_screw_distance_from_center,0])
            mirror([0,1,0])
                motor_screw_ellipse(screwSize+1,screwSize);
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

module drone_arm() { 
    offset(r=+0.5); offset(r=-0.5);
    offset(r=-0.5); offset(r=+0.5);
    motor_mount();
    arm();
}

drone_arm();

