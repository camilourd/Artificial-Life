class OLSystem {
  HashMap<String, String> rules;
  
  OLSystem() {
    rules = new HashMap<String, String> ();
  }
  
  void addRule(String pattern, String replacement) {
    rules.put(pattern, replacement);
  }
  
  String replace(String word, int iterations) {
    String result = word;
    for(int i = 0; i < iterations; i++) {
      String temp = "";
      for(int c = 0; c < result.length(); c++) {
        String rkey = "" + result.charAt(c);
        if(rules.get(rkey) != null) {
          temp += rules.get(rkey);
        } else {
          temp += rkey;
        }
      }
      result = temp;
    }
    return result;
  }
  
}