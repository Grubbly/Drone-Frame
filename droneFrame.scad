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
  
// Body
body_width = 45;
body_height = 90;
arm_angle_from_body = 45;

// Enclosure
enclosure_width  = 60;
enclosure_height = 45;
enclosure_thickness = 2;
   
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

module drone_arm() { 
    motor_mount();
    arm();
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
        drone_arm();
    }
}

module enclosure_wall() {
    difference() {
        union() {
            square([enclosure_height,enclosure_width],center=true);
            rotate([0,90,0]) {
                translate([0.5, 0.5*enclosure_width-5, 0.5*enclosure_height-1]) {
                    square([5,5]);
                    translate([0, -enclosure_width+5,0])
                    square([5,5]);
                }
            }
                translate([-13.35,20,-0.5]) {
                    rotate([-15,90,0]){
                        
                    difference() {
                    square([5,5]);
                        translate([2.5,2.5])
                            cylinder(r=0.5*screwSize, h=3, center=true);
                    }
                    
                    translate([0,-50,0]) {
                        difference() {
                            square([5,5]);
                            translate([2.5,2.5])
                                cylinder(r=0.5*screwSize, h=3, center=true);
                        }
                    }
                    }
                }
            
       }
       translate([enclosure_height/4,0,0])
           square([(enclosure_height/2),enclosure_width/1.5],center=true);
   }
}

module enclosure_roof_screws() {
    difference() {
    translate([0,0,31.5]) {
        rotate([15,0,0]) {
            square([29,62],center=true);
        }
    }
    
    
    // NEEDS REFACTOR
    translate([15,0,22.5]) { 
    rotate([0,90,0]) {
    translate([-13.35,20,-0.5]) { 
    rotate([-15,90,0]) {
    translate([2.5,2.5]){
        cylinder(r=0.5*screwSize, h=5, center=true);
    translate([24,0,0])
        cylinder(r=0.5*screwSize, h=5, center=true);
    translate([24,-50,0])
        cylinder(r=0.5*screwSize, h=5, center=true);
    translate([0,-50,0])
        cylinder(r=0.5*screwSize, h=5, center=true);
    }
    }
    }
    }
    }
}
}

module body_enclosure() {
    union() {
        difference() {
            translate([15,0,22.5]) {
                rotate([0,90,0]) {
                    enclosure_wall();
                }
                mirror([0,0,1]) {
                    rotate([0,-90,0]) 
                    translate([0,0,30])
                        enclosure_wall();
                }
            }
            
            
                translate([0,0,32]) {
                rotate([15,0,0]) {
                linear_extrude(height = 25, convexity = 10) {
                    square([35,80],center=true);
                }
                
                
                rotate([0,0,90])
                translate([5,0,-5])
                square([22,80],center=true);
            }
        }
        
        }
    
        enclosure_roof_screws();
    }
    
}

module drone_body() {
    difference() {
        body_and_arms();
        #arm_to_body_screw_holes();
    }
    body_enclosure();
}

//drone_arm();
drone_body();

