//============ WHEN THE GAME IS RUNNING THESE ARE GOING ===========

class Button
{
	public float x=0,y=0,buttonWidth=0,buttonHeight=0;
	public boolean takeAction = false;

	Button(float xx,float yy,float BW,float BH)
	{
		x = xx;
		y = yy;
		buttonWidth = BW;
		buttonHeight = BH;
	}
}

void pre()
{
	lastRow = lastRowCheck();
    leftMostColumn = leftColumnCheck();
    rightMostColumn = rightColumnCheck();
  	ShipMovement();
  	ship.draw(ship,false);
  	ship.Clamp();
  	//if(counter!=0 && counter%1==0)
  	//{
    MonsterMovement();
  	//}
  	monsters[attackingRow][attackingColumn].Clamp();
  	BulletMovement();
  	PowerUpMovement();

  	collisionCheck();
  	powerCollisionCheck();

  	if(monstersLeft==0)
  	{
  		lastRow = monsterRow - 1;
        leftMostColumn = 0;
        rightMostColumn = monsterCol - 1;
  		initializeGrid(monsters);
	  	monstersLeft = monsterRow * monsterCol;
  	}
  	counter++;
}

void drawBackground()
{
    background(backgroundColor);
    for(int i=0; i<stars.length; i++)
    {
        stars[i].draw();
    }
}

void Game()
{
	//println(Background1.isPlaying())
	if(!Objects.equals(currentSong,BGM1) || (frameCount/frameRate>=Background1.duration()+startingTime))
	{
		if(!Objects.equals(currentSong,BGM1))
			Background1.stop();
        Background1 = new SoundFile(GalaxGame.this,BGM1);
        Background1.play();
        Background1.amp(.2);
        startingTime = frameCount/frameRate;
        currentSong = BGM1;
        playing = true;
	}
	if(strobeLights)
	{
		scale(scaleAmount+1);
		scaleAmount-=changeScale;
		if(scaleAmount+1<=1-boundaryScale || scaleAmount+1>=1+boundaryScale)
		{
			changeScale*=-1;
		}
		backgroundColor = color(random(0,255),random(0,255),random(0,255));
		/*for(int r=0; r<monsterRow; r++)
		{
			for(int c=0; c<monsterCol; c++)
			{
				monsters[r][c].removeBlack(10);
			}
		}*/
	}
    if(!strobeLights)
    {
        drawBackground();
    }
	//background(backgroundColor);
	textSize(32);
	fill(255);
	if(strobeLights)
	{
		fill(random(0,255),random(0,255),random(0,255));
	}
	textAlign(LEFT,BOTTOM);
	//text("Score: " + ((int)(score*(1+boundaryScale)*(1+abs(changeScale)))),0,50);
  	text("Score: " + score,0,50);
  	text("Stage: " + stage,width-200,50);
  	pre();
  	for (int r = 0; r < monsterRow; ++r) 
  	{
    	for (int c = 0; c < monsterCol; ++c) 
    	{
      		if(!monsters[r][c].blank && !invisibleMonsters)
      		{
        		monsters[r][c].draw(ship,monsters[r][c].attacking);
      		}
    	}
  	}

  	for(int i=0; i<powerUps.size(); i++)
  	{
  		powerUps.get(i).draw();
  	}

    for(int i=0; i<exploding.size(); i++)
    {
        exploding.get(i).draw(ship,false);
        if(exploding.get(i).image.currentFrame==0)
        {
            exploding.remove(i);
            i--;
        }
    }

  	for(int i=0; i<bullets.size(); i++)
  	{
  		bullets.get(i).draw(ship,false);
  	}
}

void powerCollisionCheck()
{
	for(int i=0; i<powerUps.size(); i++)
	{
		if(powerUps.get(i).detectCollision())
		{
            ClearSprite(powerUps.get(i).image);
			powerUps.remove(i);
			i--;
		}
	}
}

