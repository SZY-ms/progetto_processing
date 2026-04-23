
class Effect {
  float x, y;
  float vx, vy;
  float life;
  color c;
  float size;
  
  Effect(float x, float y, float angle, float speed, color c) {
    this.x = x;
    this.y = y;
    this.vx = cos(radians(angle)) * speed;
    this.vy = sin(radians(angle)) * speed;
    this.life = 255;
    this.c = c;
    this.size = random(2, 5);
  }
  
  boolean update() {
    x += vx;
    y += vy;
    life -= 5;
    vy += 0.2;
    return life > 0;
  }
  
  void display() {
    fill(red(c), green(c), blue(c), life);
    noStroke();
    ellipse(x, y, size, size);
  }
}
