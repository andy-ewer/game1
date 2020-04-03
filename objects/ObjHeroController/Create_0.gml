//create instance to control
target = instance_create_layer(100,100,"Instances", objHero);

//keys
heroKey[0] = ord("D");
heroKey[1] = ord("W");
heroKey[2] = ord("A");
heroKey[3] = ord("S");
heroKeyAttack = ord(" ");

//init
moveSpeed = 60;
target.depth = -y;
