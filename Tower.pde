
class Tower {
  float x, y;
  int type;
  int level;
  int range;
  int cooldown;
  int reloadTime;
  int damage;
  int towerR;
  int towerG;
  int towerB;
  float angle;
  float targetAngle;
  int shootTimer;
  float shootAnim;
  
  SoundFile soundShoot;
  
  Tower(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.level = 1;
    this.angle = 0;
    this.targetAngle = 0;
    this.shootTimer = 0;
    this.shootAnim = 0;
    
    this.soundShoot = toreMain.soundShoot;
    
    setBaseStats();
    this.cooldown = 0;
  }
  
  void setBaseStats() {
    switch(type) {
      case 0:
        range = 120;
        reloadTime = 25;
        damage = 12;
        towerR = 100;
        towerG = 150;
        towerB = 200;
        break;
      case 1:
        range = 110;
        reloadTime = 12;
        damage = 8;
        towerR = 200;
        towerG = 150;
        towerB = 100;
        break;
      case 2:
        range = 220;
        reloadTime = 55;
        damage = 45;
        towerR = 150;
        towerG = 100;
        towerB = 200;
        break;
      case 3:
        range = 100;
        reloadTime = 35;
        damage = 15;
        towerR = 100;
        towerG = 200;
        towerB = 150;
        break;
      default:
        range = 100;
        reloadTime = 35;
        damage = 15;
        towerR = 100;
        towerG = 200;
        towerB = 150;
        break;
    }
    
    range += (level - 1) * 10;
    damage += (level - 1) * 5;
    if (reloadTime > 10) {
      reloadTime -= (level - 1) * 2;
    }
  }
  
  void upgrade() {
    if (level < 5) {
      level++;
      setBaseStats();
    }
  }
  
  int getUpgradeCost() {
    return 75 + (level - 1) * 25;
  }
  
  int getLevel() {
    return level;
  }
  
  void getShootColor(int[] rgb) {
    switch(type) {
      case 0:
        rgb[0] = 100; rgb[1] = 200; rgb[2] = 255;
        break;
      case 1:
        rgb[0] = 255; rgb[1] = 150; rgb[2] = 50;
        break;
      case 2:
        rgb[0] = 200; rgb[1] = 100; rgb[2] = 255;
        break;
      case 3:
        rgb[0] = 100; rgb[1] = 255; rgb[2] = 100;
        break;
      default:
        rgb[0] = 100; rgb[1] = 200; rgb[2] = 255;
        break;
    }
  }
  
  void update(GameManager game, ArrayList<Enemy> enemies, ArrayList<Bullet> bullets, ParticleSystem particles) {
    if (shootTimer > 0) {
      shootTimer--;
      shootAnim = shootTimer / 5.0f;
    } else {
      shootAnim = 0;
    }
    
    Enemy target = findTarget(enemies);
    
    if (target != null) {
      float newAngle = atan2(target.pos.y - y, target.pos.x - x);
      targetAngle = newAngle;
      
      float diff = targetAngle - angle;
      while (diff > PI) diff -= TWO_PI;
      while (diff < -PI) diff += TWO_PI;
      angle = angle + diff * 0.15f;
      
      if (cooldown <= 0) {
        int[] rgb = {0,0,0};
        getShootColor(rgb);
        Bullet bullet = new Bullet(x, y, target, damage, type, particles, angle);
        bullet.setGame(game);
        bullets.add(bullet);
        cooldown = reloadTime;
        shootTimer = 8;
        
        if (soundShoot != null) {
          soundShoot.play();
        }
        
        float barrelEndX = x + cos(angle) * 25;
        float barrelEndY = y + sin(angle) * 25;
        int particleCount = 8;
        if (type == 2) particleCount = 15;
        if (type == 3) particleCount = 12;
        particles.addBurst(barrelEndX, barrelEndY, particleCount, color(rgb[0], rgb[1], rgb[2]));
      }
    }
    
    if (cooldown > 0) {
      cooldown--;
    }
  }
  
  Enemy findTarget(ArrayList<Enemy> enemies) {
    Enemy closest = null;
    float minDist = range;
    
    for (int i = 0; i < enemies.size(); i++) {
      Enemy e = enemies.get(i);
      float d = dist(x, y, e.pos.x, e.pos.y);
      if (d < minDist) {
        minDist = d;
        closest = e;
      }
    }
    return closest;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    float recoil = shootAnim * 4;
    
    fill(towerR, towerG, towerB);
    rect(-16, -16, 32, 32, 5);
    
    fill(255, 200, 0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("★" + level, 0, -18);
    
    fill(towerR+50, towerG+50, towerB+50);
    float pulse = 20;
    if (shootAnim > 0) pulse = 26;
    ellipse(0, 0, pulse, pulse);
    
    pushMatrix();
    rotate(angle);
    float barrelLength = 20 - recoil;
    fill(80, 80, 100);
    rect(8, -5, barrelLength, 10, 3);
    
    fill(120, 120, 140);
    rect(8 + barrelLength - 3, -6, 6, 12, 2);
    
    if (shootTimer > 0) {
      float flashSize = 12;
      if (type == 2) flashSize = 18;
      if (type == 3) flashSize = 16;
      fill(255, 200, 100, 200 - shootAnim * 25);
      ellipse(8 + barrelLength, 0, flashSize, flashSize);
      
      if (type == 2) {
        fill(200, 100, 255, 150 - shootAnim * 20);
        ellipse(8 + barrelLength, 0, flashSize + 6, flashSize + 6);
      }
      if (type == 3) {
        fill(100, 255, 100, 150 - shootAnim * 20);
        ellipse(8 + barrelLength, 0, flashSize + 4, flashSize + 4);
      }
    }
    popMatrix();
    
   
    
    popMatrix();
  }
}
