
//view
view_enabled = true;
view_set_visible(0, true);

//center menu room content
var posX = (menuRoomWidth - global.aspectViewWidthMenu)/2;
var posY = (menuRoomHeight - global.aspectViewHeightMenu)/2;

//camera
camera_set_view_pos(view_camera[0], posX, posY);
camera_set_view_size(view_camera[0], global.aspectViewWidthMenu, global.aspectViewHeightMenu);

