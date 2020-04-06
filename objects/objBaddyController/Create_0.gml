for(i=0; i<400; i++)
{
	var tryX = irandom(room_width/1);
	var tryY = irandom(room_height/1);
	while(tilemap_get_at_pixel(tileController.blockingMapId, tryX, tryY))
	{
		tryX = irandom(room_width);
		tryY = irandom(room_height);
	}
	instance_create_layer(tryX, tryY, "Instances", objBaddy);
}

