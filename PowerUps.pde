String HealthImage = "Health.jpg";
String DamageImage = "Damage.jpg";
String IncBulletsImage = "IncreaseBullets.jpg";
String TravelSpeedImage = "TravelSpeed.jpg";

class PowerUp
{
	Sprite image;
	char description='D';
	//The descriptions can be D, I, S, H
	//D increases the damage of the ship's bullets
	//I adds another bullet that can be shot, cappting at 5
	//S increases the travel speed of bullets
	//H increases the health of the ship

	PowerUp(String file, float xx, float yy)
    {
       	image = new Sprite(file,xx,yy);
    }

    PowerUp(String filePrefix, int numberFrames, String extension, int digits)
    {
        image = new Sprite(filePrefix,numberFrames,extension,digits);
    }

    void move(){image.updateCoords(0,ymov/3.0);}

    void draw(){image.draw(ship,false);}

    void setDescription(char ch){description = ch;}

    boolean detectCollision()
    {
    	if(touchingSprite(image,ship))
    	{
    		if(description == 'D')
    			bulletDamage++;
    		if(description == 'I')
    			fireableBullets++;
    		if(description == 'S')
    			bulletsPerShot++;
    		if(description == 'H')
    		{
    			ship.health++;
    			if(ship.health>4)
    				ship.health = 4;
    		}
    		println("Description is " + description);
    		return true;
    	}
    	return false;
    }
}

PowerUp dropPowerUp(float xx,float yy)
{
	//Have an 85% chance of nothing dropping, then split the rest
	//equally among the different PowerUps.

	int numberPU = 4;
	double boundary = .85;
	double decision = Math.random();
	//println("Decision is " + decision);
	decision-=boundary;
	boundary = 1-boundary;
	if(decision>0)
	{
		//println("Inside if statement decision is " + decision);
		PowerUp temp; //= new PowerUp(HealthImage,xx,yy);
		//temp.setDescription('H');
		//return temp;
		if(decision<boundary/numberPU) //Description is D
		{
			temp = new PowerUp(DamageImage,xx,yy);
			temp.setDescription('D');
		}
		else if(decision<2*boundary/numberPU && ship.health<4) //Description is H
		{
			temp = new PowerUp(HealthImage,xx,yy);
			temp.setDescription('H');
		}
		else if(decision<3*boundary/numberPU) //Description is S
		{
			temp = new PowerUp(TravelSpeedImage,xx,yy);
			temp.setDescription('S');
		}
		else //Description is I
		{
			temp = new PowerUp(IncBulletsImage,xx,yy);
			temp.setDescription('I');
		}
		return temp;
	}
	return null;
}