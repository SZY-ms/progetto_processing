
class DropItem {
  float x, y;
  int tipo;
  int valore;
  float vx, vy;
  float vita;
  boolean raccolto;
  
  DropItem(float x, float y, int tipo) {
    this.x = x;
    this.y = y;
    this.tipo = tipo;
    this.vx = random(-1, 1);
    this.vy = random(-2, -0.5);
    this.vita = 255;
    this.raccolto = false;
    
    switch(tipo) {
      case 0:
        valore = 10 + floor(random(5));
        break;
      case 1:
        valore = 50 + floor(random(30));
        break;
      case 2:
        valore = 1;
        break;
      case 3:
        valore = 1;
        break;
    }
  }
  
  void update() {
    vx *= 0.98;
    vy += 0.2;
    x += vx;
    y += vy;
    vita -= 3;
    
    if (y > height - 20) {
      y = height - 20;
      vy = -vy * 0.5;
    }
  }
  
  void display() {
    if (vita <= 0) return;
    
    pushMatrix();
    translate(x, y);
    
    float alpha = constrain(vita, 0, 255);
    
    switch(tipo) {
      case 0:
        fill(255, 215, 0, alpha);
        ellipse(0, 0, 12, 12);
        fill(255, 200, 0, alpha);
        ellipse(0, 0, 8, 8);
        fill(255, 180, 0, alpha);
        textSize(10);
        textAlign(CENTER, CENTER);
        text("$", 0, 0);
        break;
        
      case 1:
        fill(255, 200, 100, alpha);
        rect(-10, -8, 20, 16, 3);
        fill(255, 180, 80, alpha);
        rect(-6, -12, 12, 6, 2);
        fill(255, 220, 120, alpha);
        textSize(10);
        textAlign(CENTER, CENTER);
        text("$$", 0, 0);
        break;
        
      case 2:
        fill(255, 50, 50, alpha);
        beginShape();
        vertex(0, -6);
        bezierVertex(-6, -10, -10, -2, 0, 6);
        bezierVertex(10, -2, 6, -10, 0, -6);
        endShape();
        fill(255, 255, 255, alpha);
        textSize(9);
        textAlign(CENTER, CENTER);
        text("+" + valore, 0, 0);
        break;
        
      case 3:
        fill(255, 255, 100, alpha);
        pushMatrix();
        rotate(frameCount * 0.05);
        beginShape();
        for (int i = 0; i < 5; i++) {
          float angle = TWO_PI / 5 * i - HALF_PI;
          float x1 = cos(angle) * 8;
          float y1 = sin(angle) * 8;
          vertex(x1, y1);
          angle += TWO_PI / 10;
          float x2 = cos(angle) * 4;
          float y2 = sin(angle) * 4;
          vertex(x2, y2);
        }
        endShape(CLOSE);
        popMatrix();
        fill(255, 255, 255, alpha);
        textSize(9);
        textAlign(CENTER, CENTER);
        text("S", 0, 0);
        break;
    }
    
    popMatrix();
  }
  
  boolean isMorto() {
    return vita <= 0;
  }
}
