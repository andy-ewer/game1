for(i=0; i<100; i++)
{
	var tryX = irandom(room_width/5);
	var tryY = irandom(room_height/5);
//	var tryX = room_width/5 + irandom(room_width/5);
//	var tryY = room_height/5+ irandom(room_height/5);
	while(tilemap_get_at_pixel(blockers.blockingMapId, tryX, tryY))
	{
		tryX = irandom(room_width);
		tryY = irandom(room_height);
	}
	instance_create_layer(tryX, tryY, "Instances", objBaddy1);
}

