
//get camera center
centerCameraX = (cameraX + global.aspectViewWidth/2);
centerCameraY = (cameraY + global.aspectViewHeight/2);

//if target outside middle area, camera follows
if((target.x - centerCameraX) > camera_xBorder)
{
	cameraX	+= (target.x - centerCameraX - camera_xBorder);
}

if((target.x - centerCameraX) < -camera_xBorder)
{
	cameraX	+= (target.x - centerCameraX + camera_xBorder);
}
	
if((target.y - centerCameraY) > camera_yBorder)
{
	cameraY	+= (target.y - centerCameraY - camera_yBorder);
}

if((target.y - centerCameraY) < -camera_yBorder)
{
	cameraY	+= (target.y - centerCameraY + camera_yBorder);
}

//limit camera to room
var limitedCameraX = min( max(cameraX, 0), (room_width-global.aspectViewWidth));
var limitedCameraY = min( max(cameraY, 0), (room_height-global.aspectViewHeight));

//actually move the camera
camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);	


