//blocking layer
blockingLayerId = layer_get_id("tilesBlocking");
blockingMapId = layer_tilemap_get_id(blockingLayerId);


for(i=0; i<200; i++)
{
	var tryX = irandom(room_width/10);
	var tryY = irandom(room_height/10);
	while(tilemap_get_at_pixel(blockingMapId, tryX, tryY))
	{
		tryX = irandom(room_width);
		tryY = irandom(room_height);
	}
	instance_create_layer(tryX, tryY, "Instances", objBaddy);
}