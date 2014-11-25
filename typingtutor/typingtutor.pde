// int typingSpeed = 15;

PImage hands;

PVector[] fingertips = new PVector[10];

JSONObject chords;

PVector rectLocation;
PVector originalRectLocation;

int lineNo = 0;
boolean newLine = false;
//boolean ready = false;

int sliderY;

String line2 = "";
String line3 = "";

PFont cousine;
PFont cousine72;

String article[];

int chord;

char curChar;
boolean next = false;
boolean showChord = false;

int dingDing;

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
  
  // easy and hard buttons
  // Button easyButt = new Button(width/2, height-45, "EASY\nMODE");
  
}

void draw() {
  // Specify charLength
  int charLength = 14;
  
  // specify current line and current character
  String curLine = article[lineNo];
  if (article.length > lineNo+1) {
    line2 = article[lineNo+1];
  } else {
    line2 = "";
  }
  if (article.length > lineNo+2) {
    line3 = article[lineNo+2];
  } else {
    line3 = "";
  }
  
  int charIndex = floor((rectLocation.x-50)/charLength);
  try {
    curChar = curLine.charAt(charIndex);
  }
  catch (Exception err) {
    err.printStackTrace();
    curChar = '\n';
  }
  String curCharString = str(curChar);
  
  // background
  background(255);
  
  // chord specification
  try {
    chord = chords.getInt(curCharString);
  }
  catch (Exception err) {
    err.printStackTrace();
    chord = 16;
  }
  String chord_bin = binary(chord, 10);
  
  if (showChord) {
    dingDing = frameCount + int(frameRate*3);
  }
  
  if (showChord || frameCount <= dingDing) {
    
    // masking rectangle
    fill(255);
    rectMode(CORNER);
    noStroke();
    rect(0, 0, width, hands.height);
  
    // hands image
    image(hands, (width-hands.width)/2, 0);
    
    // fingertip letters
    String tipLetters[] = {"a", "e", "i", "n", "SH", "SP", "o", "r", "s", "t"};
    fill(255);
    noStroke();
    textFont(cousine, 24);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < 10; i++) {
      text(tipLetters[i], fingertips[i].x, fingertips[i].y);
    }
    
    // fingertip dots
    for (int i = 0; i < 10; i++) {
      if (chord_bin.charAt(i) == '1') {
        ellipseMode(CENTER);
        noStroke();
        fill(255,0,0,100);
        ellipse(fingertips[i].x, fingertips[i].y, 50, 50);
      }
    }
    
    // display current letter
    noStroke();
    fill(0);
    textFont(cousine72, 72);
    textAlign(CENTER, TOP);
    text(curChar, width/2, 100);
    
    showChord = false;
    
  } else {
    
    // current line of text
    String lineThusFar = curLine.substring(0, charIndex);
    
    fill(0);
    textFont(cousine, 24);
    textAlign(LEFT, TOP);
    text(lineThusFar, 50, 500);
    
    // previous lines
    int j = lineNo-1;
    for (int i=0; i<lineNo; i++) {
      text(article[j], 50, 500-30*(i+1));
      j--;
    }
    
    // draw cursor
    if (floor(frameCount/2) % 20 >= 0 && floor(frameCount/2) % 20 < 15) {     
      noStroke();
      fill(191);
      rectMode(CORNER);
      rect(rectLocation.x, 500, charLength, 20);
    }
    
  }
  
  // border below hands image
  noStroke();
  rectMode(CORNER);
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
  
  // increment rectangle
  if (next && !newLine) {
    PVector increment = new PVector(charLength, 0);
    rectLocation.add(increment);
    next = false;
  }
  
  // carriage return
  if (newLine) {
    rectLocation.x = 50;
    rectLocation.y = height-200;
    newLine = false;
    lineNo++;
    if (lineNo >= article.length) exit();
  }
  
}

void keyPressed() {
  if (key == char(curChar) & key != '\n') next = true;
  if (key == '\n') newLine = true;
  if (key == '`') showChord = true;
}
