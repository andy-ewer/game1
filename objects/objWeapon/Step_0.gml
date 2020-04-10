if(weaponCurrent != weaponLast || isAttacking != isAttackingLast)
{
	if(weaponLast == -1)
	{
		visible = true;	
	}
	else if(weaponCurrent == -1)
	{
		visible = false	
	}
	
	if(weaponCurrent != -1)
	{
		var w = weapons[weaponCurrent];
		if(isAttacking)
		{
			sprite_index = w[heroWeapon_attackSprite];
		}
		else
		{
			sprite_index = w[heroWeapon_walkSprite];
		}
	}

	isAttackingLast = isAttacking;
	weaponLast = weaponCurrent;
}


