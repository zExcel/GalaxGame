class Sprite
{
    public Animation image;
    public int imageWidth, imageHeight;
    public float x, y;
    public boolean blank = false, activeBullet = false;
    public int numberBullets = 0;
    public float angleShot = 0,angleMove = 0;
    public boolean attacking = false;
    public Sprite parent = null;
    public boolean enemy = false;
    public boolean monster = false;
    public double health = 1;
    //public ArrayList<Bullet> bullets;

    public void Clamp()
    {
        if (x<0)
            x = 0;
        if (x>=width - spriteDim)
            x = width - spriteDim;
    }

    Sprite(String file, float xx, float yy)
    {
        //bullets = new ArrayList<Bullet>();
        image = new Animation(file);
        x = xx;
        y = yy;
        imageWidth = image.imageWidth;
        imageHeight = image.imageHeight;
    }

    Sprite(String filePrefix, int numberFrames, String extension, int digits)
    {
        //bullets = new ArrayList<Bullet>();
        image = new Animation(filePrefix, numberFrames, extension, digits);
        imageWidth = image.imageWidth;
        imageHeight = image.imageHeight;
    }

    void setCoords(float xx, float yy)
    {
        x = xx;
        y = yy;
    }

    void updateCoords(float addX, float addY)
    {
        if (!enemy)
        {
            x+=addX;
            y+=addY;
        } else
        {
            //println(angleShot);
            float total = sqrt(addX*addX + addY*addY);

            x-=total*sin(angleMove);
            y+=total*cos(angleMove);
        }
        //this.Clamp();
    }

    void updateImage(String file)
    {
        image = new Animation(file);
        imageWidth = image.imageWidth;
        imageHeight = image.imageHeight;
    }

    void draw(Sprite ship, boolean turn)
    {
        //float angle = 0;
        if (turn && ship.y>y)
        {
            angleShot = -1*atan(1.0*(ship.x - x)/(ship.y - y));
            if (angleShot<-PI/3)
            {
                angleShot = -PI/3;
            } else if (angleShot > PI/3)
            {
                angleShot = PI/3;
            }
            //println("angle is: " + angle);
        }
        imageMode(CENTER);
        translate(x + imageWidth/2, y + imageHeight/2);
        rotate(angleShot);
        image.draw(0,0);
        //image(image, 0, 0);
        rotate(-angleShot);
        translate(-x - imageWidth/2, -y - imageHeight/2);
    }

    void removeBlack(int error)
    {
        for(int i=0; i<image.numFrames; i++)
        {
            image.frames[i].loadPixels();

            for(int index = 0; index<imageHeight*imageWidth; index++)
            {
                if((image.frames[i].pixels[index]&0xFFFFFF) <= color(error,error,error,0))
                {
                    //image.frames[i].pixels[index] = color(backgroundColor);
                    image.frames[i].pixels[index] = color(0,0,0,1);
                }
                else if(invisibleMonsters && monster)
                {
                    image.frames[i].pixels[index] = color(0,0,0,1);
                }
            }
            image.frames[i].updatePixels();
        }
    }

    void shoot(Sprite ship, boolean turned)
    {
    }
}