boolean touchingSprite(Sprite sprite1,Sprite sprite2)
{
 	float s2W = sprite2.imageWidth;
  	float s2H = sprite2.imageHeight;

  	float s1W = sprite1.imageWidth;
  	float s1H = sprite1.imageHeight;

  	float s1X = sprite1.x;
  	float s1Y = sprite1.y;
  	float s2X = sprite2.x;
  	float s2Y = sprite2.y;

  	s2W += s2X;
  	s2H += s2Y;
  	s1W += s1X;
  	s1H += s1Y;

  	return ((s2W < s2X || s2W > s1X) && (s2H < s2Y || s2H > s1Y)
    	&& (s1W < s1X || s1W > s2X) && (s1H < s1Y || s1H > s2Y));
}

void deleteFallingMonster(Sprite current)
{
	for(int i=0; i<fallingMonsters.size(); i++)
	{
		if(fallingMonsters.get(i) == current)
		{
            ClearSprite(fallingMonsters.get(i));
			fallingMonsters.remove(i);
			return;
		}
	}
}

boolean collisionCheck()
{
	for(int r=0; r<monsterRow; r++)
  	{
    	for(int c=0; c<monsterCol; c++)
    	{
          	//println(touchingSprite(bullet,monsters[r][c]));
          	for(int i = 0; i<bullets.size(); i++)
          	{
          		if(!monsters[r][c].blank && !bullets.get(i).enemy && touchingSprite(bullets.get(i),monsters[r][c]))
	          	{
	          		monsters[r][c].health-=bulletDamage;
	          		if((int)monsters[r][c].health>0)
	          		{
	          			ship.activeBullet = false;
	            		bullets.get(i).parent.numberBullets--;;
	          			bullets.remove(i);
	          			//println("Inside here");
	          			return true;
	          			//i = bullets.size();
	          		}
	            	if(monsters[r][c].attacking)
	            	{
	            		deleteFallingMonster(monsters[r][c]);
	            		monsters[r][c].attacking = false;
	            		attackingMonster = false;
                        score+=10;
	            	}

                    Sprite temp = invaderDeath;
                    temp.x = monsters[r][c].x;
                    temp.y = monsters[r][c].y;
                    temp.removeBlack(10);
                    exploding.add(temp);
                    explosionSounds[currentExplosionSound].play();
                    currentExplosionSound = (currentExplosionSound+1)%explosionSounds.length;

                    PowerUp dropped = dropPowerUp(temp.x,temp.y);
                    if(dropped!=null)
                    	powerUps.add(dropped);

	            	ship.activeBullet = ship.numberBullets==0;
	            	monsters[r][c] = 
	            	new Sprite(blankImage,monsters[r][c].x,monsters[r][c].y);
	            	monsters[r][c].blank = true;
	            	bullets.get(i).parent.numberBullets--;
	            	bullets.remove(i);
	            	monstersLeft--;
	            	score+=10;


	            	return true;
	          	}
                else if(bullets.get(i).enemy && !ship.blank && touchingSprite(ship,bullets.get(i)))
                {
                	ship.health--;
                	if(ship.health!=0)
                	{
                		bullets.get(i).parent.activeBullet = false;
	            		bullets.get(i).parent.numberBullets-=bulletDamage;
	          			bullets.remove(i);
	          			i--;
	          			continue;
                	}
                    ship = new Sprite(blankImage,ship.x,ship.y);
                    ship.blank = true;
                    gameOver = true;
                    ship.removeBlack(10);
                    SoundFile explosionSound = new SoundFile(GalaxGame.this,explosionSoundFile);
                    explosionSound.play();
                    explosionSound.amp(.1);
                }
          	}
        	
          	if(!monsters[r][c].blank && touchingSprite(ship,monsters[r][c]))
          	{
          		ship.health-=2;
          		//println("ship.health is " + ship.health);
          		if(ship.health>0)
          		{
          			deleteFallingMonster(monsters[r][c]);
          			monsters[r][c].attacking = false;
            		attackingMonster = false;
            		Sprite temp = invaderDeath;
                    temp.x = monsters[r][c].x;
                    temp.y = monsters[r][c].y;
                    temp.removeBlack(10);
                    exploding.add(temp);
                    explosionSounds[currentExplosionSound].play();
                    currentExplosionSound = (currentExplosionSound+1)%explosionSounds.length;
                    monsters[r][c] = 
	            	new Sprite(blankImage,monsters[r][c].x,monsters[r][c].y);
	            	monsters[r][c].blank = true;
	            	monstersLeft--;
            		continue;
          		}
          		ship = new Sprite(blankImage,ship.x,ship.y);
          		ship.blank = true;
          		gameOver = true;
          	}
      	}
  	}
  	return false;
}

