
class Boss extends Enemy {
  int bossType;
  GameManager game;
  
  Boss(GameManager gm, ArrayList<PVector> waypoints, int bossType, int wave) {
    super(waypoints, 2, wave);
    this.game = gm;
    this.bossType = bossType;
    
    switch(bossType) {
      case 0:
        speed = 1.2+wave/50;
        maxHealth = 200 + wave * 40;
        size = 45;
        bounty = 200;
        enemyColor = color(180, 50, 50);
        break;
      case 1:
        speed = 0.7+wave/50;
        maxHealth = 350 + wave * 90;
        size = 50;
        bounty = 250;
        enemyColor = color(100, 80, 60);
        break;
      case 2:
        speed = 1.1+wave/50;
        maxHealth = 150 + wave * 200;
        size = 40;
        bounty = 180;
        enemyColor = color(100, 50, 180);
        break;
      default:
        speed = 1.5+wave/30;
        maxHealth = 250 + wave * 70;
        size = 48;
        bounty = 220;
        enemyColor = color(80, 80, 100);
        break;
    }
    
    this.health = maxHealth;
  }
  
  void setGame(GameManager gm) {
    this.game = gm;
  }
  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    fill(0, 100);
    ellipse(5, 5, size + 5, size + 5);
    
    fill(enemyColor);
    noStroke();
    ellipse(0, 0, size, size);
    
    fill(255, 200, 0);
    for (int i = 0; i < 5; i++) {
      float angle = radians(i * 72 - 90);
      float x = cos(angle) * (size/2 + 5);
      float y = sin(angle) * (size/2 + 5);
      ellipse(x, y, 10, 10);
    }
    
    fill(255, 0, 0);
    ellipse(-size/4, -size/5, size/4, size/4);
    ellipse(size/4, -size/5, size/4, size/4);
    fill(255, 255, 0);
    ellipse(-size/4 + 2, -size/5, size/8, size/8);
    ellipse(size/4 + 2, -size/5, size/8, size/8);
    
    fill(255, 200, 0);
    textSize(size/2);
    textAlign(CENTER, CENTER);
    text("👑", 0, -5);
    
    float healthPercent = (float)health / maxHealth;
    fill(50, 0, 0);
    rect(-size, -size - 12, size * 2, 10);
    
    if (healthPercent > 0.6) {
      fill(255, 100, 0);
    } else if (healthPercent > 0.3) {
      fill(255, 200, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(-size, -size - 12, size * 2 * healthPercent, 10);
    
    fill(255, 200, 0);
    textSize(14);
    text(getBossName(), 0, -size - 18);
    
    popMatrix();
  }
  
  String getBossName() {
    switch(bossType) {
      case 0: return "🔥 DRAGON LORD 🔥";
      case 1: return "🪨 EARTH GOLEM 🪨";
      case 2: return "🔮 SHADOW MAGE 🔮";
      default: return "️ WAR MACHINE ️";
    }
  }
  
  void takeDamage(int dmg) {
    health -= dmg;
    
    if (game != null && game.particelle != null) {
      game.particelle.addExplosion(pos.x, pos.y, color(255, 100, 0));
    }
  }
}
