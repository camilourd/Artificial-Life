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

Savannah savannah;

String renderer = P3D;
PGraphics canvas;
Scene scene;
boolean pause;

void setup() {
  size(620, 620, renderer);
  canvas = createGraphics((int)width, (int)height, renderer);
  scene = new Scene(this, (PGraphics3D) canvas);
  scene.setGridVisualHint(false);
  //scene.setAxesVisualHint(false);
  scene.setRadius(150);
  scene.showAll();
  savannah = new Savannah(80, 80, 160, 0.2, 4);
  savannah.init(400, 30, 5, 3);
  pause = false;
}

void draw() {
  background(0);
  scene.beginDraw();
  drawObjects(scene.pg());
  scene.endDraw();
  scene.display();
  try {
    Thread.sleep(50);
  } catch (InterruptedException ex) {}
}

void drawObjects(PGraphics pg) {
  if(!pause)
    savannah.update();
  pg.background(0);
  savannah.draw(pg);
}

void keyPressed() {
  if(key == ' ')
    pause = !pause;
  else if(key == 't')
    savannah.trees = !savannah.trees;
  else if(key == 'f')
    savannah.floor = !savannah.floor;
  else if(key == 'v')
    savannah.vision = !savannah.vision;
  else if(key == 'p')
    savannah.polution = !savannah.polution;
}