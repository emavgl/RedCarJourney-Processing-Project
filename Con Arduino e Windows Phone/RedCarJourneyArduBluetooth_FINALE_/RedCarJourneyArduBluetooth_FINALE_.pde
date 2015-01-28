//Processing - Simple Car Game + Arduino control
/*
    Red Car Journey is a simple arcade game.
    Once upon a time there was a pretty blu car. But, oneday, misteriously she became red.
    The car owner immediately thought it was a divine act, but...this act made him crazy and...made him very fast.
*/

import ddf.minim.*;
import processing.serial.*; //Library for communicate with Arduino using Serial port.
Serial myPort;  // Create object from Serial class

AudioPlayer player;
Minim minim;  //audio context
IOClass reader;

PImage bg1, bg2;
int counter;
Game nuovogioco;
boolean musicOn;
Timer contaSecondi;
int randomGreenCoin = (int)random(500, 3000);
int randomRedCoin = (int)random(500, 3000);
int maxScore = 0;

int currentVel;
void setup()
{
  reader = new IOClass("ms.ema");
  String tempScore = reader.ReadLine();
  if (tempScore != null)
  {
    maxScore = int(tempScore);
  }
  else
  {
    maxScore = 0;
  }
  
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
  currentVel = 1;
  //Setup Serial Port
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  println(portName);
  myPort = new Serial(this, portName, 9600);
  delay(2000);
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
  getDataFromSerial();
  nuovogioco.getMainCar().MoveMyCar(currentVel);
  nuovogioco.getMainCar().CheckSmoke();
  nuovogioco.scendiMacchine();
  nuovogioco.scendiMonete();
  nuovogioco.checkCoinCollision();
  nuovogioco.checkCarCollision();
  nuovogioco.checkScudo();
  checkStat();
  checkSound();
}

int val = 0;

public void getDataFromSerial()
{
  while ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.read() - 114;         // read it and store it in val
  }
  //println((val-114)/5); //print it out in the console
  currentVel = val;
}


public void checkSound()
{
  if(!player.isPlaying())
  {
    player.rewind();
    player.play();
  }
}

int oldLifes = -5;
public void lifeChange()
{
   int currentlifes = nuovogioco.getLifes();
   if (oldLifes != currentlifes)
   {
     println("changing life from " + oldLifes + " to  " + currentlifes);
     myPort.write(currentlifes); //send current lifes to arduino
     oldLifes = currentlifes;
   }
}

public void checkStat()
{
  lifeChange();
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
    if (nuovogioco.getScore() > maxScore)
    {
      maxScore = nuovogioco.getScore();
      reader.WriteLine(str(maxScore));
    }
    s = "Life " + String.valueOf(nuovogioco.getLifes());
    s2 = "Score " + String.valueOf(nuovogioco.getScore());
    fill(50);
    text(s, 6, 40, 35, 60); 
    text(s2, 6, 95, 50, 80);
    textSize(50);
    fill(0);
    String s3 = "GAME OVER.\nPRESS 'N' TO RESTART. \nYOUR RECORD IS:" + str(maxScore);
    text(s3, 200, 500);
  }
  
}

void keyPressed()
{
  if(key == 'M') MusicControl();
  if(keyCode == 'N') {nuovogioco.restartStat(); loop();}
}

void MusicControl()
{
  if (musicOn){
    player.close();
    musicOn = false;
    nuovogioco.setSound();
  }
  else  {
    player = minim.loadFile("file.mp3", 2048);
    player.play();
    musicOn = true;
    nuovogioco.setSound();
  }
}
