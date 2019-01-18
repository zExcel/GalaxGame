void BulletMovement()
{
    if(keys[2] && (ship.numberBullets<fireableBullets*bulletsPerShot || partyMode))
    {
        if(delayShoot*1000/(2*bulletsPerShot) + lastShot<millis())
        {
            println(bulletsPerShot);
            if(bulletsPerShot==1)
            {
                Sprite temp = new Sprite(bulletImage,ship.x + spriteDim/2-5,ship.y - bulletH);
                temp.enemy = false;
                temp.parent = ship;
                temp.parent.activeBullet = true;
                ship.numberBullets++;
                temp.removeBlack(20);
                bullets.add(temp);
                bulletSounds[currentBulletSound].play();
                currentBulletSound = (currentBulletSound+1)%bulletSounds.length;
                lastShot = millis();
            }
            else if(bulletsPerShot>=2)
            {
                Sprite temp = new Sprite(bulletImage,ship.x + spriteDim/2-15,ship.y - bulletH);
                temp.enemy = false;
                temp.parent = ship;
                temp.parent.activeBullet = true;
                ship.numberBullets+=2;
                temp.removeBlack(20);
                bullets.add(temp);
                temp = new Sprite(bulletImage,ship.x + spriteDim/2 + 5,ship.y -bulletH);
                temp.removeBlack(20);
                temp.parent = ship;
                bullets.add(temp);
                bulletSounds[currentBulletSound].play();
                currentBulletSound = (currentBulletSound+1)%bulletSounds.length;
                lastShot = millis();
            }
        }
        
        
    }

    for(int i=0; i<bullets.size(); i++)
    {
        if(bullets.get(i).enemy)
        {
            bullets.get(i).updateCoords(0,ymov/1.5);
        }
        else
        {
            bullets.get(i).updateCoords(0,-1*bulletSpeed);
        }
        if(bullets.get(i).y>=height || bullets.get(i).x>=width 
            || bullets.get(i).x<=-10 || bullets.get(i).y<0)
        {
            bullets.get(i).parent.activeBullet = false;
            bullets.get(i).parent.numberBullets--;
            ClearSprite(bullets.get(i));
            bullets.remove(i);
            i--;
        }
    }
}

void ShipMovement()
{
    if(keys[0])
    {
        ship.updateCoords(-1*abs(xmov),0);
    }
    if(keys[1])
    {
        ship.updateCoords(abs(xmov),0);
    }
}

void MonsterMovement()
{
    //println(monsters[0][0].x);
    if((monsters[0][rightMostColumn].x>=width-spriteDim
        || monsters[0][leftMostColumn].x<=0) && counter%12==0)
    {
        xmov*=-1;
    }
    int colAttack = (int)(Math.random()*monsterCol);
    while(monsters[lastRow][colAttack].blank)
    {
        colAttack = (int)(Math.random()*monsterCol);
    }
    for (int r = 0; r < monsterRow; ++r) 
    {
        for (int c = 0; c < monsterCol; ++c)
        {

            if(fallingMonsters.size()<=stage/2 && r==lastRow && c==colAttack && !monsters[r][c].attacking)
            {
                attackingRow = r;
                attackingColumn = c;
                monsters[r][c].attacking = true;
                monsters[r][c].angleShot = -1*atan(1.0*(ship.x + ship.imageWidth/2 - monsters[r][c].x)/(ship.y+ship.imageHeight/2-monsters[r][c].y));
                monsters[r][c].angleMove = monsters[r][c].angleShot;
                fallingMonsters.add(monsters[r][c]);
                attackingMonster = true;
                monsters[r][c].enemy = true;
            }

            if(monsters[r][c].attacking)
            {
                if(monsters[r][c].y>=height)
                {
                    deleteFallingMonster(monsters[r][c]);
                    monsters[r][c].blank = true;
                    monsters[r][c].attacking = false;
                    attackingMonster = false;
                    monstersLeft--;
                    continue;
                }
                /*double determine = Math.random();
                if(determine<.3)
                {
                    attackmov*=-1;
                }*/
                if(!monsters[r][c].activeBullet && monsters[r][c].y<height-100)
                {
                    monsters[r][c].activeBullet = true;
                    float xx = monsters[r][c].x + monsters[r][c].imageWidth/2;
                    float yy = monsters[r][c].y + monsters[r][c].imageHeight/2;
                    Sprite temp = new Sprite(bulletImage,xx,yy);
                    float angleShot = -1*atan(1.0*(ship.x + ship.imageWidth/2 - temp.x)/(ship.y + ship.imageHeight/2 - temp.y));
                    if(angleShot<-PI/3)
                    {
                      angleShot = -PI/3;
                    }
                    else if(angleShot > PI/3)
                    {
                      angleShot = PI/3;
                    }
                    temp.angleMove = angleShot;
                    temp.angleShot = angleShot;
                    temp.enemy = true;
                    temp.parent = monsters[r][c];
                    bullets.add(temp);
                }
                monsters[r][c].updateCoords(attackmov/3.0,ymov/3.0);
            }
            else if(counter%12==0)
            {
                monsters[r][c].updateCoords(xmov*2,0);
            }

            //println(monsters[r][c]);
            //pause();
        }
    }
    sideways = false;
}

void PowerUpMovement()
{
    for(int i=0; i<powerUps.size(); i++)
    {
        powerUps.get(i).move();
    }
}


void keyPressed()
{
    if(!inputtingName)
    {
        if(key==' ' && bullet.x==-1)
            keys[2] = true;
        if(key=='p' && !gameOver)
        {
            paused = !paused;
        }
        if(key==CODED)
        {
            if(keyCode==LEFT)
                keys[0] = true;
            if(keyCode==RIGHT)
                keys[1] = true;
        }
    }
    else
    {
        if(key=='\b')
        {
            if(name.length()>=1)
                name = name.substring(0,name.length()-1);
        }
        else if(key==10)
        {
            inputtingName = false;
        }
        else if(key!=' ' && (key<'0' || key>'9'))
        {
            name = name + key;
        }
    }
}

void keyReleased()
{
    if(key==' ')
        keys[2] = false;
    if(key==CODED)
    {
        if(keyCode == LEFT)
            keys[0] = false;
        if(keyCode == RIGHT)
            keys[1] = false;
    }
}