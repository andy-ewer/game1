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