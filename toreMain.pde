
import java.util.*;
import processing.sound.*;

// ========== 全局静态音效变量 ==========
static SoundFile soundVita;
static SoundFile soundBuild;
static SoundFile soundShoot;
static SoundFile soundKill;
static SoundFile soundExplosion;
static SoundFile soundCoin;
static SoundFile soundUpgrade;
static SoundFile soundBoss;
static SoundFile bgm;
static SoundFile SgameOver;
boolean bgmStarted = false;

GameManager game;
Menu menu;

void setup() {
  size(1000, 800, JAVA2D);
  surface.setResizable(false);
  
  smooth(8);
  
  // ========== 加载音效 ==========
  try {
    soundVita = new SoundFile(this,"delVita.wav");
    soundBuild = new SoundFile(this, "build.wav");
    soundShoot = new SoundFile(this, "shoot.wav");
    soundKill = new SoundFile(this, "kill.wav");
    soundExplosion = new SoundFile(this, "explosion.wav");
    soundCoin = new SoundFile(this, "coin.wav");
    soundUpgrade = new SoundFile(this, "upgrade.wav");
    soundBoss = new SoundFile(this, "boss.wav");
    SgameOver = new SoundFile(this, "gameOver.wav");
    bgm = new SoundFile(this, "bgm.wav");
    bgm.amp(0.01);
    println("音效加载成功！");
  } catch (Exception e) {
    println("音效加载失败，游戏将无声音效");
    println("提示：请将 wav 文件放在 data 文件夹中");
  }
  
  PFont font = createFont("Arial", 20, true);
  textFont(font);
  frameRate(60);
  
  game = new GameManager();
  menu = new Menu();
}

void draw() {
  if (menu.active) {
    menu.display();
  } else {
    if (!game.paused) {
      if (!bgm.isPlaying()) bgm.loop();
      game.update();
    }
    game.display();
    if (game.paused) {
      if (bgm.isPlaying()) bgm.pause();
      game.displayPauseMenu();
    }
  }
  if (!bgmStarted) {
    bgm.loop();   // 无限循环
    bgmStarted = true;
  }
}

void mousePressed() {
  if (!menu.active) {
    if (!game.paused) {
      game.mousePressed();
    }
  } else {
    menu.mousePressed();
  }
}

void mouseMoved() {
  if (!menu.active && !game.paused) {
    game.mouseMoved();
  }
}

void keyPressed() {
  if (menu.active) {
    menu.keyPressed();
  } else {
    if (keyCode == ESC) {
      key = 0;
      game.paused = !game.paused;
    } else if (!game.paused) {
      game.keyPressed();
    }
  }
}
