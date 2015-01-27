class Smoke
{
  private int arraySize;
  private int puffsAlive;
  private puff[] puffArray;
  private int puffIndex;
  
  private puff fumo;
  
  public Smoke()
  {
     puffIndex = 0;
     puffsAlive = 0;
     puffArray = new puff[20];
  }
  
  public void setFumo(float posX, float posY)
  {
     fumo = new puff(posX, posY);
  }
  
  public int GetPuffIndex()
  {
     return puffIndex;
  }
  
  public int GetPuffsAlive()
  {
     return puffsAlive;
  }
  
  public void DecresePuffsAlive()
  {
     puffsAlive--;
  }
  
  public void DecresePuffsIndex()
  {
     puffIndex--;
  }
  
  public void MakeSmoke(float posXFumo, float posYFumo)
  {
      fumo = new puff(posXFumo, posYFumo);
      puffArray[puffIndex] = fumo;
      puffArray[puffIndex].displayAndFade();
      puffsAlive++;
      puffIndex = (puffIndex+1)%50;
  }
  
  public void checkPuff()
  {
    if(puffsAlive > 0) {
      for (int i = puffsAlive; i > 0 ; i--) {
        int pos = (puffIndex-i);
        puffArray[pos].displayAndFade();
        puffArray[pos].timer--;
    
      }
      for(int i = puffsAlive; i > 0; i--) {
        int pos = (puffIndex-i);
        if(puffArray[pos].timer < 1) {
           
          puffsAlive--;
          puffIndex--;
          }
      }
    }
  }
  
}
