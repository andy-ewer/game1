
//************
//ATTACK
//************

if(root.controls.isAttackPressed || isAttacking)
{
	//new attack this frame
	if(sprite_index != sprHeroAttack)
	{
		//start a new attack
		sprite_index = sprHeroAttack; 
		image_index = 0;
		heroAttackCounter = heroAttack_frames;
		isAttacking = true;
	}
	
	//continue existing attack
	else
	{
		heroAttackCounter -= root.timing.ticksPassed;
		if(heroAttackCounter <= 0)
		{
			var isEnd = image_index==image_number-1;
			image_index++;
			if(isEnd)
			{
				isAttacking = root.controls.isAttackPressed;
			}
			heroAttackCounter = heroAttack_frames;
		}
	}	
}


//************
//MOVE
//************

else if(isMoving)
{	
	sprite_index = sprHeroWalk; //keep walking
} 


//************
//IDLE
//************

else
{
	//fresh idle state, reset values
	if(sprite_index != sprHeroIdle) 
	{		
		sprite_index = sprHeroIdle;
		image_index = heroIdle_regular;		
		blinkCounter = heroInit_blinkCounter;
		poseCounter = heroInit_poseCounter;
		isBlinking = false;
		staminaDelay = staminaDelayInit;
	}
	
	//continue existing idle state
	else 
	{
		//counting down
		blinkCounter -= root.timing.ticksPassed;
		poseCounter -= root.timing.ticksPassed;
		staminaDelay -= root.timing.ticksPassed;

		//start blink
		if(blinkCounter <= 0)
		{
			if(!isBlinking)
			{
				image_index++;	//matching blink frame is always +1 of current idle frame.
				isBlinking = true;
				blinkCounter = heroBlink_length;
			}
			else
			{
				image_index--;
				isBlinking = false;
				blinkCounter = irandom(heroBlink_random)+heroBlink_randomPlus;
			}
		}

		//change pose status, unless blinking. will happen after blink.
		if(blinkCounter > 0 and poseCounter < 0)
		{
			image_index = choose(heroIdle_regular, heroIdle_smile, heroIdle_left, heroIdle_right, heroIdle_down); //random pose
			poseCounter = irandom(heroPose_random)+heroPose_randomPlus;
		}
		
		if(staminaDelay <= 0 && stamina < 100)
		{
			stamina += staminaRegainRate * root.timing.ticksPassed;
		}
	}
}

//keep weapon object on hero
weapon.x = x;
weapon.y = y;
weapon.depth = depth - 1;
if(isMoving || isAttacking)
{
	weapon.image_index = image_index;
}
else
{
	weapon.image_index = 0;
}

weapon.isAttacking = isAttacking;
