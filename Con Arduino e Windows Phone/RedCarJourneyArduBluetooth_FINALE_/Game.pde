import ddf.minim.*;

AudioPlayer player2;
Minim minimcoin;//audio context

AudioPlayer carPlayer;

class Game
{
  private int score;
  private int lifes;
  private MyCar mainCar;
  private MyCar[] enemyCars;
  private MyCoin[] coins;
  private int coinIndex = 0;
  private int carIndex = 0;
  private int indexPrimaCoin = 0;
  private int indexPrimaCar = 0;
  private boolean soundOn = false;
  
  public Game()
  {
    score = 0;
    lifes = 4;
    enemyCars = new MyCar[4]; 
    coins = new MyCoin[4];
    minimcoin = new Minim(this);
    setSound();
  }
  
  public void CreateMyCar(int posX, int posY)
  {
     mainCar = new MyCar(posX, posY, 0);
  }
  
  public MyCar getMainCar()
  {
    return mainCar;
  }
  
  public void setSound()
  {
    if (!soundOn)
    {
      player2 = minim.loadFile("coin.wav", 1024);
      carPlayer = minim.loadFile("car.wav", 1000);
      soundOn = true;
    }
    else
    {
      player2.close();
      carPlayer.close();
      soundOn = false;
    }
  }
  
  public void nuovaMoneta(int type)
  {
    int x = (int)random(62, 842);
    int y = (int)random(-1300, -300);
    if (coinIndex < 4)
    {
      coins[coinIndex] = new MyCoin(x, y, type);
      coinIndex++;
    }
  }
  
  public void scendiMonete()
  {
    Boolean trovato = false;
    int x = (int)random(62, 842);
    int y = (int)random(-1300, -300);
    int fine = 4;
    if (coinIndex < 4) { fine = coinIndex; } 
    for (int i = 0; i < fine; i++)
    {
      coins[i].BaseMovement(coins[i].getPosX(), coins[i].getPosY()+8);
      if (coins[i].getPosY() > 730)
      {
        if (coins[i].getType() == 1 || coins[i].getType() == 2){ coins[i].changeType(0);}
        if (coinIndex%100 == 20){coins[i].changeType(1);}
        if (coinIndex%100 == 60){coins[i].changeType(2);}
        coins[i].setPosition(x, y);
        coinIndex++;
      }
    }
  }
  
  public void restartStat()
  {
    lifes = 4;
    score = 0;
  }
  
 public void checkScudo()
 {
       if (mainCar.isScudoOn() == true)
       {
         if (coinIndex%20 == 0)
         {
           mainCar.setScudo(false);
         }
       }
 }
  
  public void nuovoNemico()
  {
    int x = (int)random(62, 842);
        int y = (int)random(-1300, -300);
    if (carIndex < 4)
    {
      enemyCars[carIndex] = new MyCar(x, y, 1);
      carIndex++;
    }
  }
  
  public void scendiMacchine()
  {
   int x = (int)random(62, 842);
        int y = (int)random(-1300, -300);
    int fine = 4;
    if (carIndex < 4) { fine = carIndex; }
    for (int i = 0; i < fine; i++)
    {
      enemyCars[i].BaseMovement(enemyCars[i].getPosX(), enemyCars[i].getPosY()+8);
      if (enemyCars[i].getPosY() > 730)
      { 
        enemyCars[i].setPosition(x, y);
      }
    }
  }
    
  public void checkCoinCollision()
  {
      int x = (int)random(62, 842);
      int y = (int)random(-1300, -300);
      boolean collision = false;
      boolean greenCollision = false;
      boolean redCollision = false;
      mainCar.setRectPositionCollision();
      RectPositionCollision mainCarRect = mainCar.getRectPositionCollision();
      int fine = 4;
      if (coinIndex < 4) { fine = coinIndex; }
      int i = 0;
      for (i = 0; i < fine; i++)
      {
         coins[i].setRectPositionCollision();
         RectPositionCollision new_xcoin = coins[i].getRectPositionCollision();
         collision = mainCarRect.isCollideWith(new_xcoin);
         if (collision)
         {
           if(coins[i].getType() == 1)
           {
             greenCollision = true;
           }
           if(coins[i].getType() == 2)
           {
             redCollision = true;
           }
           break;
         }
      }
      
      if (collision == true)
      {
         score++;
         if (score%50 == 0) { if (lifes < 4){ lifes+=1;} }
         if (coins[i].getType() == 1 || coins[i].getType() == 2){ coins[i].changeType(0);}
         coins[i].setPosition(x, y);
         if (greenCollision)
         {
           if (lifes < 4){ lifes+=1;}
           mainCar.setScudo(true);
         }
         if (redCollision)
         {
           score+=200;
           if (lifes < 4){ lifes+=1;}
         }
         
         player2.rewind();
         player2.play();
      }
  }
  
  public void checkCarCollision()
  {
        int x = (int)random(62, 842);
        int y = (int)random(-1300, -300);
        boolean collision = false;
        int fine = 4;
        if (carIndex < 4){ fine = carIndex; }
        int i = 0;
        mainCar.setRectPositionCollision();
        RectPositionCollision mainCarRect = mainCar.getRectPositionCollision();
        for (i = 0; i < fine; i++)
        {
           enemyCars[i].setRectPositionCollision();
           RectPositionCollision enemyCarRect = enemyCars[i].getRectPositionCollision();
           collision = mainCarRect.isCollideWith(enemyCarRect);
           if (collision) break;
        }
        
        if (collision == true)
        {
           if(mainCar.isScudoOn() == false)
           {
             lifes--;
           }
           enemyCars[i].setPosition(x, y);
           indexPrimaCar++;
           
          carPlayer.rewind();
          carPlayer.play();
        }
        
        
  }
  
  public int getScore()
  {
     return score;
  }
  
  public int getLifes()
  {
     return lifes;
  }
}
