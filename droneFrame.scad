// General
screwSize = 3; // m3 by default

// Circle Edge Smoothness
$fa = 1;
$fs = 0.1;

// drone_arm
motor_key_radius = 8;
motor_mount_radius = 20;
motor_screw_distance_from_center = 8.5;
   
module motor_mount_base() {
    difference(){
        circle(r=motor_mount_radius);
        circle(r=motor_key_radius);
    }
} 
  
module motor_screw_holes() {
    translate([-motor_screw_distance_from_center,-motor_screw_distance_from_center]) {
        motor_screw_ellipse(screwSize+1,screwSize);
        
        translate([2*motor_screw_distance_from_center,0]) 
            mirror([0,1,0]) 
                motor_screw_ellipse(4,3);
    }
    
    translate([motor_screw_distance_from_center,motor_screw_distance_from_center]) {
        motor_screw_ellipse(screwSize+1,screwSize);
        
        translate([-2*motor_screw_distance_from_center,0])
            mirror([0,1,0])
                motor_screw_ellipse(4,3);
    }
}    
    
module motor_screw_ellipse(radiusX,radiusY) {
    rotate([0,0,45])
        resize([radiusX,radiusY])
            circle(r=10);
}

module drone_arm() {
    difference() {
        motor_mount_base();
        motor_screw_holes();
    }
}

drone_arm();

