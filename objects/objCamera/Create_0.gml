//camera
#macro camera_width 480
#macro camera_height 270
#macro camera_xBorder 40
#macro camera_yBorder 10

//grab player object
target = heroController.target;

//view
view_enabled = true;
view_set_visible(0, true);
view_set_wport(0, camera_width);
view_set_hport(0, camera_height);

//camera
cameraX = target.x - (camera_width/2);
cameraY = target.y - (camera_height/2);
var limitedCameraX = min( max(cameraX, 0), room_width);
var limitedCameraY = min( max(cameraY, 0), room_height);
camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);
camera_set_view_size(view_camera[0], camera_width, camera_height);
