class MyCoin
{
  private int posX;
  private int posY;
  private PImage current;
  private PImage normale;
  private PImage verde;
  private PImage rossa;
  private RectPositionCollision coinRectCollision;

  
  private int type;
  
  public MyCoin(int posX, int posY, int type)
  {
    normale = loadImage("coin.gif");
    verde = loadImage("coingreen.png");
    rossa = loadImage("coinred.png");
    
    if(type == 0)
    {
      current = normale;
    }
    
    if(type == 1)
    {
      current = verde;
    }
    
    if(type == 2)
    {
      current = rossa;
    }
    
    this.type = type;
    this.posX = posX;
    this.posY = posY;
    coinRectCollision = new RectPositionCollision();
    image(current, this.posX, this.posY);
  }
  
  public int getType()
  {
    return type;
  }
  
  public void setRectPositionCollision()
  {
    coinRectCollision.buildRectCollision(this.posX, this.posY, 1);
  }
  
  public RectPositionCollision getRectPositionCollision()
  {
    return coinRectCollision;
  }
  
  public void changeType(int type)
  {
    if(type == 0)
    {
      this.type = type;
      current = normale;
    }
    
    if(type == 1)
    {
      this.type = type;
      current = verde;

    }
    
    if(type == 2)
    {
      this.type = type;
      current = rossa;
    }
  }
  
  public void setPosition(int posX, int posY)
  {
    this.posX = posX;
    this.posY = posY;
  }
  
  public void BaseMovement(int posX, int posY)
  {
    this.posX = posX;
    this.posY = posY;
    image(current, this.posX, this.posY);
  }
  
  public int getPosX() {return posX;}
  public int getPosY() {return posY;}
}
