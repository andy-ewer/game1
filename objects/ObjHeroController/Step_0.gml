//************
//INIT
//************

//get current hero blocking grid cell
gridX = tilemap_get_cell_x_at_pixel(root.blockers.blockingMapId, target.x, target.y);
gridY = tilemap_get_cell_y_at_pixel(root.blockers.blockingMapId, target.x, target.y);

isControlEnabled = true;


//************
//DO EVERYTHING
//************
heroController_handleDoors();
if(isControlEnabled)
{
	heroController_controls();
}
heroController_move();

//ATTACK
if(target.sprite_index == sprHeroAttack)
{
	var currentWeapon = target.weapon.weapons[target.weapon.weaponCurrent] 
	var attacks = currentWeapon[heroWeapon_numberAttacks];
	var numberFrames = sprite_get_number(sprHeroAttack)-1;
	var attackEachFrames = round(numberFrames/attacks);
	if((target.image_index+1) mod attackEachFrames == 0 && target.heroAttackCounter == heroAttack_frames)
	{
		var nearestBaddy = instance_nearest(target.x, target.y, objBaddy1);
		if(nearestBaddy)
		{
			var distance = point_distance(target.x, target.y, nearestBaddy.x, nearestBaddy.y);
			if(distance < heroAttack_range)
			{				
				with(instance_create_layer(nearestBaddy.x, nearestBaddy.y, "Instances", objBaddy1Death))
				{
					sprite_index = nearestBaddy.sprite_index;
					depth = nearestBaddy.depth;
					image_blend = nearestBaddy.image_blend;
					event_user(0);
				}
				instance_destroy(nearestBaddy);
			}
		}
	}
}
		

//************
//AUDIO
//************

//update 3d audio
audio_listener_position(target.x, target.y, 0);
audio_listener_velocity(deltaX, deltaY, 0);	


