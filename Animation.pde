
class Animation
{
    public PImage frames[];
    public int numFrames;
    public int literalFrames;
    public int currentFrame;
    public float timer;
    public float delay;
    public int multiplier=1;
    public int imageWidth,imageHeight;

    int getDigits(int number)
    {
        if(number==0)
            return 1;
        int counter=0;
        while(number>0)
        {
            number/=10;
            counter++;
        }
        return counter;
    }

    Animation(String filePrefix,int numberFrames,String extension,int digits)
    {
        currentFrame = 0;
        frames = new PImage[numberFrames];
        for(int i=0; i<numberFrames; i++)
        {
            String number = ""+i;
            for(int j=0; j<digits-getDigits(i); j++)
            {
                number = "0" + number;
            }
            //println("Number is " + number);
            File f = new File(dataPath(filePrefix + number + "." + extension));
            //File g = new File(dataPath("data/" + f.getName()));
            if(!f.getAbsoluteFile().exists())
            {
            	numFrames = i;
            	literalFrames = i;
            	break;
            }
            frames[i] = loadImage(f.getName());
        }
        imageWidth = frames[0].width;
        imageHeight = frames[0].height;
    }

    Animation(String file)
    {
    	numFrames = 1;
    	literalFrames = 1;
    	frames = new PImage[1];
    	frames[0] = loadImage(file);
    	imageWidth = frames[0].width;
        imageHeight = frames[0].height;
    }

    void setFrameRate(float tim,float del)
    {
    	timer = tim;
    	delay = del;
    }

    void stretch(int constant)
    {
    	literalFrames*=constant;
    	multiplier = constant;
    }

    void draw(float x,float y)
    {
        image(frames[currentFrame/multiplier],x,y);
        currentFrame = (currentFrame+1)%literalFrames;
    }

    /*void removeBlack(int error)
    {
        for(int i=0; i<literalFrames; i++)
        {
            frames[i].loadPixels();
            for(int index = 0; index<imageHeight*imageWidth; index++)
            {
                if((frames[i].pixels[index]&0xFFFFFF) <= color(error,error,error,0))
                {
                	//frames[i].pixels[index] = color(backgroundColor);
                    frames[i].pixels[index] = color(0,0,0,0);
                }            
            }
            frames[i].updatePixels();
        }
    }*/
}
