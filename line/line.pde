/*
* Force Fields
* Andrin Rehmann, 2019
* andrinrehmann.com
*/

ArrayList <P> points = new ArrayList<P>();

float[] rs = new float[10];

// Particle settings
static final int num = 9000;
static final int circleRadius = 250;
static final int pointSize = 1;
static final float invDamping = 0.993;
static final float invDeathProb = 0.998;

// Initial velocity settings
static final float initialNoiseStrength = 5;
static final float initialNoiseScale = 0.01;


void setup()
{
  smooth();
  size(1080,1080);
  background(0);
  noStroke();
  
  // Initialize random values, changing constants here can have interesting results
  rs[0] = 40 + random(40);
  rs[1] = 40 + random(40);
  rs[2] = 10 + random(20);
  rs[3] = 10 + random(20);
  rs[4] = 40 + random(40);
  rs[5] = 40 + random(40);
  rs[6] = 3 + random(10);
  rs[7] = 3 + random(10);
  rs[8] = 3 + random(40);
  rs[9] = 20 + random(40);
  
  // Initialize particles:
  for (int i = 0; i<num; i++) {
    
    // Position in circle
    double x = (float)width*i/num;
    double y = height/2;

    points.add(
      new P(new V(x,y),
      new V(
        initialNoiseStrength *(noise((float)x*initialNoiseScale)-0.5),
        initialNoiseStrength *(noise((float)x*initialNoiseScale+0.243421)-0.5)
      ),
      new C(0,122,255))
    );
  }
}

void draw()
{
  //background(0);
  for (int i = 0; i<points.size(); i++){
    // update particle
   points.get(i).update();
   
   // Randomly remove particles
   if (random(1) > invDeathProb)
     points.remove(i);
   
  }
}

// Save current image, press any key to do so
void keyPressed() 
{
   saveFrame("Line-######.png");
}

// Particle class
class P{
  V pos;
  V speed;
  C clr;
  
  P(V pos, V speed, C clr){
    this.pos = pos;
    this.speed = speed;
    this.clr = clr;
  }
  
  void update(){
    // Update color
    this.clr.r += 0.1;
    this.clr.g -= 0.2;
    this.clr.b -= 0.15;
    
    // Apply damping
    this.speed.mulS(invDamping);
    
    // Apply functions:
    this.speed.y += 0.003 * ( sin(this.pos.x()/rs[0]) + cos(this.pos.y()/rs[2]+rs[4]) + sin(this.pos.x()/rs[6] + rs[8]) );
    this.speed.x += 0.003 * ( cos(this.pos.y()/rs[1]) + sin(this.pos.x()/rs[3]+rs[5]) + sin(this.pos.y()/rs[7] + rs[9]) );
    
    // Uncomment this for outwards/inwards motion (Make negative for inward)
    /*this.speed.x += 0.00001 * (this.pos.x - width/2);
    this.speed.y += 0.00001 * (this.pos.y - height/2);*/
    
    // Update Position
    this.pos.add(speed);
    
    // Draw particle
    fill(clr.get());
    ellipse(this.pos.x(), this.pos.y(), pointSize,pointSize);
  }
}

// Color class
class C{
  float r,g,b;
  C(float r, float g, float b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  color get(){
    return color(r,g,b);
  }
}

// Vector class
class V{
  double x,y;
  V(double x, double y){
    this.x = x;
    this.y = y;
  }
  void add(V other){
    this.x += other.x;
    this.y += other.y;
  }
  
  void mulS(double s){
    this.x *= s;
    this.y *= s;
  }
  
  float x(){
    return (float) this.x;
  }
  
  float y(){
    return (float) this.y;
  }
}