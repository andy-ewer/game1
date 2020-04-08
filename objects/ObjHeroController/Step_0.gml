

if(controls.isMovePressed)
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
	moveDir = point_direction(0, 0, controls.moveXInput, controls.moveYInput);	
}
else
{
	//apply braking
	moveSpeed -= heroMove_braking;
	moveSpeed = max(moveSpeed, heroMove_min);
}

//attack key action
if (controls.isAttackPressed)
{
	target.isAttacking = true;
}

//for 3d audio
var emitterVX = 0;
var emitterVY = 0;	

if(moveSpeed > 0)
{	
	//calculate movement
	var moveSpeedFrame = moveSpeed * timing.secondsPassed;
	deltaX = (lengthdir_x(moveSpeedFrame, moveDir));
	deltaY = (lengthdir_y(moveSpeedFrame, moveDir)); 

	var tileData = tilemap_get_at_pixel(blockers.blockingMapId, target.x + deltaX, target.y + deltaY);
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
		var tileDataX = tilemap_get_at_pixel(blockers.blockingMapId, target.x + deltaX, target.y);
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
			var tileDataY = tilemap_get_at_pixel(blockers.blockingMapId, target.x, target.y + deltaY);
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
}

//update 3d audio velocity
audio_listener_velocity(emitterVX, emitterVY, 0);	

//target animation doesn't stop moving until braking completed
target.isMoving = (moveSpeed > 0);

target.depth = -target.y;
