//scale movement to time
var secondsPassed = delta_time / 1000000;
var moveSpeedFrame = moveSpeed * secondsPassed;
var bumpSpeedFrame = bumpSpeed * secondsPassed;

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

//CHASE HERO

//get potential move point 
var dir = point_direction(x, y, objHero.x, objHero.y);
var deltaX = (lengthdir_x(moveSpeedFrame, dir));
var deltaY = (lengthdir_y(moveSpeedFrame, dir));
	
//tile layer collision	
if(!tilemap_get_at_pixel(blockingMapId, x + deltaX, y + deltaY))
{
	//apply move
	x += deltaX;	
	y += deltaY;	
}
else if(!tilemap_get_at_pixel(blockingMapId, x + deltaX, y))
{
	//apply move
	x += deltaX;	
}
else if(!tilemap_get_at_pixel(blockingMapId, x, y + deltaY))
{
	//apply move
	y += deltaY;	
}

//keep the herd spread out a bit
var list = ds_list_create();
var qtyBumps = instance_place_list(x, y, objBaddy, list, false);

for(var i=0; i<qtyBumps; ++i) {
	var bump = list[| i];
	
	if(bump) 
	{
		var dir = point_direction(x, y, bump.x, bump.y);
		var dist = point_distance(x, y, bump.x, bump.y);
		var distMultiplier = 10-max(min(dist, 10),1);
				
		//show_debug_message(distMultiplier);
		
		//calculate movement
		var deltaX = (lengthdir_x(bumpSpeedFrame * distMultiplier, dir));
		var deltaY = (lengthdir_y(bumpSpeedFrame * distMultiplier, dir)); 
	
		//tile layer collision	
		if(!tilemap_get_at_pixel(blockingMapId, bump.x + deltaX, bump.y + deltaY))
		{
			//apply movement to instance
			bump.x += deltaX;
			bump.y += deltaY;
		}
		else if(!tilemap_get_at_pixel(blockingMapId, bump.x + deltaX, bump.y))
		{
			//apply move
			bump.x += deltaX;	
		}
		else if(!tilemap_get_at_pixel(blockingMapId, bump.x, bump.y + deltaY))
		{
			//apply move
			bump.y += deltaY;	
		}
	}
}
ds_list_destroy(list);

//edge collision
x = min( max(x, roomBorderBlocking), (room_width - roomBorderBlocking));
y = min( max(y, roomBorderBlocking), (room_height - roomBorderBlocking));	

depth = -y;