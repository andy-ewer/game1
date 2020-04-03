//setttings
#macro moveSpeedMin 0
#macro moveSpeedMax 50
#macro moveSpeedMaxAttack 20
#macro moveSpeedAcceleration 5
#macro moveSpeedBraking 5
#macro cameraWidth 256
#macro cameraHeight 192

//create instance to control
target = instance_create_layer(100, 100, "Instances", objHero);

//keys
heroKey[0] = ord("D");
heroKey[1] = ord("W");
heroKey[2] = ord("A");
heroKey[3] = ord("S");
heroKeyAttack = ord(" ");

//init
moveSpeed = moveSpeedMin;
target.depth = -target.y;
moveDir = point_direction(0, 0, 0, 0);

//view
view_enabled = true;
view_set_visible(0, true);
view_set_wport(0, cameraWidth);
view_set_hport(0, cameraHeight);

//camera
camera_set_view_pos(view_camera[0], 0, 0);
camera_set_view_size(view_camera[0], cameraWidth, cameraHeight);



