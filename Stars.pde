class Star
{
	float x,y,size;
	float speed;
	color c;
	Star()
	{
		x=0; y=0;
		speed = 10;
		c = color(255);
		size = 10;
	}

	Star(float xx,float yy,float s,float alpha,float si)
	{
		y = yy;
		x = xx;
		speed = s;
		c = color(255,alpha);
		size = si;
	}

	void update()
	{
		y+=speed;
		if(y>height)
		{
			y = 0;
			x = random(0,width);
			speed = random(1,4);
			c = color(255,random(0,255));
			size = random(4,6);
		}
	}
	void draw()
	{
		update();
		fill(c);
		ellipse(x,y,size,size);
	}
}