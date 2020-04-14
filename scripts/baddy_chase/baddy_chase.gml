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
	moveSpeedFrame = b1Speed_idle * root.timing.secondsPassed;
	deltaX = (lengthdir_x(moveSpeedFrame, idleDirection));
	deltaY = (lengthdir_y(moveSpeedFrame, idleDirection));
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
	deltaX = (lengthdir_x(moveSpeedFrame, dir));
	deltaY = (lengthdir_y(moveSpeedFrame, dir));
}