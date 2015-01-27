class Timer {
  int timerStart = 0;
  int offset;
  
  int mill;
  int minutes;
  int seconds;
  int hundredths;
  
  boolean stopped = false;
  boolean continued = false;
  
  Timer() {
    
  }
  
  void update() {
    if(!stopped) {
  mill=(millis()-timerStart);
  if(continued) mill += offset;
  
  seconds = mill / 1000;
  minutes = seconds / 60;
  seconds = seconds % 60;
  hundredths = mill / 10 % 100;
    }
  }
  
  void pause() { stopped = true; }
  
  void unpause() {
    stopped = false;
    continued = true;
    timerStart = millis();
    
    offset = mill;
  }
  
  void reset() {
    stopped = false;
    continued = true;
    timerStart = millis();
  }
  
  int minutes() { return minutes; }
  int seconds() { return seconds; }
  int hundredths() { return hundredths; }
  
  boolean isPaused() { return stopped; }
} 
