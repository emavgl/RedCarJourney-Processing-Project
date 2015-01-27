class RectPositionCollision
{
   public int posXUP_LEFT;
   public int posYUP_LEFT;
   
   public int posXUP_RIGHT;
   public int posYUP_RIGHT;
   
   public int posXDOWN_LEFT;
   public int posYDOWN_LEFT;
   
   public int posXDOWN_RIGHT;
   public int posYDOWN_RIGHT;
   
   public RectPositionCollision()
   {
   }
   
   public void buildRectCollision(int posX, int posY, int type)
   {
     if (type == 0)
     {
        posXUP_LEFT = posX+22;
        posYUP_LEFT = posY+6;
        
        posXDOWN_RIGHT = posX+105;
        posYDOWN_RIGHT = posY+178;
        
        posXUP_RIGHT = posX+105;
        posYUP_RIGHT = posY+6;
        
        posXDOWN_LEFT = posX+22;
        posYDOWN_LEFT = posY+178;
     }
     
     if (type == 1)
     {
        posXUP_LEFT = posX;
        posYUP_LEFT = posY;
        
        posXDOWN_RIGHT = posX+56;
        posYDOWN_RIGHT = posY+56;
        
        posXUP_RIGHT = posX+56;
        posYUP_RIGHT = posY;
        
        posXDOWN_LEFT = posX;
        posYDOWN_LEFT = posY+56;
     }
   }
   
   public boolean isCollideWith(RectPositionCollision enemy)
   {
      if (this.posYUP_LEFT > enemy.posYDOWN_LEFT || enemy.posYUP_LEFT > height-100){
        return false;
      }
      if (enemy.posXDOWN_LEFT > this.posXUP_LEFT && enemy.posXDOWN_LEFT < this.posXUP_RIGHT){return true;}
      if (enemy.posXDOWN_RIGHT > this.posXUP_LEFT && enemy.posXDOWN_RIGHT < this.posXUP_RIGHT){return true;}
      return false;
   }
}
