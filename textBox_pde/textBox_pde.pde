
String qbf = "The quick brown fox jumped over the lazy dog.";
boolean showgridlines = true;

ArrayList<Box> boxes = new ArrayList<Box>();

// support dragging
boolean dragging = false;
long timeStill=0;
long timeStopLast=0;

void setup(){
  size(800,600);
  frameRate(15);
  PFont mono;
  //mono=loadFont("c:/windows/fonts/cour.ttf");
  mono=createFont("Courier New Bold", 12);
  textFont( mono );
  //box = new Box("Box-1",100,200,100,200,qbf);
  boxes.add( new Box("Box-1",100,200,100,200,qbf) );
}

void draw(){
  background(200);
  //cursor(ARROW);
  if(showgridlines){
    stroke(190);
    for(int x=0; x<width; x+=20){
      line(x,0,x,height);
    }
    for(int y=0; y<height; y+=20){
      line(0,y,width,y);
    }
    stroke(0);
  }
  fill(100);
  int i=0;
  for(Box box:boxes){
    box.draw(i);
    i++;
  }
  handleTime();
}

void handleTime(){
  if(mouseX==pmouseX && mouseY==pmouseY){
    //timeStill=millis()-timeStopLast;
  }else{
    //timeStill=0;//millis();
    timeStopLast=millis();
  }
  timeStill=millis()-timeStopLast;
  fill(90);
  text(""+timeStill,22,height-22);
}


void mouseClicked() {
  String newBoxName = "Box-"+(boxes.size()+1);
  boxes.add(new Box(newBoxName,(int)random(100,width-200),(int)random(100,height-200),(int)random(100,400),(int)random(100,400),qbf));
}

void mouseDragged() {
  //dragging=true;
  println("drag start");
}
void mouseReleased(){
  dragging=false;
}

class Box{
  final int x; int y; int w; int h;
  final String tx;
  final String name;
  Box(String nm, int xx, int yy, int ww, int hh,String txt){
    name=nm;x=xx;y=yy;w=ww;h=hh;tx=txt;
  }
  void draw(int index){
    // shadow
    fill(0);
    rect(x+10,y+10,w,h);
    fill(100);
    
    // bg
    rect(x,y,w,h);
        
    // banner
    rect(x,y,w,20);
    
    // scaler
    rect(x+w-20,y+h-20,20,20);
        
    // draw text
    fill(250,220,10);
    text(name,x,y,w,20);
    text(tx,x,y+20,w,h);
    
    // banner mouse
    if( (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+20) ){
      //cursor(MOVE);
      if (mousePressed && (mouseButton == LEFT)) {
        dragging=true;
      }
    }
    else if(dragging){
      cursor(MOVE);
    }
    // scaler mouse
    else if( (mouseX > x+w-20 && mouseX < x+w) && (mouseY > y+h-20 && mouseY < y+h) ){
      cursor(HAND);
    }
    else{
      cursor(ARROW);
    }
    
    // move when dragging
    if(dragging){
      println("drag box:"+name);
      Box box = boxes.get(index);
      box = new Box(box.name,mouseX-box.w/2,mouseY,box.w,box.h,box.tx);
    }
  }
}