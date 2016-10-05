class Node {
  Line line;
  Node[] childs;
  int depth;
  
  Node(Line line, int depth) {
    this.line = line;
    this.childs = null;
    this.depth = depth;
  }
  
  void display(int maxDepth) {
    if(depth == maxDepth) {
      line.display();
    } else if(childs != null) {
      for(int i = 0; i < childs.length; i++)
        childs[i].display(maxDepth);
    }
  }
  
  void createChilds() {
    float size = line.length() / 3.0;
    childs = new Node[4];
    Point d = line.a.direction(line.b);
    Point start = line.a;
    childs[0] = new Node(new Line(start, start.add(d.scale(size))), depth + 1);
    d.rotate(TWO_PI / 8.0);
    start = childs[0].line.b;
    childs[1] = new Node(new Line(start, start.add(d.scale(size))), depth + 1);
    
    d = line.b.direction(line.a);
    start = line.b;
    childs[2] = new Node(new Line(start, start.add(d.scale(size))), depth + 1);
    d.rotate(-TWO_PI / 8.0);
    start = childs[0].line.b;
    childs[3] = new Node(new Line(start, start.add(d.scale(size))), depth + 1);
  }
  
}