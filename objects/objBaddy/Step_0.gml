//**********************
//INIT
//**********************

//get this and the heroes grid position
var thisX = tilemap_get_cell_x_at_pixel(tileController.blockingMapId, x, y);
var thisY = tilemap_get_cell_y_at_pixel(tileController.blockingMapId, x, y);
var heroX = tilemap_get_cell_x_at_pixel(tileController.blockingMapId, objHero.x, objHero.y);
var heroY = tilemap_get_cell_y_at_pixel(tileController.blockingMapId, objHero.x, objHero.y);
var dist = point_distance(thisX, thisY, heroX, heroY);

//update line of sight occasionally for performance
sightCounter -= timeBasedCounter.ticksPassed;
if(sightCounter<0)
{
	//don't check if out of range
	if(
		mood == baddyMoodIdle && dist>idleSightDistance
		||
		mood != baddyMoodIdle && dist>alertSightDistance
	)
	{
		sightClear = false;
	}

	//in range, so check
	else
	{
		sightClear = gridLineOfSightClear(thisX, thisY, heroX, heroY);
		sightCounter = updateSightTicks;

		//update the last seen position of the hero
		if(sightClear)
		{
			lastSeenX = objHero.x;
			lastSeenY = objHero.y;
		}
	}
}


//update audio position
audio_emitter_position(emitter,x,y,0);


//**********************
//ANIMATE
//**********************

//steps are erratic
stepCounter -= timeBasedCounter.ticksPassed;
if(stepCounter<0)
{
	if(image_index == idleEnd)
	{
		image_index = idleStart;
	}
	else if(image_index == walkEnd)
	{
		image_index = walkStart;
	}
	else if(image_index == mouthEnd)
	{
		image_index = mouthStart;
	}	
	else
	{
		image_index++;
	}
	stepCounter = irandom(stepRandom)+stepPlus;
}

//idle state - scan for the hero to chase	
if(mood == baddyMoodIdle)
{
	//change direction randomly
	idleDirectionCounter -= timeBasedCounter.ticksPassed;
	if(idleDirectionCounter < 0)
	{
		idleDirection += (irandom(idleDirectionAngleRandom) - (idleDirectionAngleRandom/2));	
		idleDirection = fixAngle(idleDirection);
		idleDirectionCounter = irandom(idleDirectionCounterRandom + idleDirectionCounterPlus);
	}
	
	//look for hero
	if(sightClear) {
			
		//can see the hero - give chase
		mood = baddyMoodChase;
		image_index = mouthStart;
		mouthCounter = irandom(mouthOpenRandom)+mouthOpenPlus;
			
		//make a noise
		if(dist < voiceGridDistance)
		{	
			audio_play_sound_on(emitter, voiceSound, 0, round(voiceGridDistance-dist));
		}
	}
	
	//get potential move point 
	var moveSpeedFrame = idleSpeed * timeBasedCounter.secondsPassed;
	var deltaX = (lengthdir_x(moveSpeedFrame, idleDirection));
	var deltaY = (lengthdir_y(moveSpeedFrame, idleDirection));
}

//chase state
else if(mood == baddyMoodChase || mood == baddyMoodLastSeen || mood == baddyMoodFinalLook)
{
	//mouth opens and closes
	mouthCounter -= timeBasedCounter.ticksPassed;
	if(mouthCounter<0)
	{
		if(image_index <= walkEnd)
		{
			image_index+= 4;
			mouthCounter = irandom(mouthOpenRandom)+mouthOpenPlus;

			//make a noise
			if(dist < voiceGridDistance)
			{
				audio_play_sound_on(emitter, voiceSound, 0, round(voiceGridDistance-dist));
			}
		}
		else
		{
			image_index-= 4;
			mouthCounter = irandom(mouthClosedRandom)+mouthClosedPlus; 	
		}	
	}
	
	//get potential move point 	
	var moveSpeedFrame;
	if(image_index <= walkEnd)
	{
		moveSpeedFrame = walkSpeed * timeBasedCounter.secondsPassed; //regular walking speed
	}
	else
	{
		moveSpeedFrame = mouthSpeed * timeBasedCounter.secondsPassed; //zombies with mouths open move faster
	}		
	
	//revert to chase if line of sight to hero
	if(sightClear)
	{		
		mood = baddyMoodChase;	
		var dir = point_direction(x, y, objHero.x, objHero.y);
	}
	
	//can't see hero
	else
	{
		//baddyMoodFinalLook
		if(mood == baddyMoodFinalLook)
		{
			finalLookCounter -= timeBasedCounter.ticksPassed;
			if(finalLookCounter < 0)
			{
				//return to idle
				mood = baddyMoodIdle
				image_index = idleStart;
				var dir = lastDir;
			}
			else
			{
				//keep going
				var dir = lastDir;
			}		
		}
		
		//baddyMoodLastSeen
		else
		{		
			//at last known location
			if( abs(y-lastSeenY) < lastSeenArrivedRange && abs(x-lastSeenX) < lastSeenArrivedRange)
			{
				mood = baddyMoodFinalLook;
				lastDir += (irandom(idleDirectionAngleRandom) - (idleDirectionAngleRandom/2));
				var dir = lastDir;
				finalLookCounter = irandom(finalLookCounterRandom) + finalLookCounterPlus;
			}
		
			//head to last known location
			else
			{
				mood = baddyMoodLastSeen;	
				var dir = point_direction(x, y, lastSeenX, lastSeenY);
				lastDir = dir;
			}
		}
	}
	var deltaX = (lengthdir_x(moveSpeedFrame, dir));
	var deltaY = (lengthdir_y(moveSpeedFrame, dir));
}


