// Circle Edge Smoothness
$fa = 1;
$fs = 0.1;

// drone_arm
    
module motor_bolt_ellipse(radius) {
    circle(r=radius);
}

module drone_arm() {
    difference() {
        circle(r=20);
        circle(r=8);
    }
}

drone_arm();

