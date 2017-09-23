
String qbf = "The quick brown fox jumped over the lazy dog.";
boolean showgridlines = true;

void setup(){
  size(800,600);
  frameRate(5);
  box = new Box(100,200,100,200,qbf);
}

void draw(){
  background(200);
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
  box.draw();
}


void mouseClicked() {
  box = new Box(box.x,box.y,(int)random(100,400),(int)random(100,400),box.tx);
}



Box box;

class Box{
  final int x; int y; int w; int h;
  final String tx;
  Box(int xx, int yy, int ww, int hh,String txt){
    x=xx;y=yy;w=ww;h=hh;tx=txt;
  }
  void draw(){
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
    fill(0);
    text(tx,x,y+20,w,h);
    
  }
}