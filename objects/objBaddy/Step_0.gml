
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

//temporary chase mechanic
mp_linear_step(objHero.x, objHero.y, 0.5, false);

//keep the herd spread out a bit
var collision = collision_point(x, y, objBaddy, false, true);
if(collision) {
	var dir = point_direction(x, y, collision.x, collision.y);
	var dist = point_distance(x, y, collision.x, collision.y);

	//calculate movement
	//var moveSpeedFrame = dist * secondsPassed;
	var deltaX = (lengthdir_x(dist/herdDensityFactor, dir));
	var deltaY = (lengthdir_y(dist/herdDensityFactor, dir)); 
	
	//apply movement to instance
	collision.x += deltaX;
	collision.y += deltaY;
}

depth = -y;