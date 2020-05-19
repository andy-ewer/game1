var spread = 4;

for(i=0; i<1000; i++)
{
	var tryX = irandom(room_width/spread);
	var tryY = irandom(room_height/spread);
//	var tryX = room_width/5 + irandom(room_width/5);
//	var tryY = room_height/5+ irandom(room_height/5);
	while(tilemap_get_at_pixel(root.blockers.blockingMapId, tryX, tryY))
	{
		tryX = irandom(room_width/spread);
		tryY = irandom(room_height/spread);
	}
	instance_create_layer(tryX, tryY, "Instances", objBaddy1);
}

