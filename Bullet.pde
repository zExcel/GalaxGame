abstract class Bullet
{
	public int maxShoot = 0;
	public float x=0,y=0;
	
	Bullet(){maxShoot = 1;}
	Bullet(int x){maxShoot = x;}



    public abstract void draw();
}

class RegularBullet extends Bullet
{

	private int maxShoot;

	RegularBullet(){super(1);}
	RegularBullet(int x){super(x);}

	void setCoords(float xx,float yy)
	{
		x = xx;
		y = yy;
	}

    public void draw()
    {
    	y += -1*ymov;
    }
}