//scale movement to time
var secondsPassed = delta_time / 1000000;
var moveSpeedFrame = moveSpeed * secondsPassed;

//steps are erratic
stepCounter--;
if(stepCounter<0)
{
	image_index++;
	if(image_index == walkEnd)
	{
		image_index = walkStart;		
	} 
	else if(image_index == walkStart)
	{
		image_index = mouthStart;
	}
	stepCounter = irandom(stepRandom)+stepPlus;
}

//mouth opens and closes
mouthCounter--;
if(mouthCounter<0)
{

	if(image_index < walkEnd)
	{
		image_index+= walkEnd;
		mouthCounter = irandom(walkRandom)+walkPlus; //open	
	}
	else
	{
		image_index-= 4;
		mouthCounter = irandom(mouthRandom)+mouthPlus;	//closed
	}
	
}


//CHASE HERO

//get potential move point 
var dir = point_direction(x, y, objHero.x, objHero.y);
var deltaX = (lengthdir_x(moveSpeedFrame, dir));
var deltaY = (lengthdir_y(0.5, dir));
	
//tile layer collision	
if(!tilemap_get_at_pixel(mapId, x + deltaX, y + deltaY))
{
	//apply move
	x += deltaX;	
	y += deltaY;	
}

//keep the herd spread out a bit
var bump = collision_point(x, y, objBaddy, false, true);
if(bump) {
	var dir = point_direction(x, y, bump.x, bump.y);
	var dist = point_distance(x, y, bump.x, bump.y);

	//calculate movement
	//var moveSpeedFrame = dist * secondsPassed;
	var deltaX = (lengthdir_x(dist/herdDensityFactor, dir));
	var deltaY = (lengthdir_y(dist/herdDensityFactor, dir)); 
	
	//tile layer collision	
	if(!tilemap_get_at_pixel(mapId, bump.x + deltaX, bump.y + deltaY))
	{
		//apply movement to instance
		bump.x += deltaX;
		bump.y += deltaY;
	}
}

depth = -y;