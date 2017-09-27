 //<>//
String qbf = "The quick brown fox jumped over the lazy dog.";
boolean showgridlines = true;

ArrayList<Box> boxes = new ArrayList<Box>();

long timeStopLast=0;
static int mx;
static int my;

void setup() {
  size(800, 600);
  frameRate(15);
  PFont mono;
  //mono=loadFont("c:/windows/fonts/cour.ttf");
  mono=createFont("Courier New Bold", 12);
  textFont( mono );
  //box = new Box("Box-1",100,200,100,200,qbf);
  boxes.add( new Box("Box-1", 100, 200, 100, 200, qbf, true) );
}

void draw() {
  mx=mouseX;
  my=mouseY;
  background(200);

  if (showgridlines) {
    stroke(190);
    for (int x=0; x<width; x+=20) {
      line(x, 0, x, height);
    }
    for (int y=0; y<height; y+=20) {
      line(0, y, width, y);
    }
    stroke(0);
  }
  fill(100);

  int i=0;
  for (Box box : boxes) {
    box.draw(i);
    i++;
  }

  handleTime();
}

void handleTime() {
  if (mouseX==pmouseX && mouseY==pmouseY) {
    // the time since the mouse last moved
    // to fire off background events?
  } else {
    timeStopLast=millis();
  }
  long timeStill=millis()-timeStopLast;
  fill(90);
  text(""+timeStill, 22, height-22);
}


void mouseClicked() {
  String newBoxName = "Box-"+(boxes.size()+1);
  if (mouseOverBoxCount(boxes)==0) {
    boxes.add(new Box(newBoxName, (int)random(100, width-200), (int)random(100, height-200), (int)random(100, 400), (int)random(100, 400), qbf, false));
  } else {
    //
  }
}

//void mouseDragged() {
//  //dragging=true;
//  println("drag start");
//}
//void mouseReleased() {
//  //dragging=false;
//}

class Box {
  final int x; 
  final int y; 
  final int w; 
  final int h;
  final String tx;
  final String name;
  final boolean active;
  Box(String nm, int xx, int yy, int ww, int hh, String txt, boolean up) {
    name=nm;
    x=xx;
    y=yy;
    w=ww;
    h=hh;
    tx=txt;
    active=up;
  }
  void draw(int index) {

    // shadow
    if (active) {
      fill(0);
      rect(x+10, y+10, w, h);
      fill(100);
    }

    // bg
    if ( (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h) ) {
      fill(150);
    } else {
      fill(100);
    }
    rect(x, y, w, h);

    // banner
    rect(x, y, w, 20);

    // scaler
    rect(x+w-20, y+h-20, 20, 20);

    // draw text
    fill(250, 220, 10);
    text(name, x, y, w, 20);
    text(tx, x, y+20, w, h);

    // banner mouse
    boolean dragging = false;
    if ( (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+20) ) {
      //cursor(MOVE);
      if (mousePressed && (mouseButton == LEFT)) {
        dragging=true;
      } else {
        dragging=false;
      }
    }
    if (dragging) {
      cursor(MOVE);
    }
    // scaler mouse
    else if ( (mouseX > x+w-20 && mouseX < x+w) && (mouseY > y+h-20 && mouseY < y+h) ) {
      cursor(HAND);
    } else {
      cursor(ARROW);
    }

    // move when dragging
    if (dragging) {
      int offx = mouseX-x;
      int poffx = mouseX-pmouseX;
      int offy = mouseY-y;
      int poffy = mouseY-pmouseY;
      if (poffx==0 && poffy==0) {
        Box box = boxes.get(index);
        box = new Box(box.name, box.x, box.y, box.w, box.h, box.tx, true);
        boxes.set(index, box);
        return;
      }
      println("drag box:"+name);
      int newx=(x)+poffx;
      int newy=(y)+poffy;
      println(" mouseX:"+mouseX+" offx:"+offx+" x:"+x+" mouseY:"+mouseY+" offy:"+offy+" y:"+y);
      println(" poffx:"+poffx+" poffy:"+poffy);
      println(" newx:"+newx+" newy:"+newy);
      Box box = boxes.get(index);
      box = new Box(box.name, newx, newy, box.w, box.h, box.tx, true);
      boxes.set(index, box);
    }
  }
}

static int mouseOverBoxCount( ArrayList<Box> boxes ) {
  int count=0;
  for (Box box : boxes) {
    if ((mx > box.x && mx < box.x+box.w) && (my > box.y && my < box.y+box.h)) {
      count++;
    }
  }
  return count;
}