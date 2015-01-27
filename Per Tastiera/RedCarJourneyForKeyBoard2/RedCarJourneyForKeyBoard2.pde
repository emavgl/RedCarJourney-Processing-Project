//Processing - Simple Car Game + Arduino control
/*
    Red Car Journey is a simple arcade game.
    Once upon a time there was a pretty blu car. But, oneday, misteriously she became red.
    The car owner immediately thought it was a divine act, but...this act made him crazy and...made him very fast.
*/

import ddf.minim.*;
int val;     // Data received from the serial port

AudioPlayer player;
Minim minim;  //audio context

PImage bg1, bg2;
int counter;
Game nuovogioco;
boolean musicOn;
Timer contaSecondi;
int randomGreenCoin = (int)random(500, 3000);
int randomRedCoin = (int)random(500, 3000);

void setup()
{
  minim = new Minim(this);
  player = minim.loadFile("file.mp3", 2048);
  player.play();
  musicOn = true;
  int dimensioneX = 1024, dimensioneY = 720;
  size(dimensioneX, dimensioneY);
  counter = 0;
  bg1 = loadImage("bgtest.png");
  bg2 = loadImage("bg2.png");
  nuovogioco = new Game();
  nuovogioco.CreateMyCar(width/2, height-220);
  creaNemici();
  creaMonete();
  fill(180, 20);
  noStroke();
  frameRate(60);
}

public void creaNemici()
{
  nuovogioco.nuovoNemico();
  nuovogioco.nuovoNemico();
  nuovogioco.nuovoNemico();
  nuovogioco.nuovoNemico();
}

public void creaMonete()
{
  nuovogioco.nuovaMoneta(0);
  nuovogioco.nuovaMoneta(0);
  nuovogioco.nuovaMoneta(0);
  nuovogioco.nuovaMoneta(0);
}

void draw()
{
  counter++;
  background(bg1);
  nuovogioco.getMainCar().Move();
  nuovogioco.getMainCar().CheckSmoke();
  nuovogioco.scendiMacchine();
  nuovogioco.scendiMonete();
  nuovogioco.checkCoinCollision();
  nuovogioco.checkCarCollision();
  nuovogioco.checkScudo();
  checkStat();
  checkSound();
}

public void checkSound()
{
  if(!player.isPlaying())
  {
    player.rewind();
    player.play();
  }
}

public void checkStat()
{
  textSize(18);
  fill(50);
  String s = "Life " + String.valueOf(nuovogioco.getLifes());
  String s2 = "Score " + String.valueOf(nuovogioco.getScore());
  fill(50);
  text(s, 6, 40, 35, 60); 
  text(s2, 6, 95, 50, 80);
  if (nuovogioco.getLifes() < 1)
  { 
    noLoop();
    background(bg1);
    s = "Life " + String.valueOf(nuovogioco.getLifes());
    s2 = "Score " + String.valueOf(nuovogioco.getScore());
    fill(50);
    text(s, 6, 40, 35, 60); 
    text(s2, 6, 95, 50, 80);
    textSize(50);
    fill(0);
    String s3 = "GAME OVER.\nPRESS 'N' TO RESTART";
    text(s3, 200, 500);
  }
  
}

void keyPressed()
{
  if(key == 'M') MusicControl();
  if(keyCode == 'N') {nuovogioco.restartStat(); loop();}
  if(key == CODED)
  {
    if(keyCode == LEFT){ nuovogioco.getMainCar().setDestination(nuovogioco.getMainCar().getPosX()-160, nuovogioco.getMainCar().getPosY());/* nuovogioco.getMainCar().setImage("Car3_LEFT.png");*/}
    if(keyCode == RIGHT){ nuovogioco.getMainCar().setDestination(nuovogioco.getMainCar().getPosX()+160, nuovogioco.getMainCar().getPosY()); /*nuovogioco.getMainCar().setImage("Car3_RIGHT.png");*/}
  }
}

void MusicControl()
{
  if (musicOn){
    player.close();
    musicOn = false;
  }
  else  {
    player = minim.loadFile("file.mp3", 2048);
    player.play();
    musicOn = true;
  }
}

void keyReleased()
{
}