void ClearSpriteGrid(Sprite grid[][])
{
	for(int r=0; r<grid.length; r++)
	{
		for(int c=0; c<grid[r].length; c++)
		{
			ClearSprite(grid[r][c]);
		}
	}
}

void ClearSprite(Sprite sprite)
{
	if(sprite==null)
		return;
	for(PImage img: sprite.image.frames)
	{
		Object cache = g.getCache(img);
		if(cache instanceof Texture)
		{
			((Texture)cache).disposeSourceBuffer();
		}
		g.removeCache(img);
	}
}

void initializeGrid(Sprite grid[][])
{
    ClearSpriteGrid(grid);
    for(int r=0; r<grid.length; r++)
    {
        for(int c=0; c<grid[r].length; c++)
        {
        	//grid[r][c] = null;
            if(c!=0)
            {
                grid[r][c] = new Sprite(monsterImageWhite,100,"png",5);
                grid[r][c].setCoords(spriteDim*c + widthSpace*c + widthFluff,grid[r][c].imageHeight*r+heightFluff);
                //grid[r][c] = new Sprite(monsterImageWhite,spriteDim*c + widthSpace*c+widthFluff,loadImage(monsterImageWhite).height*r + heightFluff);
            }
            else
            {
                grid[r][c] = new Sprite(monsterImageWhite,100,"png",5);
                grid[r][c].setCoords(spriteDim*c + widthFluff,grid[r][c].imageHeight*r + heightFluff);
                //grid[r][c] = new Sprite(monsterImageWhite,spriteDim*c + widthFluff,loadImage(monsterImageWhite).height*r + heightFluff);
            }
            grid[r][c].removeBlack(19);
            grid[r][c].health = stage/2+1;
            grid[r][c].blank = false;
            grid[r][c].monster = true;
            grid[r][c].image.stretch(30);
        }
    }
    stage+=1;
}

int lastRowCheck()
{
	for(int i=0; i<monsterCol; i++)
	{
		if(!monsters[lastRow][i].blank && !monsters[lastRow][i].attacking)
		{
			return lastRow;
		}
	}
	return max(0,lastRow - 1);
}

int leftColumnCheck()
{
    for(int r=0; r<monsterRow; r++)
    {
        if(!monsters[r][leftMostColumn].blank && !monsters[r][leftMostColumn].attacking)
            return leftMostColumn;
    }
    return min(monsterCol-1,leftMostColumn + 1);
}

int rightColumnCheck()
{
    for(int r=0; r<monsterRow; r++)
    {
        if(!monsters[r][rightMostColumn].blank && !monsters[r][rightMostColumn].attacking)
            return rightMostColumn;
    }
    return max(0,rightMostColumn - 1);
}


//============ WHEN THE GAME IS RUNNING THESE ARE GOING ===========


int getScore(String person)
{
	int currentScore = 0;
	int index = person.lastIndexOf(' ') + 1;
	//println("index is " + index);
	//println("character at index is " + person.charAt(index));
	while(index<person.length() && person.charAt(index)>='0' && person.charAt(index)<='9')
	{
		currentScore*=10;
		currentScore+=person.charAt(index)-'0';
		index++;
	}
	return currentScore;
}

