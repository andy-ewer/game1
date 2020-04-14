//************
//INIT
//************

//get current hero blocking grid cell
gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x, target.y);
gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x, target.y);

isControlEnabled = true;


//************
//DO EVERYTHING
//************
heroController_handleDoors();
if(isControlEnabled)
{
	heroController_controls();
}
heroController_move();


//************
//AUDIO
//************

//update 3d audio
audio_listener_position(target.x, target.y, 0);
audio_listener_velocity(deltaX, deltaY, 0);	


