//**********************
//INIT
//**********************

//get this and the hero grid position
thisX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, x, y);
thisY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, x, y);
heroX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, root.heroController.target.x, root.heroController.target.y);
heroY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, root.heroController.target.x, root.heroController.target.y);
dist = point_distance(thisX, thisY, heroX, heroY);


//**********************
//DO EVERYTHING
//**********************

baddy_lineOfSight();
baddy_animate();
baddy_chase();
baddy_move();
baddy_herd();


//**********************
// MISC
//**********************

//edge collision
x = min( max(x, b1Behaviour_roomBorderBlocking), (room_width - b1Behaviour_roomBorderBlocking));
y = min( max(y, b1Behaviour_roomBorderBlocking), (room_height - b1Behaviour_roomBorderBlocking));	

depth = round(-y);