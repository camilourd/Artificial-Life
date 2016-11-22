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

void setup() {
  size(620, 620, renderer);
  canvas = createGraphics((int)width, (int)height, renderer);
  scene = new Scene(this, (PGraphics3D) canvas);
  scene.setGridVisualHint(false);
  //scene.setAxesVisualHint(false);
  scene.setRadius(150);
  scene.showAll();
  savannah = new Savannah(80, 80, 160, 0.2, 4);
  savannah.init(100, 10, 10, 6);
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
  savannah.update();
  pg.background(0);
  savannah.draw(pg);
}