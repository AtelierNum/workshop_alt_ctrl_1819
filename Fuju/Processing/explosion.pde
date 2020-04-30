//Ci dessous le code créant l'explosion de particules lorsque le poisson eclate

class Shard {
  float x, y;    // position
  float dx, dy;  // velocity
  float r;       // radius
  float dr;      // rate of change of radius
  float gravity; // force of gravity

  boolean visible;
  
  float a;
  float ra;

  Shard() {
    reset();
  }

  void reset() {
    a = random(TWO_PI);
    ra = random(width/50);
    dx = cos(a) * ra;
    dy = sin(a) * ra;
    r = random(10.0, 15.0);    // values to get different
    dr = random(-0.5, 0.0);   // kinds of explosions
    gravity = random(0.6, 1.2);
    visible = true;
  }

  void render() {
    if (visible) {
      ellipse(x, y, 2 * r, 2 * r);
    }
  }

  void update() {
    x += dx;
    y += dy;
    r += dr;

    dy += gravity;

    if (r < 1) {   // when the shard gets too small, make it disappear
      visible = false;
    }
  }
} // class Shard
/////////////////////////////////////////////////////////////////////////

class Explosion {
  ArrayList<Shard> shards;

  Explosion(int numParticles, float x, float y) {
    shards = new ArrayList<Shard>();
    for (int i = 0; i < numParticles; ++i) {
      Shard s = new Shard();
      s.x = x;
      s.y = y;
      shards.add(s);
    }
  }

  void render() {
    for (Shard s : shards) {
      s.render();
    }
  }

  void update() {
    for (Shard s : shards) {
      s.update();
    }
  }
} // class Explosion
