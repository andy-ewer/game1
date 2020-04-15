
//get bumps with other zombies
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy1, list, false);
var qtyBumpsHero = instance_place_list(x, y, objHero, list, false);
//list = ds_list_shuffle(list);

//iterate the bumps
for(var i=0; i< (qtyBumps + qtyBumpsHero); ++i) {

	if(mood == b1Mood_Idle)
	{
		idleDirection += (irandom(b1Idle_directionAngleRandom) - (b1Idle_directionAngleRandom/2));	
		idleDirection = fixAngle(idleDirection);
	}

	//get bump details
	var bump = list[| i];
	var isHero = (bump.object_index == objHero);
	var dir = point_direction(x, y, bump.x, bump.y);
	var dist = point_distance(x, y, bump.x, bump.y);
	var distMultiplier = b1Behaviour_distMultiplierMax-max(min(dist, b1Behaviour_distMultiplierMax),1);
	
				
	//calculate attempted shove
	var bumpSpeedFrame;
	if(mood == b1Mood_Idle)
	{
		bumpSpeedFrame = b1Speed_idleBump * root.timing.secondsPassed;
	}
	else
	{
		bumpSpeedFrame = b1Speed_bump * root.timing.secondsPassed;
	}
	var deltaX = (lengthdir_x(bumpSpeedFrame * distMultiplier, dir));
	var deltaY = (lengthdir_y(bumpSpeedFrame * distMultiplier, dir)); 
	
	if(!isHero)
	{
		var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);
		var isBlocked = tileData;
	}
	else
	{
		var isBlocked = heroController_check4Points(deltaX, deltaY, bump, true);
	}

	//no tile, go for it
	if(!isBlocked)
	{
		//apply movement to instance
		bump.x += deltaX;
		bump.y += deltaY;
		if(isHero)
		{
			bump.x = min( max(bump.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
			bump.y = min( max(bump.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));
		}
	}
	
	//there is a tile
	else if(!isHero)
	{
		//tile damage
		var tileIndex = tile_get_index(tileData);
		var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
			
		//no tile
		if(isDestroyed)
		{
			//apply movement to instance
			bump.x += deltaX;
			bump.y += deltaY;
		
		}
		
		//there is a tile
		else 
		{
			//apply damage

			//get grid position of tile
			var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);
			var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);
				
			//get the damage and increment
			var tileDamage = root.blockers.tileDamage[# gridX, gridY];
			tileDamage[tileInfo_currentDamage] += root.timing.ticksPassed; //1 damage per tick at target frame rate, scaled to the actual frame rate

			//if we have gone over max damage, increment to next damage step and reset damage done to 0.
			if(tileDamage[tileInfo_currentDamage] >= tileDamage[tileInfo_maxDamage])
			{
				tileIndex++;
				tileData = tile_set_index(tileData, tileIndex);	
					
				//if this is the final destroyed step
				if((tileIndex+1) mod blockingTilesetWidth == 0)
				{
					//randomly flips rubble texture for more variety
					if(irandom(1)==0)
					{
						tileData = tile_set_flip(tileData, true);
					}
					audio_play_sound_on(emitter, sndTileBreak, 0, round(b1Audio_falloffDist-dist));
				}
				else
				{
					audio_play_sound_on(emitter, sndTileDamage, 0, round(b1Audio_falloffDist-dist));
				}
				tileDamage[tileInfo_currentDamage] = 0;					
			}
				
			//apply changes to the tile
			tileData = tilemap_set(root.blockers.blockingMapId, tileData, gridX, gridY);
				
			//apply change to the damage on this tile
			root.blockers.tileDamage[# gridX, gridY] = tileDamage;
			
			//try to slide either way through empty or destroyed tile
			var tileDataX = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y);
			var tileIndex = tile_get_index(tileDataX);
			var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
			
			var tileDataY = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x, bump.y + deltaY);
			var tileIndex = tile_get_index(tileDataY);
			var isDestroyedY = ((tileIndex+1) mod blockingTilesetWidth == 0);
				
			if(!tileDataX || isDestroyedX)
			{
				//apply move
				bump.x += deltaX;	
			}
			else if(!tileDataY || isDestroyedY)
			{
				//apply move
				bump.y += deltaY;	
			}
		}
	}
}
ds_list_destroy(list);