//get bumps with other zombies, hero
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy1, list, false);
var qtyBumpsHero = instance_place_list(x, y, objHero, list, false);


//iterate the bumps
for(var i=0; i< (qtyBumps + qtyBumpsHero); ++i) {


	//**********************************************
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

	
	//**********************************************
	//check for tile collision
	var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);
	var tileIndex = tile_get_index(tileData);
	var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);
	var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);		
	var tileInfo = root.blockers.tileInfo[# gridX, gridY];		
	if(!isHero)
	{
		var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
		var isDoorOpen = (tileInfo[tileInfo_type] == tileType_doorOpen);
		var isBlocked = tileData && !isDestroyed && !isDoorOpen;
	}
	else
	{
		var isBlocked = heroController_check4Points(deltaX, deltaY, bump, true);
	}

	//**********************************************
	//clear, push the target
	if(!isBlocked)
	{
		//apply movement to instance
		bump.x += deltaX;
		bump.y += deltaY;
		if(isHero)
		{
			bump.x = min( max(bump.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
			bump.y = min( max(bump.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));
			bump.weapon.x = bump.x;
			bump.weapon.y = bump.y;
		}
	}
	
	//**********************************************
	//blocked, apply any damage and then try to slide the target
	else 
	{
		
		//*****
		//blocker damage is caused when a baddy pushes another baddy into a blocker
		if(!isHero)
		{
			tileInfo[tileInfo_currentDamage] += root.timing.ticksPassed; //1 damage per tick at target frame rate, scaled to the actual frame rate

			//if we have gone over max damage, increment to next damage step and reset damage done to 0.
			if(tileInfo[tileInfo_currentDamage] >= tileInfo[tileInfo_maxDamage])
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
				tileInfo[tileInfo_currentDamage] = 0;					
			}
				
			//apply changes to the tile
			tileData = tilemap_set(root.blockers.blockingMapId, tileData, gridX, gridY);
				
			//apply change to the damage on this tile
			root.blockers.tileInfo[# gridX, gridY] = tileInfo;
		}
			
			
		//*****
		//slide X or Y
			
		//slide X
			
		if(!isHero)
		{
			var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y);
			var tileIndex = tile_get_index(tileData);
			var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y);
			var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y);		
			var tileInfo = root.blockers.tileInfo[# gridX, gridY];
	
			var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
			var isDoorOpen = (tileInfo[tileInfo_type] == tileType_doorOpen);			
			var isBlocked = tileData && !isDestroyed && !isDoorOpen;
		}
		else
		{
			var isBlocked = heroController_check4Points(deltaX, 0, bump, true);
		}
			
		if(!isBlocked)
		{
			//apply move
			bump.x += deltaX;	
			if(isHero)
			{
				bump.x = min( max(bump.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
				bump.y = min( max(bump.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));
				bump.weapon.x = bump.x;
			}								
		}
		else
		{
				
			//slide Y
			if(!isHero)
			{
				var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x, bump.y + deltaY);
				var tileIndex = tile_get_index(tileData);
				var gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, bump.x, bump.y + deltaY);
				var gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, bump.x, bump.y + deltaY);		
				var tileInfo = root.blockers.tileInfo[# gridX, gridY];
	
				var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
				var isDoorOpen = (tileInfo[tileInfo_type] == tileType_doorOpen);
				var isBlocked = tileData && !isDestroyed && !isDoorOpen;
			}
			else
			{
				var isBlocked = heroController_check4Points(0, deltaY, bump, true);
			}
			
			if(!isBlocked)
			{
				//apply move
				bump.y += deltaY;	

				if(isHero)
				{
					bump.x = min( max(bump.x, hero_roomBorderBlocking), (room_width - hero_roomBorderBlocking));
					bump.y = min( max(bump.y, hero_roomBorderBlocking), (room_height - hero_roomBorderBlocking));
					bump.weapon.y = bump.y;
				}				

			}
		}
	}
}

ds_list_destroy(list);