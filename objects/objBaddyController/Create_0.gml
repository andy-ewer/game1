for(i=0; i<1000; i++)
{
	var tryX = irandom(room_width/10);
	var tryY = irandom(room_height/10);
	while(tilemap_get_at_pixel(tileController.blockingMapId, tryX, tryY))
	{
		tryX = irandom(room_width);
		tryY = irandom(room_height);
	}
	instance_create_layer(tryX, tryY, "Instances", objBaddy);
}

