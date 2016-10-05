class Curve {
  Node[] lines;
  
  Curve(Line a, Line b, Line c, int maxDepth) {
    lines = new Node[3];
    lines[0] = new Node(a, 1);
    lines[1] = new Node(b, 1);
    lines[2] = new Node(c, 1);
    for(int i = 0; i < lines.length; i++)
      build(lines[i], maxDepth);
  }
  
  void build(Node nd, int maxDepth) {
    if(nd.depth < maxDepth) {
      nd.createChilds();
      for(int i = 0; i < nd.childs.length; i++)
        build(nd.childs[i], maxDepth);
    }
  }
  
  void display(int maxDepth) {
    for(int i = 0; i < lines.length; i++)
      lines[i].display(maxDepth);
  }
  
}