
//camera
#macro camera_xBorder 40
#macro camera_yBorder 10

//grab player object
target = root.heroController.target;

//view
view_enabled = true;
view_set_visible(0, true);

//camera
cameraX = target.x - (global.aspectViewWidth/2);
cameraY = target.y - (global.aspectViewHeight/2);
var limitedCameraX = min( max(cameraX, 0), room_width);
var limitedCameraY = min( max(cameraY, 0), room_height);
camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);
camera_set_view_size(view_camera[0], global.aspectViewWidth, global.aspectViewHeight);