void displayLeaderboard(boolean dead)
{
	background(255);
	if(dead)
	{
		imageMode(CORNER);
   		image(gameOverScreen,0,0);
   		textSize(32);
	    fill(0);
	    textAlign(LEFT,BOTTOM);
	    text("Score: " + score,390,200);
	}
    fill(0);
    textAlign(LEFT,BOTTOM);
    textSize(64);
    text("LeaderBoard",280,270);
    for(int i=0; i<LeaderBoard.size(); i++)
    {
    	textSize(32);
    	text(LeaderBoard.get(i),280,300+30*i);
    }
}

void GameOver()
{
	if(playing)
	{
		//println("In here");
		Background1.stop();
		//Background1 = null;
		playing = false;
	}
	if(explosion.currentFrame!=explosion.literalFrames-1)
    {
        imageMode(CORNER);
        //fill(0);
        //rect(ship.x,ship.y,ship.imageWidth,ship.imageHeight);
        background(backgroundColor);
        for(int r=0; r<monsterRow; r++)
        {
        	for(int c=0; c<monsterCol; c++)
        	{
        		if(monsters[r][c].blank)
        			continue;
        		monsters[r][c].draw(ship,monsters[r][c].attacking);
        	}
        }
        explosion.draw(ship.x+20,ship.y+20);
    }
    else
    {
        displayLeaderboard(true);

        if(enteredName || partyMode || score<=getScore(LeaderBoard.get(LeaderBoard.size()-1)))
        {
        	//noLoop();
        	if(!buttonsAdded)
        	{
        		buttons.add(new Button(220,600,buttonWidth,buttonHeight));
        	}
        	fill(color(255,0,0));
    		rect(220,600,buttonWidth,buttonHeight);
    		textAlign(CENTER,CENTER);
    		fill(255);
    		text("Main Menu",220+buttonWidth/2,600+buttonHeight/2);
    		textAlign(LEFT,BOTTOM);
    		if(buttons.get(0).takeAction)
    		{
    			menu = 1;
    			gameOver = false;
    			buttonsAdded = false;
    			buttons.clear();
    			setup();
    			//buttons.clear();
    			return;
    		}
    		if(partyMode)
    			return;
        }

        if(score <= getScore(LeaderBoard.get(LeaderBoard.size()-1)))
        {
        	//menu = 3;
        	return;
        }

        if(score>getScore(LeaderBoard.get(LeaderBoard.size()-1)) && (inputtingName || name.length()==0))
        {
        	inputtingName = true;
        	//println("Inside here");
        }
        if(!enteredName && score>getScore(LeaderBoard.get(LeaderBoard.size()-1)))
        {
        	text("Input name: ",280,600);
        	text(name,500,600);
        }
        if(!enteredName && score>getScore(LeaderBoard.get(LeaderBoard.size()-1)) && !inputtingName)
        {
        	for(int i=0; i<LeaderBoard.size(); i++)
        	{
        		//println(LeaderBoard.get(i));
        		//println(getScore(LeaderBoard.get(i)));
        		if(score>getScore(LeaderBoard.get(i)))
        		{
        			for(int j=LeaderBoard.size()-1; j>i; j--)
        			{
        				String temp = LeaderBoard.get(j-1);
        				temp = temp.substring(temp.indexOf(' '));
        				temp = (j+1)+"."+temp;
        				LeaderBoard.set(j,temp);
        			}
        			LeaderBoard.set(i,(i+1) + ". " + name + " " + score);
        			break;
        		}
        	}
        	try
        	{
        		FileWriter output = new FileWriter(new File(dataPath("LeaderBoard.txt")));
        		for(int i=0; i<LeaderBoard.size(); i++)
        		{
        			output.write(LeaderBoard.get(i));
        			output.write("\n");
        		}
        		output.flush();
        		output.close();
        	}
        	catch (Exception e)
        	{
        		println("Couldn't write to the file.");
        	}
        	enteredName = true;
        }
    }
}

