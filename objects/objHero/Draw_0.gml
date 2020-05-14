draw_self();

//health
if(stamina < 100)
{
	draw_healthbar(
	x - (sprite_width / 3), y - sprite_height-2, 
	x + (sprite_width / 3), y - sprite_height-1,  
	stamina,
	c_black,
	c_red,
	c_green,
	0,
	true,
	true
	)	
}