//**********************
//INIT
//**********************

//scale movement to time
var secondsPassed = delta_time / 1000000;
var moveSpeedFrame = moveSpeed * secondsPassed;
var bumpSpeedFrame = bumpSpeed * secondsPassed;

//**********************
//ANIMATE
//**********************

//steps are erratic
stepCounter--;
if(stepCounter<0)
{
	if(image_index == walkEnd)
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

if(mood == baddyMoodIdle)
{
	
	var thisX = tilemap_get_cell_x_at_pixel(tileController.blockingMapId, x, y);
	var thisY = tilemap_get_cell_y_at_pixel(tileController.blockingMapId, x, y);
	var heroX = tilemap_get_cell_x_at_pixel(tileController.blockingMapId, objHero.x, objHero.y);
	var heroY = tilemap_get_cell_y_at_pixel(tileController.blockingMapId, objHero.x, objHero.y);

	var dist = point_distance(thisX, thisY, heroX, heroY);
	if(dist<=sightDistance)
	{
		var sightClear = gridLineOfSightClear(thisX, thisY, heroX, heroY);
		if(sightClear) {
			mood = baddyMoodChase;
		}
	}
}
else
{
	//mouth opens and closes
	mouthCounter--;
	if(mouthCounter<0)
	{
		if(image_index <= walkEnd)
		{
			image_index+= 4;
			moveSpeed = mouthSpeed;
			mouthCounter = irandom(mouthOpenRandom)+mouthOpenPlus;	
		}
		else
		{
			image_index-= 4;
			moveSpeed = regularSpeed;
			mouthCounter = irandom(mouthClosedRandom)+mouthClosedPlus; 	
		}	
	}

	//**********************
	//CHASE HERO
	//**********************

	//get potential move point 
	var dir = point_direction(x, y, objHero.x, objHero.y);
	var deltaX = (lengthdir_x(moveSpeedFrame, dir));
	var deltaY = (lengthdir_y(moveSpeedFrame, dir));
	
	//tile layer collision	
	var tileData = tilemap_get_at_pixel(tileController.blockingMapId, x + deltaX, y + deltaY);
	var isDestroyed = false;

	//no tile
	if(!tileData)
	{
		//apply move
		x += deltaX;	
		y += deltaY;	
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
		}
	
		//try to slide into an empty or destroyed tile
		else 
		{
			var tileDataX = tilemap_get_at_pixel(tileController.blockingMapId, x + deltaX, y);
			var tileIndex = tile_get_index(tileDataX);
			var isDestroyedX = ((tileIndex+1) mod blockingTilesetWidth == 0);
		
			var tileDataY = tilemap_get_at_pixel(tileController.blockingMapId, x, y + deltaY);
			var tileIndex = tile_get_index(tileDataY);
			var isDestroyedY = ((tileIndex+1) mod blockingTilesetWidth == 0);
				
			if(!tileDataX || isDestroyedX)
			{
				//apply move
				x += deltaX;	
			}
			else if(!tileDataY || isDestroyedY)
			{
				//apply move
				y += deltaY;	
			}
		}
	}
}

//**********************
//HERD BEHAVIOUR
//**********************

//get bumps with other zombies
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy, list, false);

//iterate the bumps
for(var i=0; i<qtyBumps; ++i) {

	//get bump details
	var bump = list[| i];
	var dir = point_direction(x, y, bump.x, bump.y);
	var dist = point_distance(x, y, bump.x, bump.y);
	var distMultiplier = distMultiplierMax-max(min(dist, distMultiplierMax),1);
				
	//calculate attempted shove
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
				tileDamage[tileCurrentDamage]++;

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