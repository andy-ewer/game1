moveXInput = 0;
moveYInput = 0;

//get movement in 8 directions from WASD
for (var i = 0; i < array_length_1d(heroKey); i++) 
{
    var this_key = heroKey[i];
    if keyboard_check(this_key) 
	{
        var this_angle = i * 90;
        moveXInput += lengthdir_x(1, this_angle);
        moveYInput += lengthdir_y(1, this_angle);
    }
}

//update some values used by other objects
isMovePressed = (point_distance(0, 0, moveXInput, moveYInput) > 0);
isAttackPressed = keyboard_check(heroKeyAttack);

//must release before press registers again
var usePress = keyboard_check(heroKeyUse);
isUsePressed = (usePress && !wasUsePressed)
wasUsePressed = usePress;


