

//get movement in 8 directions from WASD
var moveXInput = 0;
var moveYInput = 0;
for (var i = 0; i < array_length_1d(heroKey); i++) 
{
    var this_key = heroKey[i];
    if keyboard_check(this_key) 
	{
        var this_angle = i * 90;
        moveXInput += lengthdir_x(1, this_angle);
        moveYInput += lengthdir_y(1, this_angle);
    }
}
var isMovePressed = (point_distance(0, 0, moveXInput, moveYInput) > 0);

if(isMovePressed)
{	
	//regular walking
	if(!target.isAttacking)
	{
		//apply acceleration
	    moveSpeed += heroMoveSpeedAcceleration;
		moveSpeed = min(moveSpeed, heroMoveSpeedMax);		
	}
	
	//walking while attacking
	else 
	{		
		//too fast
		if(moveSpeed > heroMoveSpeedMaxAttack) 
		{
			//woah there slow down buddy
			moveSpeed -= heroMoveSpeedBraking;
		}
		
		//at or under speed limit
		else 
		{
			//apply acceleration
		    moveSpeed += heroMoveSpeedAcceleration;
			moveSpeed = min(moveSpeed, heroMoveSpeedMaxAttack);
		}
	}
	
	//only record the direction when pressed so braking/momentum continues in same direction
	moveDir = point_direction(0, 0, moveXInput, moveYInput);	
}
else
{
	//apply braking
	moveSpeed -= heroMoveSpeedBraking;
	moveSpeed = max(moveSpeed, heroMoveSpeedMin);
}

//attack key action
if keyboard_check(heroKeyAttack)
{
	target.isAttacking = true;
}

//for 3d audio
var emitterVX = 0;
var emitterVY = 0;	

if(moveSpeed > 0)
{	
	//calculate movement
	var moveSpeedFrame = moveSpeed * timeBasedCounter.secondsPassed;
	var deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	var deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	var tileData = tilemap_get_at_pixel(tileController.blockingMapId, target.x + deltaX, target.y + deltaY);
	var tileIndex = tile_get_index(tileData);
	var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
		
	//tile layer collision	
	if(!tileData || isDestroyed) 
	{
		//apply movement to instance
	    target.x += deltaX;
	    target.y += deltaY;
		emitterVX = deltaX;
		emitterVY = deltaY;	
	}

	//try to slide into an empty or destroyed tile
	else 
	{
		var tileDataX = tilemap_get_at_pixel(tileController.blockingMapId, target.x + deltaX, target.y);
		var tileIndex = tile_get_index(tileDataX);
		var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
				
		if(!tileDataX || isDestroyedX)
		{
			//apply move
			target.x += deltaX;	
			emitterVX = deltaX;
			emitterVY = 0;	
		}
		else 
		{
			var tileDataY = tilemap_get_at_pixel(tileController.blockingMapId, target.x, target.y + deltaY);
			var tileIndex = tile_get_index(tileDataY);
			var isDestroyedY = ((tileIndex+1) mod blockingTilesetWidth == 0);
			if(!tileDataY || isDestroyedY)
			{
				//apply move
				target.y += deltaY;	
				emitterVX = 0;
				emitterVY = deltaY;	
			}
		}
	}
	
	//edge collision
	target.x = min( max(target.x, roomBorderBlocking), (room_width - roomBorderBlocking));
	target.y = min( max(target.y, roomBorderBlocking), (room_height - roomBorderBlocking));	

	//get camera center
	centerCameraX = (cameraX + cameraWidth/2);
	centerCameraY = (cameraY + cameraHeight/2);

	//if target outside middle area, camera follows
	if(abs(target.x - centerCameraX) > cameraXBorder)
	{
		cameraX	+= deltaX;
	}
	if(abs(target.y - centerCameraY) > cameraYBorder)
	{
		cameraY	+= deltaY;
	}

	//limit camera to room
	var limitedCameraX = min( max(cameraX, 0), (room_width-cameraWidth));
	var limitedCameraY = min( max(cameraY, 0), (room_height-cameraHeight));

    //actually move the camera
	camera_set_view_pos(view_camera[0], limitedCameraX, limitedCameraY);	
}

//update 3d audio velocity
audio_listener_velocity(emitterVX, emitterVY, 0);	

//target animation doesn't stop moving until braking completed
target.isMoving = (moveSpeed > 0);

target.depth = -target.y;
