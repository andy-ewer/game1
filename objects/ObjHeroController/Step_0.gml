//************
//CONTROLS
//************

if(root.controls.isMovePressed)
{	
	//regular walking
	if(!target.isAttacking)
	{
		//apply acceleration
	    moveSpeed += heroMove_acceleration;
		moveSpeed = min(moveSpeed, heroMove_max);		
	}
	
	//walking while attacking
	else 
	{		
		//too fast
		if(moveSpeed > heroMove_maxAttack) 
		{
			//woah there slow down buddy
			moveSpeed -= heroMove_braking;
		}
		
		//at or under speed limit
		else 
		{
			//apply acceleration
		    moveSpeed += heroMove_acceleration;
			moveSpeed = min(moveSpeed, heroMove_maxAttack);
		}
	}
	
	//only record the direction when pressed so braking/momentum continues in same direction
	moveDir = point_direction(0, 0, root.controls.moveXInput, root.controls.moveYInput);	
}
else
{
	//apply braking
	moveSpeed -= heroMove_braking;
	moveSpeed = max(moveSpeed, heroMove_min);
}


//************
//MOVEMENT
//************

if(moveSpeed > 0)
{
	target.isMoving = true;
	
	//calculate movement
	var moveSpeedFrame = moveSpeed * root.timing.secondsPassed;
	deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX, target.y + deltaY);
	var tileIndex = tile_get_index(tileData);
	var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);


	var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x + deltaX, target.y + deltaY);
	var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x + deltaX, target.y + deltaY);
	var tileDamage = root.blockers.tileDamage[# gridX, gridY];
	var isDoor = ( tileDamage[tileInfo_type] ==  tileType_door);

	//tile layer collision	
	if(!tileData || isDestroyed || isDoor) 
	{
		//apply movement to instance
	    target.x += deltaX;
	    target.y += deltaY;
	}

	//try to slide into an empty or destroyed tile
	else 
	{
		var tileDataX = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x + deltaX, target.y);
		var tileIndex = tile_get_index(tileDataX);
		var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
				
		if(!tileDataX || isDestroyedX)
		{
			//apply move
			target.x += deltaX;	
			deltaY = 0;
		}
		else 
		{
			var tileDataY = tilemap_get_at_pixel(root.blockers.blockingMapId, target.x, target.y + deltaY);
			var tileIndex = tile_get_index(tileDataY);
			var isDestroyedY = ((tileIndex+1) mod blockingTilesetWidth == 0);
			if(!tileDataY || isDestroyedY)
			{
				//apply move
				target.y += deltaY;	
				deltaX = 0;
			}
		}
	}
	
	//edge collision
	target.x = min( max(target.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
	target.y = min( max(target.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));	
}
else 
{
	//target animation doesn't stop moving until braking completed	
	target.isMoving = false;
}
target.depth = -target.y;



//************
//AUDIO
//************

//update 3d audio
audio_listener_position(target.x, target.y, 0);
audio_listener_velocity(deltaX, deltaY, 0);	


