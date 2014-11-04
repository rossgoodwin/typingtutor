int typingSpeed = 30;

PImage hands;

PVector[] fingertips = new PVector[10];

JSONObject chords;

PVector rectLocation;
PVector originalRectLocation;

int lineNo = 0;
boolean newLine = false;
boolean ready = false;

String line2 = "";
String line3 = "";

PFont cousine;
PFont cousine72;

String article[];

void setup() {
  // load chords json
  chords = loadJSONObject("data.json");
  
  // size of canvas
  size(displayWidth, displayHeight);
  
  // rectangle pvector
  originalRectLocation = new PVector(50, height-200);
  rectLocation = new PVector(50, height-200);
  
  // load hands image
  hands = loadImage("hands.png");
  
  // fingertip pvectors
  for (int i=0;i<20;i+=2) {
    fingertips[i/2] = new PVector(locs[i], locs[i+1]);
  }
  
  // load cousine font
  cousine = loadFont("Cousine-24.vlw");
  cousine72 = loadFont("Cousine-72.vlw");
  
  // load article
  article = loadStrings("article.txt");
}

void draw() {
  // Specify charLength
  int charLength = 14;
  
  // specify current line and current character
  String curLine = article[lineNo];
  if (article.length > lineNo) {
    line2 = article[lineNo+1];
  } else {
    line2 = "";
  }
  if (article.length > lineNo+1) {
    line3 = article[lineNo+2];
  } else {
    line3 = "";
  }
  
  char curChar = curLine.charAt(int((rectLocation.x-50)/charLength));
  String curCharString = str(curChar);
  
  // background
  background(255);
  
  // hands image
  image(hands, (width-hands.width)/2, 0);
  
  // chord specification
  int chord = chords.getInt(curCharString);
  String chord_bin = binary(chord, 10);
  
  // fingertip dots
  for (int i = 0; i < 10; i++) {
    if (chord_bin.charAt(i) == '1') {
      ellipseMode(CENTER);
      noStroke();
      fill(255,0,0,100);
      ellipse(fingertips[i].x, fingertips[i].y, 50, 50);
    }
  }
  
  // border below hands image
  noStroke();
  fill(0);
  rect(0, hands.height, width, 10);
  
  // current line of text
  fill(0);
  textFont(cousine, 24);
  textAlign(LEFT, TOP);
  text(curLine, 50, height-200);
  text(line2, 50, height-170);
  text(line3, 50, height-140);
  
  // rectangle over letter
  noStroke();
  fill(255,0,0,50);
  rectMode(CORNER);
  rect(rectLocation.x, rectLocation.y, charLength, 20);
  
  // display current letter
  noStroke();
  fill(0);
  textFont(cousine72, 72);
  textAlign(CENTER, TOP);
  text(curChar, width/2, 100);
  
  // new line conditions
  if (frameCount % typingSpeed == 0 && rectLocation.x > 50+curLine.length()*(charLength-1)) newLine = true;
  
  // carriage return
  if (newLine) {
    rectLocation.x = 50-charLength;
    rectLocation.y = height-200;
    newLine = false;
    lineNo++;
    if (lineNo > article.length) exit();
  }
  
  // increment rectangle
  if (ready && frameCount % typingSpeed == 0) {
    PVector increment = new PVector(charLength, 0);
    rectLocation.add(increment);
  }
  
}

void keyPressed() {
  ready = true;
}
