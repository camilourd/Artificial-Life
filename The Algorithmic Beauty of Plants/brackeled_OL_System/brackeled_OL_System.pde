OLSystem ol = new OLSystem();
int maxn = 7;
float d = 5;
float angle = 90;
float delta = 22.5;
int n = 0;
int lastTime;
String start = "X";

void setup() {
  size(600, 600);
  lastTime = millis();
  ol.addRule("X", "F-[[FX]+X]+F[+FX]-X");
  ol.addRule("F", "FF");
}

void draw() {
  background(255);
  int currentTime = millis();
  if(currentTime - lastTime > 4000) {
    n = (n + 1) % maxn;
    lastTime = currentTime;
  }
  drawSequence(ol.replace(start, n));
}

void drawSequence(String sequence) {
  pushMatrix();
  translate(width / 2, height);
  rotate(radians(270));
  for(int i = 0; i < sequence.length(); i++) {
    char c = sequence.charAt(i);
    if(c == 'F') {
      line(0, 0, d, 0);
      translate(d, 0);
    } else if(c == '+') {
      rotate(radians(-delta));
    } else if(c == '-') {
      rotate(radians(delta));
    } else if(c == '[') {
      pushMatrix();
    } else if(c == ']') {
      popMatrix();
    }
  }
  popMatrix();
}