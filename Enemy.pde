
class Enemy {
  PVector pos;
  int targetWaypoint;
  ArrayList<PVector> waypoints;
  float speed;
  int health;
  int maxHealth;
  int size;
  int type;
  int bounty;
  boolean reachedEnd;
  color enemyColor;
  float animationOffset;
  GameManager game;
  
  Enemy(ArrayList<PVector> waypoints, int type, int wave) {
    this.waypoints = waypoints;
    this.pos = new PVector(waypoints.get(0).x, waypoints.get(0).y);
    this.targetWaypoint = 1;
    this.type = type;
    this.animationOffset = random(TWO_PI);
    this.game = null;
    
    switch(type) {
      case 0:
        speed = 2.2+wave/50;
        maxHealth = 30 + wave*2;
        size = 22;
        bounty = 15;
        enemyColor = color(200, 50, 50);
        break;
      case 1:
        speed = 3.8+(wave/50);
        maxHealth = 15 + wave/2;
        size = 18;
        bounty = 20;
        enemyColor = color(200, 150, 50);
        break;
      case 2:
        speed = 1.2+wave/50;
        maxHealth = 80 + wave * 2;
        size = 30;
        bounty = 40;
        enemyColor = color(100, 50, 150);
        break;
      default:
        speed = 3.0+wave/50;
        maxHealth = 20 + wave*2;
        size = 20;
        bounty = 25;
        enemyColor = color(50, 150, 200);
        break;
    }
    
    this.health = maxHealth;
    this.reachedEnd = false;
  }
  
  void setGame(GameManager gm) {
    this.game = gm;
  }
  
  void update() {
    if (reachedEnd) return;
    
    PVector target = waypoints.get(targetWaypoint);
    PVector dir = PVector.sub(target, pos);
    float distToTarget = dir.mag();
    
    if (distToTarget < speed) {
      pos.set(target);
      targetWaypoint++;
      if (targetWaypoint >= waypoints.size()) {
        reachedEnd = true;
      }
    } else {
      dir.normalize();
      pos.add(PVector.mult(dir, speed));
    }
    
    animationOffset += 0.1;
  }
  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    if (type == 3) {
      rotate(sin(animationOffset) * 0.2);
    }
    
    fill(enemyColor);
    noStroke();
    ellipse(0, 0, size, size);
    
    fill(255);
    ellipse(-size/4, -size/5, size/4, size/4);
    ellipse(size/4, -size/5, size/4, size/4);
    fill(0);
    ellipse(-size/4 + 2, -size/5, size/8, size/8);
    ellipse(size/4 + 2, -size/5, size/8, size/8);
    
    switch(type) {
      case 1:
        stroke(255, 200, 0);
        strokeWeight(2);
        line(0, -size/3, size/4, 0);
        line(size/4, 0, 0, size/3);
        break;
      case 2:
        fill(80, 80, 120);
        noStroke();
        rect(-size/2, -size/3, size, size/4, 3);
        break;
      case 3:
        fill(100, 180, 220, 150);
        ellipse(-size/2, 0, size/2, size/3);
        ellipse(size/2, 0, size/2, size/3);
        break;
    }
    
    float healthPercent = (float)health / maxHealth;
    fill(100, 0, 0);
    rect(-size/1.5, -size/1.2, size * 1.2, 5);
    fill(0, 200, 0);
    rect(-size/1.5, -size/1.2, size * 1.2 * healthPercent, 5);
    
    popMatrix();
  }
  
  void takeDamage(int dmg) {
    health -= dmg;
  }
}
