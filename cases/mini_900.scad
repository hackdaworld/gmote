$fa=0.05;
$fs=0.05;

delta=0.01;
dfit=0.5;

bwd=2;

// moisture sensor
ms_l=86;
ms_w=22;
ms_t=1;
ms_rl=20.5;
ms_rlo=4.5;
ms_rli=2.5;
ms_rd=1.5;
ms_lt=96;
ms_cl=10;
ms_cw=10;
ms_ch=6;
ms_inside=25;
ms_rt=5*ms_t;

// us sensor
us_x=44;
us_y=20;
us_z=1.5;
us_r=16/2;
us_dx=10;
us_sh=13;

//bat_x=47;
bat_x=dfit+us_x+ms_rlo;
bat_y=32;
bat_z=6;

brd_x=34;
brd_y=25;
brd_z=25;

brd_rest_z=4;
brd_rest_y=2;
brd_t=1;


lockr=0.5;

ms_sh=bat_z+brd_z+2*bwd-ms_ch-ms_t/2;

module shim(w1,w2,d,h) {
	linear_extrude(height=h)
	polygon(points=[[-w1/2,0],[w1/2,0],[w2/2,d],[-w2/2,d]]);
}

module lock(x,y,rad) {
	translate([0,0,0]) rotate([0,90,0])
	cylinder(r=rad,h=x);
	translate([0,0,0]) rotate([-90,0,0])
	cylinder(r=rad,h=y);
	translate([x,0,0]) rotate([-90,0,0]) 
	cylinder(r=rad,h=y);
	translate([0,y,0]) rotate([0,90,0])
	cylinder(r=rad,h=x);
	intersection() {
		translate([-rad,0,0]) rotate([0,90,0])
		cylinder(r=rad,h=x+2*rad);
		translate([0,-rad,0]) rotate([-90,0,0])
		cylinder(r=rad,h=y+2*rad);
	}
	intersection() {
		translate([-rad,0,0]) rotate([0,90,0])
		cylinder(r=rad,h=x+2*rad);
		translate([x,-rad,0]) rotate([-90,0,0]) 
		cylinder(r=rad,h=y+2*rad);
	}
	intersection() {
		translate([x,-rad,0]) rotate([-90,0,0]) 
		cylinder(r=rad,h=y+2*rad);
		translate([-rad,y,0]) rotate([0,90,0])
		cylinder(r=rad,h=x+2*rad);
	}
	intersection() {
		translate([-rad,y,0]) rotate([0,90,0])
		cylinder(r=rad,h=x+2*rad);
		translate([0,-rad,0]) rotate([-90,0,0])
		cylinder(r=rad,h=y+2*rad);
	}
}

module fullcase02(dbg_x,dbg_y,dbg_z) {

// body
difference() {
	hull() {
		cube([bat_x+2*bwd,bat_y+2*bwd,bat_z+2*bwd+brd_z+bwd]);
	}
	union() {
		// volume
		translate([bwd,bwd,bwd])
			cube([bat_x+dbg_x,bat_y,bat_z+bwd+brd_z+dbg_z]);
		// moisture sensor slot
		translate([bat_x+bwd-delta,bwd+(bat_y-ms_w)/2-dfit/2,bat_z+2*bwd+brd_z-ms_ch-ms_t-dfit/2])
			cube([bwd+2*delta,ms_w+dfit,ms_t+dfit]);
		// us sensor openings
		translate([bwd+dfit+us_dx,bwd+dfit+us_y/2,bat_z+brd_z+2*bwd-delta]) {
			cylinder(r=us_r+dfit/2,h=bwd+2*delta);
			translate([us_x-2*us_dx,0,0])
				cylinder(r=us_r+dfit/2,h=bwd+2*delta);
		}
		// text
		translate([2.5*bwd,1.55*(bat_y/2+bwd),bat_z+brd_z+2.75*bwd])
		linear_extrude(height=bwd/4+delta)
				text("GMote",
				     font="Liberation Sans:style=Bold Italic",
				     valign="center",
				     size=8
				);
		translate([bat_x-1.8*bwd,1.5*bat_y/2,bat_z+brd_z+2.75*bwd])
		rotate([0,0,90])
		linear_extrude(height=bwd/4+delta)
				text("Mini",
				     font="Liberation Sans:style=Bold Italic",
				     valign="center",
				     size=3
				);
	}
}

// sensor rest (moisture)
translate([bat_x+2*bwd-(ms_inside-ms_rl),0,bat_z+brd_z+2*bwd-ms_ch-ms_t-ms_rt/2]) {
	// moisture
	hull() {
		translate([-(ms_rlo-dfit)/2,0,0])
			cube([ms_rlo-dfit,delta,ms_rt]);
		translate([0,bwd+(bat_y-ms_w)/2,0])
			shim(ms_rlo-dfit,ms_rli-dfit,ms_rd-dfit,ms_rt);
	}
	translate([0,bwd,0])
		cube([ms_inside-ms_rl,(bat_y-ms_w)/2-dfit/2,ms_rt]);
	hull() {
		translate([-(ms_rlo-dfit)/2,bat_y+2*bwd,0])
			cube([ms_rlo-dfit,delta,ms_rt]);
		translate([0,bat_y+bwd-(bat_y-ms_w)/2,0])
			shim(ms_rlo-dfit,ms_rli-dfit,-ms_rd+dfit,ms_rt);
	}
	translate([0,bat_y+bwd-(bat_y-ms_w)/2+dfit/2,0])
		cube([ms_inside-ms_rl,(bat_y-ms_w)/2,ms_rt]);
	// ground plate
	translate([-(ms_rlo-dfit)/2,0,0])
		cube([ms_inside-ms_rl,bat_y+2*bwd,ms_rt/2-dfit/2]);

	// us additional rest
	/*
	translate([-bat_x-bwd+(ms_inside-ms_rl),bwd,0])
		cube([bwd,bwd,ms_rt]);
	translate([-bat_x-bwd+(ms_inside-ms_rl),us_y,0])
		cube([bwd,bwd,ms_rt]);
	*/
}

}

