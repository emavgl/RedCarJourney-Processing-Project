class puff {
  float x;
  float y;
  int arraySize = 20;
  float[] randomX = new float[arraySize];
  float[] randomY = new float[arraySize];
  int timer = arraySize;
  int radius = 10;
   
  // Constructor
  puff(float xpos, float ypos) {
    x = xpos;
    y = ypos;
    for(int i = 0; i < arraySize; i++) {
      randomX[i] = random(-5,5);
      randomY[i] = random(-10,15);
    }
  }
   
  void displayAndFade() {
    for(int i = 0; i < timer; i++) {
      ellipse(x+randomX[i],y+randomY[i],radius,radius);
    }
  //  this.timer--;
  //  println("timer: " + this.timer);
  }
     
}
