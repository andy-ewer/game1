#macro defaultViewWidth 480
#macro defaultViewHeight 270
#macro defaultAspectRatio 1.78 //16:9
#macro menuRoomWidth 1920
#macro menuRoomHeight 1080

//*****************
// TEST OPTIONS
//
// ==0 use current display
// !=0 mock a different resolution
//*****************
var debugOption = 0;
switch(debugOption)
{	
	case 0:
		global.renderWidth = display_get_width();
		global.renderHeight = display_get_height();
	break;
	
	// 1.33 --> 4:3 (800x600)
	case 3:
		global.renderWidth = 800;
		global.renderHeight = 600;
	break;

	// 1.6 --> 16:10 (2560x1600)
	case 2:
		global.renderWidth = 2560;
		global.renderHeight = 1600;
	break;

	// 1.78 --> 16:9 (1080x1920)
	case 1:
		global.renderWidth = 1080;
		global.renderHeight = 1920;
	break;

	// 2.37 --> 21:9 (2560x1080)
	case 4:
		global.renderWidth = 1280;
		global.renderHeight = 540;
	break;

	//mobile portrait
	case 5:
		global.renderWidth = 375;
		global.renderHeight = 667;		
	break;

	//mobile landscape
	case 6:
		global.renderWidth = 667;
		global.renderHeight = 375;		
	break;

}

//*****************
//Use global to manage aspect ratios for cameras
//*****************

var aspectRatio = global.renderWidth / global.renderHeight;
aspectRatio *= 100;
aspectRatio = round(aspectRatio);
aspectRatio /= 100;

if(aspectRatio == defaultAspectRatio)
{
	global.aspectViewWidthMenu = room_width;	
	global.aspectViewHeightMenu = room_height;	
	
	global.aspectViewWidth = defaultViewWidth;	
	global.aspectViewHeight = defaultViewHeight;	
}
else if (aspectRatio > defaultAspectRatio)
{
	global.aspectViewWidthMenu = round(room_height * aspectRatio);	
	global.aspectViewHeightMenu = room_height;		
	
	global.aspectViewWidth = defaultViewWidth;		
	global.aspectViewHeight = round(defaultViewWidth / aspectRatio);	
}
else
{
	global.aspectViewWidthMenu = room_width;	
	global.aspectViewHeightMenu = round(room_width / aspectRatio);	
	
	global.aspectViewWidth = round(defaultViewHeight * aspectRatio);		
	global.aspectViewHeight = defaultViewHeight;	
}

//update the window size
window_set_size(global.renderWidth, global.renderHeight);