module case_bottom() {
	intersection() {
		fullcase02(0,0,0);
		cube([100,100,ms_sh]);
	}
	difference() {
		translate([bwd/2,bwd/2,ms_sh])
			lock(bat_x+bwd,bat_y+bwd,lockr);
		translate([bwd,bwd+(bat_y-ms_w)/2-dfit/2,0])
			cube([100,ms_w+dfit,100]);
	}
}

module case_top() {
	translate([0,0,-ms_sh]) {
		//rotate([-110,0,0])
		difference() {
		intersection() {
			fullcase02(0,0,0);
			translate([0,0,ms_sh])
				cube([100,100,100]);
		}
		translate([bwd/2,bwd/2,ms_sh])
			lock(bat_x+bwd,bat_y+bwd,lockr);
		}
	}
}

// sensors

module us_sensor() {
	color("red") 
		cube([us_x,us_y,us_z]);
	color("silver") {
		translate([us_dx,us_y/2,us_z])
			cylinder(r=us_r,h=us_sh);
		translate([us_x-us_dx,us_y/2,us_z])
			cylinder(r=us_r,h=us_sh);
	}
}

module ms_sensor() {
	color("SaddleBrown") {

	difference() {
		cube([ms_l,ms_w,ms_t]);
		union() {
			translate([ms_rl,0,-delta]) {
				hull() {
					shim(ms_rlo,ms_rli,ms_rd,ms_t+2*delta);
					translate([-ms_rlo/2,-1,0])
						cube([ms_rlo,1,ms_t]);
				}
				translate([0,ms_w-ms_rd,0]) hull() {
					shim(ms_rli,ms_rlo,ms_rd,ms_t+2*delta);
					translate([-ms_rlo/2,ms_rd,0])
						cube([ms_rlo,1,ms_t]);
				}
			}
		 }
	}
	// tip
	translate([ms_l-1,0,0]) {
		hull() {
			cube([1,ms_w,ms_t]);
			translate([ms_lt-ms_l,ms_w/2,0]) cube([0.01,0.01,ms_t]);
		}
	}

	}
	color("grey") {
		translate([-ms_cl/2,(ms_w-ms_cw)/2,ms_t])
		cube([ms_cl,ms_cw,ms_ch]);
	}
}

module ms_closing() {
	hull() {
		cube([ms_w+1.5*dfit,ms_t+1.5*dfit,delta]);
		translate([1.25*dfit,1.25*dfit,bwd])
			cube([ms_w-dfit,ms_t-dfit,delta]);
	}
}

module us_closing() {
	cylinder(r2=us_r+1.5*dfit,r1=us_r-dfit,h=bwd);
	translate([us_x-2*us_dx,0,0])
		cylinder(r2=us_r+1.5*dfit,r1=us_r-dfit,h=bwd);
}

// printable

// everything
/**/
translate([0,0,0]) {
	translate([0,bat_y+4*bwd,0]) {
		case_bottom();
	}
	case_top();
	translate([bat_x+4*bwd+us_dx,us_r+bwd,0])
		us_closing();
	translate([bat_x+4*bwd+us_dx,bat_y-2*bwd,0])
		ms_closing();
}
/**/

// bottom
//case_bottom();
// top
//case_top();
// us closing
//us_closing();
// ms closing
//ms_closing();

// showcase

/*
translate([0,2*(bat_y+4*bwd),0]) {
	fullcase02(0,0,0);
	translate([bwd+dfit,bwd+dfit,bat_z+brd_z+2*bwd-us_z-dfit])
		us_sensor();
	translate([bwd+bat_x+bwd+2*dfit,bwd+(bat_y-ms_w)/2-0.75*dfit,ms_sh+ms_t/2+dfit])
		rotate([0,-90,0]) rotate([0,0,90]) ms_closing();
}

translate([0,3*(bat_y+4*bwd),0]) {
	fullcase02(0,0,0);
	translate([bat_x+2*bwd-ms_inside,(bat_y+2*bwd-ms_w)/2,bat_z+brd_z+2*bwd-ms_ch-ms_t])
		ms_sensor();
	translate([bwd+us_dx+dfit,bwd+us_y/2+dfit,bat_z+brd_z+2*bwd+2*dfit]) us_closing();
}

translate([bat_x+6*bwd,bat_y+4*bwd,0]) {
	ms_sensor();
}

translate([bat_x+6*bwd,bat_y+6*bwd+ms_w,0]) {
	us_sensor();
}

translate([bat_x+6*bwd,3.2*(bat_y+4*bwd),ms_ch+ms_t+bwd]) {
	rotate([-180,0,0]) case_top();
}

*/
