class MyCar
{
  private PImage img;
  private int dimX;
  private int dimY;
  private int posX, posY;
  private int posX2, posY2;
  private int speed;
  private Smoke mSmoke;
  private boolean scudo;
  private RectPositionCollision carRectCollision;
  
  public MyCar(int posX, int posY, int type)
  {
     if (type == 1)
     {
       img = loadImage("Car3Enemy.png");
     }
     else
     {
        img = loadImage("Car3.png");
     }
     dimX = img.width;
     dimY = img.height;
     this.posX = posX;
     this.posY = posY;
     mSmoke = new Smoke();
     speed = 10;
     this.posX2 = posX;
     this.posY2 = posY;
     scudo = false;
     carRectCollision = new RectPositionCollision();
     image(img, posX, posY);
  }
  
    public void setPosition(int posX, int posY)
  {
    this.posX = posX;
    this.posY = posY;
  }
  
  public void setRectPositionCollision()
  {
    carRectCollision.buildRectCollision(this.posX, this.posY, 0);
  }
  
  public RectPositionCollision getRectPositionCollision()
  {
    return carRectCollision;
  }
  
  public void setImage(String path)
  {
    img = loadImage(path);
  }
  
  public void BaseMovement(int posX, int posY)
  {
    this.posX = posX;
    this.posY = posY;
    image(img, posX, posY);
    fill(180, 20);
    if(scudo)
    {
      fill(0, 255, 0, 50);
      ellipse(posX+22+42, posY+6+86, 180, 180);
    }
  }
  
  public void setDestination(int posX2, int posY2)
  {
      this.posX2 = constrain(posX2, 62, 842); 
      this.posY2 = constrain(posY2, 9, 660);
  }
  
  public int getPosX() {return posX;}
  public int getPosX2() {return posX2;}
  public int getPosY() {return posY;}
  public int getPosY2() {return posY2;}
  
  public void CheckSmoke()
  {
      mSmoke.checkPuff();
  }
  
  public void setScudo(boolean x)
  {
     this.scudo = x;
  }
  
  public boolean isScudoOn()
  {
     return this.scudo;
  }
  
  public void Move()
  {
    if(posX >= posX2){
    if(posX != posX2){ 
      posX -= speed;
    }
    BaseMovement(posX, posY);
    if (mSmoke.GetPuffIndex() < 5) mSmoke.MakeSmoke(this.posX+40, this.posY+190);

    }
    else
    {
      if(posX != posX2){
        posX += speed;
      }
      BaseMovement(posX, posY);
      if (mSmoke.GetPuffIndex() < 5) mSmoke.MakeSmoke(this.posX+40, this.posY+190);
    }
  }
  
}
