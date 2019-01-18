import processing.sound.*;
import java.util.*;
import java.io.*;

class Point
{
    public int x=-1,y=-1;

    Point(){}

    Point(int xx,int yy)
    {
        x = xx;
        y = yy;
    }

    void setCoords(int xx,int yy)
    {
        x = xx;
        y = yy;
    }
}

void setup()
{
    //println(color(10,10,10,0));
    //println(color(50));
    //Invader = new Sprite(monsterImageWhite,100,"png",5);
    //Background1 = new SoundFile(GalaxGame.this,BGM1);
    //Background2 = new SoundFile(GalaxGame.this,BGM2);
    stars = new Star[100];
    powerUps = new ArrayList<PowerUp>();
    fallingMonsters = new ArrayList<Sprite>();
    fallingCoords = new ArrayList<Point>();
    backgroundColor = color(50);
    for(int i=0; i<stars.length; i++)
    {
        stars[i] = new Star(random(0,width),random(0,height),random(1,4),random(0,255),random(4,6));   
    }
    bullets = new ArrayList<Sprite>();
    exploding = new ArrayList<Sprite>();
    buttons = new ArrayList<Button>();
    buttonsAdded = false;
    if(firstRunThrough)
    {
        bulletSounds = new SoundFile[100];
        explosionSounds = new SoundFile[50];
        for(int i=0; i<50; i++)
        {
            bulletSounds[2*i] = new SoundFile(GalaxGame.this,shipShootSF);
            bulletSounds[2*i].amp(.2);
            bulletSounds[2*i].rate(11025.0/44100);
            bulletSounds[2*i+1] = new SoundFile(GalaxGame.this,shipShootSF);
            bulletSounds[2*i+1].amp(.2);
            bulletSounds[2*i+1].rate(11025.0/44100);
            explosionSounds[i] = new SoundFile(GalaxGame.this,invaderDSF);
            explosionSounds[i].amp(.2);
            explosionSounds[i].rate(11025.0/44100);
        }
        firstRunThrough = false;
    }
    
    fireableBullets = 1;
    bulletsPerShot = 1;
    bulletSpeed = ymov;
    bulletType = 'R';
    shipHealth = 1;
    bulletDamage = 1;
    score = 0;
    stage = 0;
    attackingMonster = false;
    monstersLeft = monsterCol * monsterRow;
    leftMostColumn = 0;
    rightMostColumn = monsterCol - 1;
    lastRow = monsterRow - 1;
    
    //soundsPlaying = new ArrayList<SoundFile>();
    //durations = new ArrayList<Float>();
    //startTime = new ArrayList<Integer>();
    
    //Background1.loop();

    //SoundFile explosionSound = new SoundFile(GalaxGame.this,explosionSoundFile);
    //SoundFile shipShootSound = new SoundFile(GalaxGame.this,shipShootSF);
  	size(960,950);
    //fullScreen();
    explosion = new Animation(explosionPrefix,100,"png",5);
    explosion.stretch(4);
    //explosion.removeBlack(10);
    invaderExplosion = new Sprite(invaderExp,100,"png",5);
    invaderExplosion.image.stretch(2);

    invaderDeath = new Sprite(invaderD,0,0);
    invaderDeath.image.stretch(5);

  	gameOverScreen = loadImage("GameOver.png");
  	background(0);
  	frameRate(60);
  	keys = new boolean[amtKeys];
  	for(int i=0; i<amtKeys; i++)
  	{
    	keys[i] = false;
  	}
  	monsters = new Sprite[monsterRow][monsterCol];
    initializeGrid(monsters);

  	ship = new Sprite(shipImage,width/2,height - spriteDim);
    ship.removeBlack(19);
  	bullet = new Sprite(bulletImage,-1,-1);
    LeaderBoard = new ArrayList<String>();
    try
    {
        input = new Scanner(new File(dataPath("LeaderBoard.txt")));
    }
    catch(Exception e)
    {
        println("There is no leaderboard text file");
    }
    while(input.hasNextLine())
    {
        LeaderBoard.add(input.nextLine());
    }
}

void draw()
{
	//println(bullet.x);
	//println(lastRow);
    //println("Menu is " + menu);
    if(paused)
    {
        return;
    }
    if(counter%120==0)
    {
        System.gc();
    }
    if(!gameOver && menu==0)
    {
        Game();
    }
    else if(menu!=0)
    {
        Menu();
        //buttons.clear();
    }
    else
    {
        GameOver();
        //buttons.clear();
    }
	
}