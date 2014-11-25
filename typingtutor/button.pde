class Button {
  
  PVector pos;
  int widthHeight;
  String label;
  color textCol, buttonCol, activeCol, shadowCol;
  boolean pressed;
  Button (float xPos, float yPos, String _label) {
    pos = new PVector(xPos, yPos);
    widthHeight = 70;
    label = _label;
    textCol = color(255, 255, 255);
    buttonCol = color(144, 198, 149);
    activeCol = color(245, 215, 110);
    shadowCol = color(0, 20);
    pressed = false;
  }
  
  void display() {
    noStroke();
    
    if (pressed) {
      fill(activeCol);
    } else {
      fill(buttonCol);
    }
    
    rectMode(CENTER);
    rect(pos.x, pos.y, widthHeight, widthHeight);
    
    fill(textCol);
    textFont(cousine);
    textAlign(CENTER, CENTER);
    text(label, pos.x, pos.y);
    
    if (pressed) {
      
      fill(shadowCol);
      rect(pos.x, pos.y, widthHeight, widthHeight);
      
    } else {
      
      fill(shadowCol);
      rect(pos.x, pos.y+32, widthHeight, 6);
      
    }
    
  }
  
}
