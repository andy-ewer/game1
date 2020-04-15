
//tile layer collision	
var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, x + deltaX, y + deltaY);

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
	var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, x + deltaX, y + deltaY);
	var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, x + deltaX, y + deltaY);
	var tileDamage = root.blockers.tileDamage[# gridX, gridY];
	var tileIndex = tile_get_index(tileData);
	
	var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
	var isDoorOpen = (tileDamage[tileInfo_type] == tileType_doorOpen);

	//destroyed tiles are passable
	if(isDestroyed || isDoorOpen)
	{
		//apply move
		x += deltaX;	
		y += deltaY;
		emitterVX = deltaX;
		emitterVY = deltaY;
		lastDirX = 0;		
		lastDirY = 0;	
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
			
			var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, x + deltaX, y);
			var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, x + deltaX, y);
			var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, x + deltaX, y);
			var tileDamage = root.blockers.tileDamage[# gridX, gridY];
			var tileIndex = tile_get_index(tileData);
			
			var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
			var isDoorOpen = (tileDamage[tileInfo_type] == tileType_doorOpen);
						
			if(!tileData || isDestroyed || isDoorOpen)
			{				
				deltaY = 0;
	
				//apply move
				x += deltaX;
				emitterVX = deltaX;
				emitterVY = 0;				
				
				var thisDirX = deltaX < 0;
				if((lastDirX != thisDirX && lastDirX != 0) || deltaX == 0)
				{
					mood = b1Mood_FinalLook;
					finalLookCounter = irandom(b1Final_lookCounterRandom) + b1Final_lookCounterPlus;
				}
				lastDirX = thisDirX;
				lastDirY = 0;
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

				var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, x, y + deltaY);
				var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, x, y + deltaY);
				var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, x, y + deltaY);
				var tileDamage = root.blockers.tileDamage[# gridX, gridY];				
				var tileIndex = tile_get_index(tileData);
				
				var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
				var isDoorOpen = (tileDamage[tileInfo_type] == tileType_doorOpen);				
				
				if(!tileData || isDestroyed || isDoorOpen)
				{
					deltaX = 0;

					//apply move
					y += deltaY;	
					emitterVX = 0;
					emitterVY = deltaY;

					var thisDirY = deltaY < 0;
					if((lastDirY != thisDirY && lastDirY != 0) || deltaY == 0)
					{
						mood = b1Mood_FinalLook;
						finalLookCounter = irandom(b1Final_lookCounterRandom) + b1Final_lookCounterPlus;
					}
					lastDirY = thisDirY;
					lastDirX = 0;
				}
				else
				{
					//if stuck in a corner, give up trying to reach the spot
					if(mood == b1Mood_LastSeen)
					{
						mood = b1Mood_FinalLook;
						finalLookCounter = irandom(b1Final_lookCounterRandom) + b1Final_lookCounterPlus;
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