//**********************
//MOVE
//**********************

	
//tile layer collision	
var tileData = tilemap_get_at_pixel(tileController.blockingMapId, x + deltaX, y + deltaY);
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
		if(mood == baddyMoodIdle)
		{
			idleDirection += (irandom(idleDirectionAngleRandom) - (idleDirectionAngleRandom/2));	
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
			
			var tileDataX = tilemap_get_at_pixel(tileController.blockingMapId, x + deltaX, y);
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

				var tileDataY = tilemap_get_at_pixel(tileController.blockingMapId, x, y + deltaY);
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
					if(mood == baddyMoodLastSeen)
					{
						mood = baddyMoodFinalLook;	
					}
				}
			}
		}
	}
}

//apply velocity for 3d audio
audio_emitter_velocity(emitter, emitterVX, emitterVY, 0);	

//**********************
//HERD BEHAVIOUR
//**********************

//get bumps with other zombies
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy, list, false);

//iterate the bumps
for(var i=0; i<qtyBumps; ++i) {

	if(mood == baddyMoodIdle)
	{
		idleDirection += (irandom(idleDirectionAngleRandom) - (idleDirectionAngleRandom/2));	
		idleDirection = fixAngle(idleDirection);
	}

	//get bump details
	var bump = list[| i];
	var dir = point_direction(x, y, bump.x, bump.y);
	var dist = point_distance(x, y, bump.x, bump.y);
	var distMultiplier = distMultiplierMax-max(min(dist, distMultiplierMax),1);
				
	//calculate attempted shove
	var bumpSpeedFrame;
	if(mood == baddyMoodIdle)
	{
		bumpSpeedFrame = idleBumpSpeed * timeBasedCounter.secondsPassed;
	}
	else
	{
		bumpSpeedFrame = bumpSpeed * timeBasedCounter.secondsPassed;
	}
	var deltaX = (lengthdir_x(bumpSpeedFrame * distMultiplier, dir));
	var deltaY = (lengthdir_y(bumpSpeedFrame * distMultiplier, dir)); 
	var tileData = tilemap_get_at_pixel(tileController.blockingMapId, bump.x + deltaX, bump.y + deltaY);

	//no tile, go for it
	if(!tileData)
	{
		//apply movement to instance
		bump.x += deltaX;
		bump.y += deltaY;
	}
	
	//there is a tile
	else
	{
		//tile damage
		var tileIndex = tile_get_index(tileData);
		var isDestroyed = ((tileIndex+1) mod blockingTilesetWidth == 0);
		var isIndestructable = ((tileIndex) mod blockingTilesetWidth == 0);
			
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
			if(!isIndestructable) {	

				//get grid position of tile
				var gridX = tilemap_get_cell_x_at_pixel(tileController.blockingMapId, bump.x + deltaX, bump.y + deltaY);
				var gridY = tilemap_get_cell_y_at_pixel(tileController.blockingMapId, bump.x + deltaX, bump.y + deltaY);
				
				//get the damage and increment
				var tileDamage = tileController.tileDamage[# gridX, gridY];
				tileDamage[tileCurrentDamage] += timeBasedCounter.ticksPassed; //1 damage per tick at target frame rate, scaled to the actual frame rate

				//if we have gone over max damage, increment to next damage step and reset damage done to 0.
				if(tileDamage[tileCurrentDamage] >= tileDamage[tileMaxDamage])
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
						audio_play_sound_on(emitter, sndTileBreak, 0, round(voiceGridDistance-dist));
					}
					else
					{
						audio_play_sound_on(emitter, sndTileDamage, 0, round(voiceGridDistance-dist));
					}
					tileDamage[tileCurrentDamage] = 0;					
				}
				
				//apply changes to the tile
				tileData = tilemap_set(tileController.blockingMapId, tileData, gridX, gridY);
				
				//apply change to the damage on this tile
				tileController.tileDamage[# gridX, gridY] = tileDamage;
			}
			
			//try to slide either way through empty or destroyed tile
			var tileDataX = tilemap_get_at_pixel(tileController.blockingMapId, bump.x + deltaX, bump.y);
			var tileIndex = tile_get_index(tileDataX);
			var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
			
			var tileDataY = tilemap_get_at_pixel(tileController.blockingMapId, bump.x, bump.y + deltaY);
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


//**********************
// MISC
//**********************

//edge collision
x = min( max(x, roomBorderBlocking), (room_width - roomBorderBlocking));
y = min( max(y, roomBorderBlocking), (room_height - roomBorderBlocking));	

depth = round(-y);