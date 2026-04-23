class ParticleSystem {
  ArrayList<Effect> particles;
  
  ParticleSystem() {
    particles = new ArrayList<Effect>();
  }
  
  void update() {
    for (int i = particles.size()-1; i >= 0; i--) {
      if (!particles.get(i).update()) {
        particles.remove(i);
      }
    }
  }
  
  void display() {
    for (Effect e : particles) {
      e.display();
    }
  }
  
  void addExplosion(float x, float y, color c) {
    for (int i = 0; i < 20; i++) {
      float angle = random(360);
      float speed = random(2, 8);
      particles.add(new Effect(x, y, angle, speed, c));
    }
  }
  
  void addBurst(float x, float y, int count, color c) {
    for (int i = 0; i < count; i++) {
      float angle = random(360);
      float speed = random(1, 4);
      particles.add(new Effect(x, y, angle, speed, c));
    }
  }
  
  void addBeam(float x1, float y1, float x2, float y2, color c) {
    for (int i = 0; i < 10; i++) {
      float t = random(1);
      float px = lerp(x1, x2, t);
      float py = lerp(y1, y2, t);
      particles.add(new Effect(px, py, random(360), random(1, 3), c));
    }
  }
}
