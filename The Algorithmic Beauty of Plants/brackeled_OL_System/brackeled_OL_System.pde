//import remixlab.bias.branch.*;
import remixlab.bias.core.*;
import remixlab.bias.event.*;
//import remixlab.dandelion.branch.*;
import remixlab.dandelion.constraint.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;
import remixlab.fpstiming.*;
import remixlab.proscene.*;
import remixlab.util.*;

String renderer = P3D;
PGraphics canvas;
Scene scene;

OLSystem ol = new OLSystem();
float angle = 90;
int n = 0;
int lastTime;
String start = "X";

void setup() {
  size(620, 620, renderer);
  canvas = createGraphics((int)width, (int)height, renderer);
  scene = new Scene(this, (PGraphics3D) canvas);
  scene.setGridVisualHint(false);
  //scene.setAxesVisualHint(false);
  scene.setRadius(150);
  scene.showAll();
  lastTime = millis();
  //ol.addRule("F", "FF-[-^F+.F+.F]+[+.F-^F-^F]"); -> 1
  //ol.addRule("F", "F[+.F]F[-^F][F]"); -> 2
  ol.addRule("X", "F-^[[X]+.X]+.F[+.FX]-^X");
  ol.addRule("F", "FF");
}

void draw() {
  background(255);
  scene.beginDraw();
  drawSequence(scene.pg(), ol.replace(start, maxn));
  scene.endDraw();
  scene.display();
  int currentTime = millis();
  if(currentTime - lastTime > 4000) {
    n = (n + 1) % maxn;
    lastTime = currentTime;
  }
}

int maxn = 5;
float d = 3;
float w = 6;
float delta = 22.5;
float gamma = 70;
float dw = 0.5;
float dd = 0.25;

void drawSequence(PGraphics pg, String sequence) {
  float s = w, l = d;
  pg.background(255);
  pg.pushMatrix();
  pg.translate(0, 0);
  pg.rotate(radians(270));
  for(int i = 0; i < sequence.length(); i++) {
    char c = sequence.charAt(i);
    if(c == 'F') {
      pg.strokeWeight(s);
      pg.line(0, 0, l, 0);
      pg.translate(l, 0);
    } else if(c == '+') {
      pg.rotateY(radians(-delta));
      //pg.rotateX(radians(-gamma / (maxn - level + 1)));
    } else if(c == '-') {
      pg.rotateY(radians(delta));
      //pg.rotateX(radians(gamma / (maxn - level + 1)));
    } else if(c == '[') {
      pg.pushMatrix();
      s *= (1 - dw);
      l *= (1 - dd);
    } else if(c == ']') {
      pg.popMatrix();
      s /= (1 - dw);
      l /= (1 - dd);
    } else if(c == '.') {
      pg.rotateX(radians(-gamma));
    } else if(c == '^') {
      pg.rotateX(radians(gamma));
    }
  }
  pg.popMatrix();
}

void keyPressed() {
  println(key);
}