//weapon value columns
#macro heroWeapon_walkSprite 0
#macro heroWeapon_attackSprite 1
#macro heroWeapon_numberAttacks 2

weapons = array_create(0);
weaponCurrent = 0;
weaponLast = -2;
isAttacking = false;
isAttackingLast = true;

//populate weapons
var weaponCnt = -1;

//0 knife
var w = array_create(2);
w[heroWeapon_walkSprite] = sprHeroWalkKnife;
w[heroWeapon_attackSprite] = sprHeroAttackKnife;
w[heroWeapon_numberAttacks] = 1;
weapons[++weaponCnt] = w;

//1 hammer
var w = array_create(2);
w[heroWeapon_walkSprite] = sprHeroWalkHammer;
w[heroWeapon_attackSprite] = sprHeroAttackHammer;
w[heroWeapon_numberAttacks] = 2;
weapons[++weaponCnt] = w;

//2 crowbar
var w = array_create(2);
w[heroWeapon_walkSprite] = sprHeroWalkCrowbar;
w[heroWeapon_attackSprite] = sprHeroAttackCrowbar;
w[heroWeapon_numberAttacks] = 3;
weapons[++weaponCnt] = w;

//3 sword
var w = array_create(2);
w[heroWeapon_walkSprite] = sprHeroWalkSword;
w[heroWeapon_attackSprite] = sprHeroAttackSword;
w[heroWeapon_numberAttacks] = 4;
weapons[++weaponCnt] = w;
