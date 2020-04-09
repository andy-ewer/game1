
if(root.heroController.moveSpeed > 0 )
{
	//get camera center
	centerCameraX = (cameraX + camera_width/2);
	centerCameraY = (cameraY + camera_height/2);

	//if target outside middle area, camera follows
	if(abs(target.x - centerCameraX) > camera_xBorder)
	{
		cameraX	+= root.heroController.deltaX;
	}
	if(abs(target.y - centerCameraY) > camera_yBorder)
	{
		cameraY	+= root.heroController.deltaY;
	}

	//limit camera to room
	var limitedCameraX = min( max(cameraX, 0), (room_width-camera_width));
	var limitedCameraY = min( max(cameraY, 0), (room_height-camera_height));

    //actually move the camera
	camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);	
}