 //<>//
String qbf = "The quick brown fox jumped over the lazy dog.";
boolean showgridlines = true;

ArrayList<Box> boxes = new ArrayList<Box>();

long timeStopLast=0;
boolean dragging;
boolean mouseFired=false; // only true the frame of mouseUp

void setup() {
  size(800, 600);
  frameRate(15);
  PFont mono;
  mono=createFont("Courier New Bold", 12);
  textFont( mono );
  
  // first box
  boxes.add( new Box("Box-1", 100, 200, 100, 200, qbf, true) );
}

void draw() {
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

  //after boxes are drawn set mouseFired off
  mouseFired=false;
  
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
  // fires after mouseReleased
  //println("mouseClicked");
  if (mouseOverBoxCount(boxes, mouseX, mouseY)==0) {
    String newBoxName = "Box-"+(boxes.size()+1);
    println("making new box:"+newBoxName);
    boxes.add(new Box(newBoxName, (int)random(100, width-200), (int)random(100, height-200), (int)random(100, 400), (int)random(100, 400), qbf, false));
  } else {
    //
  }
}

void mouseDragged() {
  if ( !dragging ) {
    dragging=true;
    println("drag start");
  }
}
void mouseReleased() {
  // fires before mouseClicked
  //println("mouseReleased");
  if (dragging) {
    dragging=false;
    println("drag end");
  }else{
    println("mouseReleased !dragging");
    // drop all boxes? no
  }
  
  mouseFired=true;
}


class Box {
  final int x; 
  final int y; 
  final int w; 
  final int h;
  final String tx;
  final String name;
  final boolean active;
  Box(){tx="";name="";x=y=w=h=0;active=false;}
  
  //Box(this.name, this.x, this.y, this.w, this.h, this.text, this.active);
  Box(String nm, int xx, int yy, int ww, int hh, String txt, boolean up) {
    name=nm;
    x=xx;
    y=yy;
    w=ww;
    h=hh;
    tx=txt;
    active=up;
  }
  int draw(int index) {

    //if( mousePressed && (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h)){
    //println("draw("+index+") mouseFired:"+mouseFired);
    if( mouseFired && (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h)){
      
      //boxes = boxFlipActiveMouseOver(boxes,mouseX,mouseY);
      println("dropped/pickedUp box:"+index);
      if(this.active){
        //println("active, so drop");
        Box thisInactive = new Box(this.name, this.x, this.y, this.w, this.h, this.tx, !this.active);
        boxes.set( index, thisInactive );
        
      }else{
        //println("inactive, so pickUp");
        Box thisInactive = new Box(this.name, this.x, this.y, this.w, this.h, this.tx, !this.active);
        boxes.set( index, thisInactive );
      }
    }
    
    // shadow
    if (this.active) {
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
    if (dragging) {
      cursor(MOVE);
    } else if ( (mouseX > x+w-20 && mouseX < x+w) && (mouseY > y+h-20 && mouseY < y+h) ) {
      // scaler mouse
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
    
    // TODO:
    // what is the top most moused over box?
    // only flip that one

    // drag box
    //println("dragging:"+dragging+" box:"+this.name+" active:"+this.active);
    if( dragging && this.active ){
      //&& (mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h)){
      //println("dragging:"+dragging+" box:"+this.name+" active:"+this.active);
      int poffx = mouseX-pmouseX;
      int poffy = mouseY-pmouseY;
      int newx=(this.x)+poffx;
      int newy=(this.y)+poffy;
      //println(" poffx:"+poffx+" poffy:"+poffy+" newx:"+newx+" newy:"+newy);
      if (poffx!=0 && poffy!=0) {
        Box newBox = boxes.get(index);
        newBox = new Box(this.name, newx, newy, this.w, this.h, this.tx, this.active);
        boxes.set(index, newBox);
        return index;
      }
    }
    return index;
  }

  ArrayList<Box> boxFlipActiveMouseOver( ArrayList<Box> boxes, int mx, int my ) {
    if( mouseOverBoxCount(boxes, mx, my)==0 ){
      println("mouse over no boxes");
      return boxes;
    }
    
    ArrayList<Box> newboxes = new ArrayList<Box>(boxes.size());
    for (int i=0; i<boxes.size(); i++) {
      Box box = boxes.get(i);
      if ( (mx > x && mx < x+w) && (my > y && my < y+h) ) {
        box = new Box(box.name, box.x, box.y, box.w, box.h, box.tx, !box.active);
      }
      newboxes.add(box);
    }
    return newboxes;
  }
}


static int mouseOverBoxCount( ArrayList<Box> boxes, int mx, int my ) {
  int count=0;
  for (Box box : boxes) {
    if ((mx > box.x && mx < box.x+box.w) && (my > box.y && my < box.y+box.h)) {
      count++;
    }
  }
  return count;
}

static ArrayList<Box> getMouseOverBoxes( ArrayList<Box> boxes, int mx, int my ) {
  ArrayList<Box> selected = new ArrayList<Box>();
  for (Box box : boxes) {
    if ((mx > box.x && mx < box.x+box.w) && (my > box.y && my < box.y+box.h)) {
      selected.add(box);
    }
  }
  return selected;
}

public ArrayList<Box> boxDeactivateAll( ArrayList<Box> boxes ) {
  for (int i=0; i<boxes.size(); i++) {
    Box box = boxes.get(i);
    Box newbox = new Box(box.name, box.x, box.y, box.w, box.h, box.tx, false);
    boxes.set(i, newbox);
  }
  return boxes;
}