void mousePressed()
{
	for(int i=0; i<buttons.size(); i++)
	{
		if(mouseX>=buttons.get(i).x && mouseX<=buttons.get(i).x + buttons.get(i).buttonWidth && 
			mouseY>=buttons.get(i).y && mouseY<=buttons.get(i).y + buttons.get(i).buttonHeight)
		{
			buttons.get(i).takeAction = true;
		}
	}
}



void Menu()
{
	background(backgroundColor);
	gameOver = false;
	if(buttons.size()!=0 && menu!=2)
	{
		//Play the game
		if(buttons.get(0).takeAction)
		{
			buttonsAdded = false;
			buttons.clear();
			menu = 0;
			setup();
			return;
		}
		//Goes to options
		else if(buttons.get(1).takeAction)
		{
			buttonsAdded = false;
			buttons.clear();
			menu = 2;
			return;
		}
		//Goes to leaderboard
		else if(buttons.get(2).takeAction)
		{
			buttonsAdded = false;
			buttons.clear();
			menu = 3;
			return;
		}
		//Returns to main menu
		else if(buttons.get(3).takeAction)
		{
			buttonsAdded = false;
			buttons.clear();
			menu = 1;
			return;
		}
		//Quit the game
		else if(buttons.size()>=5 && buttons.get(4).takeAction)
		{
			exit();
		}
	}
	
	//Main menu is one, has options screen (2), leaderboard screen(3)
	//There's also a play button that sets menu to 0.
	if(menu==1)
	{

		if(!Objects.equals(currentSong,BGM2) || (frameCount/frameRate>=Background1.duration()+startingTime))
		{
			if(Background1!=null && !Objects.equals(currentSong,BGM2))
				Background1.stop();
	        Background1 = new SoundFile(GalaxGame.this,BGM2);
	        Background1.play();
	        Background1.amp(.2);
	        startingTime = frameCount/frameRate;
	        currentSong = BGM2;
	        playing = true;
		}

	    if(!Objects.equals(currentSong,BGM2))
	    {
	    	if(playing)
	    		Background1.stop();
	        Background1 = new SoundFile(GalaxGame.this,BGM2);
	        Background1.play();
	        Background1.amp(.2);
	        currentSong = BGM2;
	        playing = true;
	    }
		background(50);
		//Play button
		fill(color(255,0,0));
		rect(width/2-buttonWidth/2,200,buttonWidth,buttonHeight);
		textAlign(CENTER,CENTER);
		textSize(32);
		fill(0);
		text("Play",width/2,200+buttonHeight/2);
		

		//Options button
		fill(color(0,255,0));
		rect(width/2-buttonWidth/2,200+2*buttonHeight,buttonWidth,buttonHeight);
		fill(0);
		text("Options",width/2,200+buttonHeight/2+2*buttonHeight);
		

		//Leaderboard button
		fill(color(0,0,255));
		rect(width/2-buttonWidth/2,200+4*buttonHeight,buttonWidth,buttonHeight);
		fill(0);
		text("Leaderboard",width/2,200+buttonHeight/2+4*buttonHeight);

		//Quit button
		fill(color(255,0,0));
		stroke(color(0));
		rect(width-50,0,50,50);
		fill(0);
		line(width-50,0,width,50);
		line(width-50,50,width,0);
		
		if(!buttonsAdded)
		{
			//println("Menu 1 add buttons");
			//Order of buttons goes play,options,leaderboard, then filler
			buttons.add(new Button(width/2-buttonWidth,200,buttonWidth,buttonHeight));
			buttons.add(new Button(width/2-buttonWidth,200+2*buttonHeight,buttonWidth,buttonHeight));
			buttons.add(new Button(width/2-buttonWidth,200+4*buttonHeight,buttonWidth,buttonHeight));
			buttons.add(new Button(width+5,height+5,0,0));
			buttons.add(new Button(width-50,0,50,50));
			buttonsAdded = true;
		}
	}
	else if(menu==2)
	{
		fill(color(255,0,0));
		rect(width/2-buttonWidth/2,200,buttonWidth,buttonHeight);
		textAlign(CENTER,CENTER);
		textSize(32);
		fill(0);
		text("Toggle Party Mode " + partyModeString,width/2,200+buttonHeight/2);
		

		//Options button
		fill(color(0,255,0));
		rect(width/2-buttonWidth/2,200+2*buttonHeight,buttonWidth,buttonHeight);
		fill(0);
		text("Toggle Invisible Monsters " + invisMonstersString,width/2,200+buttonHeight/2+2*buttonHeight);
		
		//Leaderboard button
		fill(color(0,0,255));
		rect(width/2-buttonWidth/2,200+4*buttonHeight,buttonWidth,buttonHeight);
		fill(0);
		text("Toggle Strobe Lights "+strobeLightsString + "\nSEIZURE WARNING",width/2,200+buttonHeight/2+4*buttonHeight);

		//Leaderboard button
		fill(color(255,0,0));
		rect(width/2-buttonWidth/2,200+6*buttonHeight,buttonWidth,buttonHeight);
		fill(0);
		text("Main Menu",width/2,200+buttonHeight/2+6*buttonHeight);

		if(!buttonsAdded)
		{
			buttons.add(new Button(width/2-buttonWidth,200,buttonWidth,buttonHeight)); //Toggle party mode
			buttons.add(new Button(width/2-buttonWidth,200+2*buttonHeight,buttonWidth,buttonHeight)); //Toggle invisible monsters
			buttons.add(new Button(width/2-buttonWidth,200+4*buttonHeight,buttonWidth,buttonHeight)); //Toggle Strobe Lights
			buttons.add(new Button(width/2-buttonWidth,200+6*buttonHeight,buttonWidth,buttonHeight)); //Main menu
		}
		if(buttons.get(0).takeAction)
		{
			partyMode = !partyMode;
			if(partyModeString.equals("on"))
			{
				partyModeString = "off";
			}
			else
			{
				partyModeString = "on";
			}
			buttons.get(0).takeAction = false;
		}
		if(buttons.get(1).takeAction)
		{
			invisibleMonsters = !invisibleMonsters;
			if(invisMonstersString.equals("on"))
			{
				invisMonstersString = "off";
			}
			else
			{
				invisMonstersString = "on";
			}
			buttons.get(1).takeAction = false;
		}
		if(buttons.get(2).takeAction)
		{
			strobeLights = !strobeLights;
			if(strobeLightsString.equals("on"))
			{
				strobeLightsString = "off";
			}
			else
			{
				strobeLightsString = "on";
			}
			buttons.get(2).takeAction = false;
		}
		if(buttons.get(3).takeAction)
		{
			menu = 1;
			buttons.clear();
			buttonsAdded = false;
		}
	}
	else if(menu==3)
	{
		displayLeaderboard(false);
		if(!buttonsAdded)
    	{
			//println("Menu 3 add buttons");
    		buttons.add(new Button(0,0,0,0));
    		buttons.add(new Button(0,0,0,0));
    		buttons.add(new Button(0,0,0,0));
    		//Above 3 are filler buttons, below is the menu button.
    		buttons.add(new Button(220,600,buttonWidth,buttonHeight));
    		buttonsAdded = true;
    	}
    	fill(color(255,0,0));
		rect(220,600,buttonWidth,buttonHeight);
		textAlign(CENTER,CENTER);
		fill(255);
		text("Main Menu",220+buttonWidth/2,600+buttonHeight/2);
		textAlign(LEFT,BOTTOM);
	}
}