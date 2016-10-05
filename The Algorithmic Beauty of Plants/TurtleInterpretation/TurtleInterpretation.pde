String word = "F-F-F-F";
String replacement = "F-F+F-F-F";
int n = 0;
float d = 5;
float alpha = 90;

int lastTime;

void setup() {
  size(700, 700);
  lastTime = millis();
}

void draw() {
  background(255);
  int currentTime = millis();
  if(currentTime - lastTime > 4000) {
    n = (n + 1) % 6;
    lastTime = currentTime;
  }
  drawSequence(replace(n));
}

String replace(int iterations) {
  String result = word;
  for(int i = 0; i < iterations; i++) {
    result = result.replaceAll("F", replacement);
  }
  return result;
}

void drawSequence(String sequence) {
  Point p = new Point(width / 4, height / 2 + height / 4);
  float angle = 0.0;
  for(int i = 0; i < sequence.length(); i++) {
    if(sequence.charAt(i) == 'F') {
      Point next = p.move(d, (PI * angle) / 180.0);
      line(p.x, p.y, next.x, next.y);
      p = next;
    } else if(sequence.charAt(i) == 'f') {
      p = p.move(d, (PI * angle) / 180.0);
    } else if(sequence.charAt(i) == '+') {
      angle += alpha;
    } else {
      angle -= alpha;
    }
  }
}