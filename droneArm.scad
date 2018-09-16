// Tristan Van Cise
// CS 680 - 3D Printing and Robotics
// Homework 2 - OpenSCAD
// 09/16/2018
//
// Single arm for part replacement or
// print testing.
//

// General Variables
screwSize = 3; // m3 by default

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
    motor_mount();
    difference() {
        arm();
        arm_end_screw_holes();
    }
}

linear_extrude(height = drone_arm_thickness, center = true, convexity = 10)
    drone_arm();
