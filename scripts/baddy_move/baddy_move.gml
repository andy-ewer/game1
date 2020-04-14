//tile layer collision	
var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, x + deltaX, y + deltaY);
var isDestroyed = false;

//keep track of velocity to apply to 3d audio
var emitterVX = 0;
var emitterVY = 0;

//no tile
if(!tileData)
{
	//apply move
	x += deltaX;	
	y += deltaY;	
	emitterVX = deltaX;
	emitterVY = deltaY;	
}

//there is a tile
else
{
	var tileIndex = tile_get_index(tileData);
	isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);

	//destroyed tiles are passable
	if(isDestroyed)
	{
		//apply move
		x += deltaX;	
		y += deltaY;
		emitterVX = deltaX;
		emitterVY = deltaY;	
	}
	
	//try to slide into an empty or destroyed tile
	else 
	{
		if(mood == b1Mood_Idle)
		{
			idleDirection += (irandom(b1Idle_directionAngleRandom) - (b1Idle_directionAngleRandom/2));	
			idleDirection = fixAngle(idleDirection);
		}
		else
		{

			//try along X
			if(deltaX < 0)
			{
				deltaX = (lengthdir_x(moveSpeedFrame, 180));
			}
			else
			{
				deltaX = (lengthdir_x(moveSpeedFrame, 0));
			}				
			
			var tileDataX = tilemap_get_at_pixel(root.blockers.blockingMapId, x + deltaX, y);
			var tileIndex = tile_get_index(tileDataX);
			var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
						
			if(!tileDataX || isDestroyedX)
			{				
				deltaY = 0;
	
				//apply move
				x += deltaX;
				emitterVX = deltaX;
				emitterVY = 0;	
			}
			else 
			{
				//try along y
				if(deltaY < 0)
				{
					deltaY = (lengthdir_y(moveSpeedFrame, 90));
				}
				else
				{
					deltaY = (lengthdir_y(moveSpeedFrame, 270));
				}				

				var tileDataY = tilemap_get_at_pixel(root.blockers.blockingMapId, x, y + deltaY);
				var tileIndex = tile_get_index(tileDataY);
				var isDestroyedY = ((tileIndex+1) mod blockingTilesetWidth == 0);
				
				if(!tileDataY || isDestroyedY)
				{
					deltaX = 0;
					
					//apply move
					y += deltaY;	
					emitterVX = 0;
					emitterVY = deltaY;	
				}
				else
				{
					//if stuck in a corner, give up trying to reach the spot
					if(mood == b1Mood_LastSeen)
					{
						mood = b1Mood_FinalLook;	
					}
				}
			}
		}
	}
}

//**********************
//MOVE AUDIO
//**********************

//update audio position
audio_emitter_position(emitter,x,y,0);
audio_emitter_velocity(emitter, emitterVX, emitterVY, 0);	