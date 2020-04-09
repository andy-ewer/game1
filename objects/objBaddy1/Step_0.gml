//**********************
//INIT
//**********************

//get this and the heroes grid position
var thisX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, x, y);
var thisY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, x, y);
var heroX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, objHero.x, objHero.y);
var heroY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, objHero.x, objHero.y);
var dist = point_distance(thisX, thisY, heroX, heroY);

//update line of sight occasionally for performance
sightCounter -= root.timing.ticksPassed;
if(sightCounter<0)
{
	//don't check if out of range
	if(
		mood == b1Mood_Idle && dist>b1Behaviour_idleSightDistance
		||
		mood != b1Mood_Idle && dist>b1Behaviour_alertSightDistance
	)
	{
		sightClear = false;
	}

	//in range, so check
	else
	{
		sightClear = gridLineOfSightClear(thisX, thisY, heroX, heroY);
		sightCounter = b1Behaviour_updateSightTicks;

		//update the last seen position of the hero
		if(sightClear)
		{
			lastSeenX = objHero.x;
			lastSeenY = objHero.y;
		}
	}
}



//**********************
//ANIMATE
//**********************

//steps are erratic
stepCounter -= root.timing.ticksPassed;
if(stepCounter<0)
{
	if(image_index == b1Frames_idleEnd)
	{
		image_index = b1Frames_idleStart;
	}
	else if(image_index == b1Frames_walkEnd)
	{
		image_index = b1Frames_walkStart;
	}
	else if(image_index == b1Frames_mouthEnd)
	{
		image_index = b1Frames_mouthStart;
	}	
	else
	{
		image_index++;
	}
	stepCounter = irandom(b1Ani_stepRandom)+b1Ani_stepPlus;
}

//idle state - scan for the hero to chase	
if(mood == b1Mood_Idle)
{
	//change direction randomly
	idleDirectionCounter -= root.timing.ticksPassed;
	if(idleDirectionCounter < 0)
	{
		idleDirection += (irandom(b1Idle_directionAngleRandom) - (b1Idle_directionAngleRandom/2));	
		idleDirection = fixAngle(idleDirection);
		idleDirectionCounter = irandom(b1Idle_directionCounterRandom + b1Idle_directionCounterPlus);
	}
	
	//look for hero
	if(sightClear) {
			
		//can see the hero - give chase
		mood = b1Mood_Chase;
		image_index = b1Frames_mouthStart;
		mouthCounter = irandom(b1Ani_mouthOpenRandom)+b1Ani_mouthOpenPlus;
			
		//make a noise
		audio_play_sound_on(emitter, voiceSound, 0, round(b1Audio_falloffDist-dist));
	}
	
	//get potential move point 
	var moveSpeedFrame = b1Speed_idle * root.timing.secondsPassed;
	var deltaX = (lengthdir_x(moveSpeedFrame, idleDirection));
	var deltaY = (lengthdir_y(moveSpeedFrame, idleDirection));
}

//chase state
else if(mood == b1Mood_Chase || mood == b1Mood_LastSeen || mood == b1Mood_FinalLook)
{
	//mouth opens and closes
	mouthCounter -= root.timing.ticksPassed;
	if(mouthCounter<0)
	{
		if(image_index <= b1Frames_walkEnd)
		{
			image_index+= 4;
			mouthCounter = irandom(b1Ani_mouthOpenRandom)+b1Ani_mouthOpenPlus;

			//make a noise
			audio_play_sound_on(emitter, voiceSound, 0, round(global.aspectViewWidth-dist));
		}
		else
		{
			image_index-= 4;
			mouthCounter = irandom(b1Ani_mouthClosedRandom)+b1Ani_mouthClosedPlus; 	
		}	
	}
	
	//get potential move point 	
	var moveSpeedFrame;
	if(image_index <= b1Frames_walkEnd)
	{
		moveSpeedFrame = b1Speed_walk * root.timing.secondsPassed; //regular walking speed
	}
	else
	{
		moveSpeedFrame = b1Speed_mouth * root.timing.secondsPassed; //zombies with mouths open move faster
	}		
	
	//revert to chase if line of sight to hero
	if(sightClear)
	{		
		mood = b1Mood_Chase;	
		var dir = point_direction(x, y, objHero.x, objHero.y);
	}
	
	//can't see hero
	else
	{
		//b1Mood_FinalLook
		if(mood == b1Mood_FinalLook)
		{
			finalLookCounter -= root.timing.ticksPassed;
			if(finalLookCounter < 0)
			{
				//return to idle
				mood = b1Mood_Idle
				image_index = b1Frames_idleStart;
				var dir = lastDir;
			}
			else
			{
				//keep going
				var dir = lastDir;
			}		
		}
		
		//b1Mood_LastSeen
		else
		{		
			//at last known location
			if( abs(y-lastSeenY) < b1Behaviour_lastSeenArrivedRange && abs(x-lastSeenX) < b1Behaviour_lastSeenArrivedRange)
			{
				mood = b1Mood_FinalLook;
				lastDir += (irandom(b1Idle_directionAngleRandom) - (b1Idle_directionAngleRandom/2));
				var dir = lastDir;
				finalLookCounter = irandom(b1Final_lookCounterRandom) + b1Final_lookCounterPlus;
			}
		
			//head to last known location
			else
			{
				mood = b1Mood_LastSeen;	
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

//update audio position
audio_emitter_position(emitter,x,y,0);
audio_emitter_velocity(emitter, emitterVX, emitterVY, 0);	

//**********************
//HERD BEHAVIOUR
//**********************

//get bumps with other zombies
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy1, list, false);

//iterate the bumps
for(var i=0; i<qtyBumps; ++i) {

	if(mood == b1Mood_Idle)
	{
		idleDirection += (irandom(b1Idle_directionAngleRandom) - (b1Idle_directionAngleRandom/2));	
		idleDirection = fixAngle(idleDirection);
	}

	//get bump details
	var bump = list[| i];
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
	var tileData = tilemap_get_at_pixel(root.blockers.blockingMapId, bump.x + deltaX, bump.y + deltaY);

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
			}
			
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


//**********************
// MISC
//**********************

//edge collision
x = min( max(x, b1Behaviour_roomBorderBlocking), (room_width - b1Behaviour_roomBorderBlocking));
y = min( max(y, b1Behaviour_roomBorderBlocking), (room_height - b1Behaviour_roomBorderBlocking));	

depth = round(-y);