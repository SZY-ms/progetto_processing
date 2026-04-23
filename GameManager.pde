
class GameManager {
  // ==================== ENTITÀ DI GIOCO ====================
  boolean bombaAttiva;           // Se la bomba abilità è attiva
  float bombaX, bombaY;          // Posizione della bomba
  float bombaVelocita;           // Velocità di caduta della bomba
  boolean bombaEsplosa;          // Se la bomba è già esplosa
  int bombaTimer;                // Timer per l'animazione dell'esplosione
  ArrayList<Enemy> nemici;       // Lista dei nemici attivi
  ArrayList<Tower> torri;        // Lista delle torri costruite
  ArrayList<Bullet> proiettili;  // Lista dei proiettili in volo
  ArrayList<Effect> effetti;     // Lista degli effetti particellari
  ArrayList<DropItem> dropItems; // Lista degli oggetti raccoglibili
  ParticleSystem particelle;     // Sistema particelle avanzato
  
  // ==================== SISTEMA PERCORSI ====================
  ArrayList<ArrayList<PVector>> tuttiIPercorsi;  // Tutti i percorsi disponibili
  ArrayList<PVector> percorsoCorrente;           // Percorso attualmente usato
  int percorsoSelezionato;                       // Indice del percorso corrente
  boolean percorsoFisso;                         // Se usare sempre lo stesso percorso
  
  // ==================== STATO DI GIOCO ====================
  int ondata;                    // Ondata corrente
  int punteggio;                 // Punteggio totale del giocatore
  int vite;                      // Vite rimanenti
  int soldi;                     // Soldi disponibili
  boolean gameOver;              // Stato di game over
  boolean modalitaTorre;         // Modalità di costruzione torri attiva
  boolean paused;                // Gioco in pausa
  int nemiciDaGenerare;          // Nemici ancora da spawnare nell'ondata
  int timerGenerazione;          // Timer tra uno spawn e l'altro
  int timerOndata;               // Timer prima dell'inizio della prossima ondata
  PVector cellaMouse;            // Cella della griglia sotto il mouse
  
  // ==================== BOSS ====================
  boolean isBossWave;            // Se l'ondata corrente è un boss wave
  int bossType;                  // Tipo di boss (0-3)
  
  // ==================== TORRI ====================
  int tipoTorreSelezionato;      // Tipo di torre selezionata (0-3)
  int[] costoTorre = {100, 150, 200, 250};  // Costi delle torri
  String[] nomiTorri = {"Torre Base", "Torre Veloce", "Torre Cecchino", "Torre Esplosiva"};
  
  // ==================== ABILITÀ ====================
  int puntiAbilita;              // Punti abilità disponibili
  int ricaricaAbilita;           // Timer di ricarica dell'abilità
  
  // ==================== STATISTICHE ====================
  int uccisioniTotali;           // Totale nemici uccisi
  int ondataMassima;             // Ondata massima raggiunta
  
  // ==================== MESSAGGI UI ====================
  String messaggioPopup;         // Messaggio da mostrare a schermo
  int timerMessaggio;            // Durata del messaggio popup
  boolean gameOverSoundPlayed;   // Flag per evitare loop del suono game over
  
  // ==================== COSTRUTTORE ====================
  GameManager() {
    // Inizializzazione delle liste
    nemici = new ArrayList<Enemy>();
    torri = new ArrayList<Tower>();
    proiettili = new ArrayList<Bullet>();
    effetti = new ArrayList<Effect>();
    dropItems = new ArrayList<DropItem>();
    tuttiIPercorsi = new ArrayList<ArrayList<PVector>>();
    particelle = new ParticleSystem();
    
    // Setup percorsi
    inizializzaPercorsi();
    selezionaPercorsoCasuale();
    percorsoFisso = true;
    
    // Inizializzazione bomba
    bombaAttiva = false;
    bombaX = width/2;
    bombaY = -50;
    bombaVelocita = 5;
    bombaEsplosa = false;
    bombaTimer = 0;
    
    // Valori iniziali di gioco
    ondata = 1;
    punteggio = 0;
    vite = 20;
    soldi = 300;
    gameOver = false;
    modalitaTorre = false;
    paused = false;
    isBossWave = false;
    bossType = 0;
    tipoTorreSelezionato = 0;
    nemiciDaGenerare = 0;
    timerGenerazione = 0;
    timerOndata = 180;           // 3 secondi di pausa tra ondate (60 FPS)
    puntiAbilita = 0;
    ricaricaAbilita = 0;
    uccisioniTotali = 0;
    ondataMassima = 0;
    cellaMouse = new PVector(0, 0);
    messaggioPopup = "";
    timerMessaggio = 0;
    gameOverSoundPlayed = false;
    
    println("Gioco inizializzato!");
  }
  
  // ==================== INIZIALIZZAZIONE PERCORSI ====================
  void inizializzaPercorsi() {
    // Percorso 1: Semplice a L
    ArrayList<PVector> percorso1 = new ArrayList<PVector>();
    percorso1.add(new PVector(50, 150)); 
    percorso1.add(new PVector(200, 150));
    percorso1.add(new PVector(200, 450)); 
    percorso1.add(new PVector(550, 450));
    percorso1.add(new PVector(550, 250)); 
    percorso1.add(new PVector(850, 250));
    tuttiIPercorsi.add(percorso1);
    
    // Percorso 2: A zig-zag
    ArrayList<PVector> percorso2 = new ArrayList<PVector>();
    percorso2.add(new PVector(50, 250)); 
    percorso2.add(new PVector(250, 250));
    percorso2.add(new PVector(250, 400)); 
    percorso2.add(new PVector(500, 400));
    percorso2.add(new PVector(500, 200)); 
    percorso2.add(new PVector(850, 200));
    tuttiIPercorsi.add(percorso2);
    
    // Percorso 3: A S
    ArrayList<PVector> percorso3 = new ArrayList<PVector>();
    percorso3.add(new PVector(50, 400)); 
    percorso3.add(new PVector(200, 400));
    percorso3.add(new PVector(200, 200)); 
    percorso3.add(new PVector(550, 200));
    percorso3.add(new PVector(550, 450)); 
    percorso3.add(new PVector(850, 450));
    tuttiIPercorsi.add(percorso3);
    
    // Percorso 4: Complesso con più curve
    ArrayList<PVector> percorso4 = new ArrayList<PVector>();
    percorso4.add(new PVector(50, 100)); 
    percorso4.add(new PVector(180, 100));
    percorso4.add(new PVector(180, 350)); 
    percorso4.add(new PVector(380, 350));
    percorso4.add(new PVector(380, 150)); 
    percorso4.add(new PVector(580, 150));
    percorso4.add(new PVector(580, 500)); 
    percorso4.add(new PVector(850, 500));
    tuttiIPercorsi.add(percorso4);
    
    // Percorso 5: A serpentina
    ArrayList<PVector> percorso5 = new ArrayList<PVector>();
    percorso5.add(new PVector(50, 500)); 
    percorso5.add(new PVector(220, 500));
    percorso5.add(new PVector(220, 280)); 
    percorso5.add(new PVector(420, 280));
    percorso5.add(new PVector(420, 420)); 
    percorso5.add(new PVector(650, 420));
    percorso5.add(new PVector(650, 180)); 
    percorso5.add(new PVector(850, 180));
    tuttiIPercorsi.add(percorso5);
    
    // Percorso 6: A U rovesciata
    ArrayList<PVector> percorso6 = new ArrayList<PVector>();
    percorso6.add(new PVector(50, 300)); 
    percorso6.add(new PVector(150, 300));
    percorso6.add(new PVector(150, 200)); 
    percorso6.add(new PVector(300, 200));
    percorso6.add(new PVector(300, 450)); 
    percorso6.add(new PVector(500, 450));
    percorso6.add(new PVector(500, 300)); 
    percorso6.add(new PVector(850, 300));
    tuttiIPercorsi.add(percorso6);
    
    // Percorso 7: Lungo e tortuoso
    ArrayList<PVector> percorso7 = new ArrayList<PVector>();
    percorso7.add(new PVector(50, 80)); 
    percorso7.add(new PVector(300, 80));
    percorso7.add(new PVector(300, 350)); 
    percorso7.add(new PVector(450, 350));
    percorso7.add(new PVector(450, 150)); 
    percorso7.add(new PVector(700, 150));
    percorso7.add(new PVector(700, 500)); 
    percorso7.add(new PVector(850, 500));
    tuttiIPercorsi.add(percorso7);
  }
  
  // Seleziona un percorso casuale tra quelli disponibili
  void selezionaPercorsoCasuale() {
    percorsoSelezionato = floor(random(tuttiIPercorsi.size()));
    percorsoCorrente = tuttiIPercorsi.get(percorsoSelezionato);
  }
  
  // Mostra un messaggio a schermo per una certa durata
  void mostraMessaggio(String msg, int durata) {
    if (gameOver) return;
    messaggioPopup = msg;
    timerMessaggio = durata;
  }
  
  // ==================== UPDATE PRINCIPALE ====================
  void update() {
    if (gameOver) return;
    
    aggiornaBomba();        // Aggiorna animazione bomba
    aggiornaOndata();       // Gestisce ondate e spawn nemici
    aggiornaNemici();       // Aggiorna posizione e stato nemici
    aggiornaTorri();        // Aggiorna targeting e attacco torri
    aggiornaProiettili();   // Muove proiettili e gestisce collisioni
    aggiornaEffetti();      // Aggiorna effetti particellari
    aggiornaDropItems();    // Aggiorna oggetti a terra
    aggiornaAbilita();      // Aggiorna timer abilità
    controllaGameOver();    // Verifica se il gioco è finito
    
    if (timerMessaggio > 0) timerMessaggio--;
  }
  
  // ==================== GESTIONE ONDATE ====================
  void aggiornaOndata() {
    // Pausa tra ondate
    if (timerOndata > 0) {
      timerOndata--;
      if (timerOndata == 0 && !gameOver) iniziaOndata();
      return;
    }
    
    // Spawn dei nemici
    if (nemiciDaGenerare > 0 && timerGenerazione <= 0) {
      if (isBossWave && nemici.size() == 0) {
        // Spawn del boss
        int bossWaveNum = (ondata / 5);
        bossType = bossWaveNum % 4;
        Boss boss = new Boss(this, percorsoCorrente, bossType, ondata);
        nemici.add(boss);
        nemiciDaGenerare--;
        if (toreMain.soundBoss != null) toreMain.soundBoss.play();
      } else if (!isBossWave) {
        // Spawn nemico normale
        int tipoNemico = getTipoNemicoCasuale();
        Enemy enemy = new Enemy(percorsoCorrente, tipoNemico, ondata);
        enemy.setGame(this);
        nemici.add(enemy);
        nemiciDaGenerare--;
      }
      timerGenerazione = 25;  // Delay tra spawn (circa 0.4 secondi)
    }
    
    if (timerGenerazione > 0) timerGenerazione--;
    
    // Ondata completata
    if (nemiciDaGenerare == 0 && nemici.size() == 0 && timerOndata == 0) {
      completaOndata();
    }
  }
  
  // Determina il tipo di nemico in base all'ondata
  int getTipoNemicoCasuale() {
    float r = random(100);
    if (ondata < 3) return 0;           // Solo nemici base all'inizio
    if (r < 50) return 0;               // 50% nemico base
    if (r < 75) return 1;               // 25% nemico veloce
    if (r < 90) return 2;               // 15% nemico resistente
    return 3;                            // 10% nemico veloce+resistente
  }
  
  // Inizia una nuova ondata
  void iniziaOndata() {
    isBossWave = (ondata % 5 == 0);
    
    if (isBossWave) {
      nemiciDaGenerare = 1;
      mostraMessaggio("⚠️ BOSS IN ARRIVO! ⚠️", 90);
    } else {
      // Il numero di nemici aumenta con l'ondata
      nemiciDaGenerare = 5 + ondata * 2;
      mostraMessaggio("ONDATA " + ondata + " INIZIATA!", 60);
    }
    timerOndata = 0;
  }
  
  // Completa l'ondata corrente e prepara la successiva
  void completaOndata() {
    ondata++;
    timerOndata = 180;                  // 3 secondi di pausa
    soldi += 100 + ondata * 10;         // Ricompensa in base all'ondata
    puntiAbilita++;                     // Punto abilità per ondata completata
    
    if (ondata > ondataMassima) ondataMassima = ondata;
    
    // Effetto particellare di completamento
    for (int i = 0; i < 30; i++) {
      effetti.add(new Effect(width/2, height/2, random(360), random(2, 8), color(255, 200, 0)));
    }
    mostraMessaggio("ONDATA COMPLETATA! +" + (100 + ondata * 10) + " $", 90);
  }
  
  // ==================== GESTIONE NEMICI ====================
  void aggiornaNemici() {
    for (int i = nemici.size()-1; i >= 0; i--) {
      Enemy e = nemici.get(i);
      e.update();
      
      // Nemico arrivato alla fine del percorso
      if (e.reachedEnd) {
        nemici.remove(i);

        if (e instanceof Boss) {
          vite -= 5;                      // Boss toglie 5 vite
          toreMain.soundVita.play();
          mostraMessaggio("-5 VITA! BOSS SCAPPATO!", 60);
        } else {
          vite--;                         // Nemico normale toglie 1 vita
          toreMain.soundVita.play();
          mostraMessaggio("-1 VITA!", 30);
        }
        aggiungiEffetto(e.pos.x, e.pos.y, color(200, 0, 0));

      // Nemico ucciso
      } else if (e.health <= 0) {
        nemici.remove(i);
        punteggio += 10;
        uccisioniTotali++;
        
        if (e instanceof Boss) {
          mostraMessaggio("BOSS SCONFITTO! +$" + e.bounty, 90);
          soldi += e.bounty;
          if (toreMain.soundKill != null) toreMain.soundKill.play();

          // Il boss droppa più oggetti
          for (int j = 0; j < 10; j++) {
            generaDrop(e.pos.x, e.pos.y, 3);
          }
        } else {
          if (toreMain.soundKill != null) toreMain.soundKill.play();
        }
        
        aggiungiEffetto(e.pos.x, e.pos.y, color(0, 200, 0));
        generaDrop(e.pos.x, e.pos.y, e.type);
      }
    }
  }
  
  // Genera oggetti drop alla morte di un nemico
  void generaDrop(float x, float y, int tipoNemico) {
    int numeroDrop = 1;
    if (tipoNemico == 1) numeroDrop = 2;   // Nemici veloci droppano di più
    if (tipoNemico == 2) numeroDrop = 3;   // Nemici resistenti droppano ancora di più
    if (tipoNemico == 3) numeroDrop = 2;
    
    for (int i = 0; i < numeroDrop; i++) {
      int tipoDrop;
      float r = random(100);
      
      // Probabilità drop: 55% soldi, 20% soldi extra, 15% vita, 10% abilità
      if (r < 55) {
        tipoDrop = 0;      // Soldi normali
      } else if (r < 75) {
        tipoDrop = 1;      // Soldi extra
      } else if (r < 90) {
        tipoDrop = 2;      // Vita
      } else {
        tipoDrop = 3;      // Punto abilità
      }
      
      dropItems.add(new DropItem(x + random(-10, 10), y + random(-10, 10), tipoDrop));
    }
  }
  
  // ==================== GESTIONE DROP ITEMS ====================
  void aggiornaDropItems() {
    for (int i = dropItems.size()-1; i >= 0; i--) {
      DropItem d = dropItems.get(i);
      d.update();
      
      // Raccolta automatica quando il mouse si avvicina
      float distMouse = dist(mouseX, mouseY, d.x, d.y);
      if (distMouse < 25 && !d.raccolto) {
        raccogliDrop(d);
        d.raccolto = true;
        dropItems.remove(i);
      }
      else if (d.isMorto()) {
        dropItems.remove(i);
      }
    }
  }
  
  // Gestisce la raccolta di un drop item
  void raccogliDrop(DropItem d) {
    switch(d.tipo) {
      case 0:  // Soldi normali
        soldi += d.valore;
        mostraMessaggio("+$" + d.valore, 40);
        if (toreMain.soundCoin != null) toreMain.soundCoin.play();
        break;
      case 1:  // Soldi extra
        soldi += d.valore;
        mostraMessaggio("+$" + d.valore + "!", 40);
        if (toreMain.soundCoin != null) toreMain.soundCoin.play();
        break;
      case 2:  // Vita (max 20)
        if (vite < 20) {
          vite += d.valore;
          if (vite > 20) vite = 20;
          mostraMessaggio("+" + d.valore + " VITA!", 40);
        } else {
          soldi += 25;
          mostraMessaggio("VITA PIENA! +25$", 40);
        }
        break;
      case 3:  // Punto abilità
        puntiAbilita += d.valore;
        mostraMessaggio("+1 ABILITÀ!", 40);
        break;
    }
    
    // Effetto particellare di raccolta
    for (int i = 0; i < 5; i++) {
      effetti.add(new Effect(d.x, d.y, random(360), random(1, 3), color(255, 255, 100)));
    }
  }
  
  // ==================== GESTIONE TORRI ====================
  void aggiornaTorri() {
    for (Tower t : torri) {
      t.update(this, nemici, proiettili, particelle);
    }
  }
  
  void aggiornaProiettili() {
    for (int i = proiettili.size()-1; i >= 0; i--) {
      if (!proiettili.get(i).update(nemici)) {
        proiettili.remove(i);
      }
    }
  }
  
  void aggiornaEffetti() {
    for (int i = effetti.size()-1; i >= 0; i--) {
      if (!effetti.get(i).update()) {
        effetti.remove(i);
      }
    }
  }
  
  void aggiornaAbilita() {
    if (ricaricaAbilita > 0) ricaricaAbilita--;
  }
  
  // Aggiunge un effetto particellare
  void aggiungiEffetto(float x, float y, color c) {
    for (int i = 0; i < 8; i++) {
      effetti.add(new Effect(x, y, random(360), random(1, 5), c));
    }
  }
  
  // ==================== GAME OVER ====================
  void controllaGameOver() {
    if (vite <= 0) {
      gameOver = true;
      vite = 0;
    }
  }
  
  // ==================== ABILITÀ BOMBA ====================
  void usaAbilita() {
    if (puntiAbilita > 0 && ricaricaAbilita == 0 && !bombaAttiva && !paused) {
      puntiAbilita--;
      ricaricaAbilita = 180;          // 3 secondi di ricarica
      
      bombaAttiva = true;
      bombaX = width/2;
      bombaY = -50;
      bombaVelocita = 5;
      bombaEsplosa = false;
      bombaTimer = 0;
      
      mostraMessaggio("BOMBA IN ARRIVO!", 60);
    }
  }
  
  // Aggiorna animazione e logica della bomba
  void aggiornaBomba() {
    if (!bombaAttiva) return;
    
    if (!bombaEsplosa) {
      // Caduta della bomba
      bombaY += bombaVelocita;
      
      if (bombaY >= height/2) {
        bombaEsplosa = true;
        bombaTimer = 30;

        // Suono esplosione
        if (toreMain.soundExplosion != null) {
          toreMain.soundExplosion.stop();
          toreMain.soundExplosion.amp(0.9);
          toreMain.soundExplosion.play();
        }
        
        // Danno a tutti i nemici
        int dannoBomba = 50;
        int nemiciUccisi = 0;
        
        for (int i = nemici.size()-1; i >= 0; i--) {
          Enemy e = nemici.get(i);
          e.takeDamage(dannoBomba);
          
          if (particelle != null) {
            particelle.addBurst(e.pos.x, e.pos.y, 5, color(255, 100, 0));
          }
          
          if (e.health <= 0) {
            nemiciUccisi++;
            if (particelle != null) {
              particelle.addExplosion(e.pos.x, e.pos.y, color(255, 50, 0));
            }
            generaDrop(e.pos.x, e.pos.y, e.type);
          }
        }
        
        // Rimuovi nemici morti
        for (int i = nemici.size()-1; i >= 0; i--) {
          if (nemici.get(i).health <= 0) {
            nemici.remove(i);
          }
        }
        
        // Effetti esplosione
        if (particelle != null) {
          particelle.addExplosion(bombaX, bombaY, color(255, 80, 0));
          particelle.addExplosion(bombaX, bombaY, color(255, 200, 0));
        }
        
        mostraMessaggio("💣 " + dannoBomba + " DANNO!", 90);
      }

    } else {
      // Animazione esplosione
      bombaTimer--;
      if (bombaTimer <= 0) {
        bombaAttiva = false;
      }
    }
  }
  
  // ==================== GESTIONE TORRI (COSTRUZIONE/VENDITA) ====================
  void removeTowerAt(float x, float y) {
    for (int i = torri.size()-1; i >= 0; i--) {
      Tower t = torri.get(i);
      if (dist(x, y, t.x, t.y) < 30) {
        int refund = costoTorre[t.type] / 2;  // Rimborso 50%
        soldi += refund;
        torri.remove(i);
        mostraMessaggio("Torre venduta! +$" + refund, 40);
        if (toreMain.soundCoin != null) toreMain.soundCoin.play();
        break;
      }
    }
  }
  
  // ==================== UI E DISPLAY ====================
  void displayPauseMenu() {
    fill(0, 180);
    rect(0, 0, width, height);
    
    fill(255, 200, 100);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("PAUSA", width/2, height/3);
    
    fill(200, 200, 200);
    textSize(20);
    text("Gioco in pausa", width/2, height/2);
    
    fill(150, 150, 150);
    textSize(14);
    text("Premi ESC per continuare", width/2, height/2 + 50);
    text("Premi R per ricominciare", width/2, height/2 + 80);
    
    textAlign(LEFT, TOP);
  }
  
  // Display principale del gioco
  void display() {
    background(20, 25, 45);
    particelle.update();
    particelle.display();
    disegnaGriglia();
    disegnaPercorso();
    disegnaBomba();
    disegnaTorri();
    disegnaNemici();
    disegnaProiettili();
    disegnaDropItems();
    disegnaEffetti();
    disegnaUI();
    disegnaMenuTorri();
    disegnaMessaggio();
    
    if (modalitaTorre) disegnaAnteprima();
  }
  
  void disegnaGriglia() {
    stroke(40, 50, 80);
    strokeWeight(1);
    for (int x = 0; x < width; x += 40) {
      line(x, 0, x, height);
    }
    for (int y = 0; y < height; y += 40) {
      line(0, y, width, y);
    }
  }
  
  void disegnaPercorso() {
    if (percorsoCorrente == null) return;
    stroke(80, 60, 40);
    strokeWeight(25);
    noFill();
    beginShape();
    for (PVector p : percorsoCorrente) vertex(p.x, p.y);
    endShape();
    strokeWeight(1);
    
    // Punto di partenza (rosso) e arrivo (verde)
    fill(200, 50, 50);
    noStroke();
    ellipse(percorsoCorrente.get(0).x, percorsoCorrente.get(0).y, 18, 18);
    fill(50, 200, 50);
    ellipse(percorsoCorrente.get(percorsoCorrente.size()-1).x, 
            percorsoCorrente.get(percorsoCorrente.size()-1).y, 18, 18);
  }
  
  void disegnaTorri() { for (Tower t : torri) t.display(); }
  void disegnaNemici() { for (Enemy e : nemici) e.display(); }
  void disegnaProiettili() { for (Bullet b : proiettili) b.display(); }
  void disegnaDropItems() { for (DropItem d : dropItems) d.display(); }
  void disegnaEffetti() { for (Effect e : effetti) e.display(); }
  
  void disegnaBomba() {
    if (!bombaAttiva) return;
    
    pushMatrix();
    translate(bombaX, bombaY);
    
    if (!bombaEsplosa) {
      // Bomba in caduta
      fill(40, 40, 40);
      ellipse(0, 0, 20, 20);
      
      stroke(150, 100, 50);
      strokeWeight(3);
      line(0, -10, 0, -18);
      
      // Miccia accesa
      float spark = sin(frameCount * 0.5f);
      float brightness = 100 + spark * 5;
      fill(255, brightness, 0);
      noStroke();
      ellipse(0, -18, 5, 8);
      
      fill(200);
      textSize(14);
      textAlign(CENTER, CENTER);
      text("💣", 0, 2);
      
      stroke(255, 100, 0, 100);
      strokeWeight(2);
      line(0, 5, 0, 30);
    } else {
      // Esplosione
      float explosionSize = (30 - bombaTimer) * 2;
      if (explosionSize < 0) explosionSize = 0;
      
      noStroke();
      for (int i = 0; i < 3; i++) {
        float alpha = map(bombaTimer, 0, 30, 0, 200);
        fill(255, 100 + i * 50, 0, alpha - i * 50);
        ellipse(0, 0, explosionSize + i * 15, explosionSize + i * 15);
      }
      
      fill(255, 255, 200);
      ellipse(0, 0, explosionSize, explosionSize);
      
      // Raggi esplosione
      stroke(255, 100, 0, 150);
      strokeWeight(3);
      for (int i = 0; i < 8; i++) {
        float angle = radians(i * 45 + frameCount * 10);
        float x1 = cos(angle) * 20;
        float y1 = sin(angle) * 20;
        float x2 = cos(angle) * (explosionSize + 10);
        float y2 = sin(angle) * (explosionSize + 10);
        line(x1, y1, x2, y2);
      }
    }
    
    popMatrix();
  }
  
  void disegnaMessaggio() {
    if (timerMessaggio > 0 && !messaggioPopup.equals("")) {
      fill(0, 150);
      rect(width/2 - 150, height/2 - 50, 300, 40, 10);
      fill(255, 255, 100);
      textSize(20);
      textAlign(CENTER, CENTER);
      text(messaggioPopup, width/2, height/2 - 30);
      textAlign(LEFT, TOP);
    }
  }
  
  void disegnaUI() {
    // Barra superiore
    fill(0, 200);
    rect(0, 0, width, 60);
    
    fill(255);
    textSize(18);
    textAlign(LEFT, TOP);
    
    float startX = 15;
    float startY = 25;
    float spacing = 130;
    
    text("Ondata: " + ondata, startX, startY);
    text("Punteggio: " + punteggio, startX + spacing, startY);
    text("Vite: " + vite, startX + spacing * 2, startY);
    text("Soldi: $" + soldi, startX + spacing * 3, startY);
    text("Uccisioni: " + uccisioniTotali, startX + spacing * 4, startY);
    
    fill(100, 200, 255);
    textSize(14);
    text("Abilità: " + puntiAbilita + " [SPAZIO]", startX + spacing * 5.5f, startY);
    
    if (ricaricaAbilita > 0) {
      fill(255, 100, 100);
      text("Ricarica: " + (ricaricaAbilita/60 + 1), startX + spacing * 7, startY);
    }
    
    fill(200, 200, 255, 150);
    textSize(11);
    text("Percorso: " + (percorsoSelezionato + 1) + "/" + tuttiIPercorsi.size(), 
         startX, startY + 20);
    text("POTENZIA: [U] su torre | VENDI: [Click Destro]", startX + spacing * 4, startY + 20);
    
    // Timer prossima ondata
    if (timerOndata > 0 && !gameOver && nemici.size() == 0) {
      pushStyle();
      fill(255, 200, 100);
      textSize(20);
      textAlign(CENTER, CENTER);
      text("Prossima ondata: " + (timerOndata/30 + 1), width/2, 80);
      popStyle();
    }
    
    // Schermata Game Over
    if (gameOver) {
      fill(0, 200);
      rect(0, 0, width, height);
      fill(255, 0, 0);
      textSize(52);
      textAlign(CENTER, CENTER);
      text("GAME OVER", width/2, height/2 - 50);
      
      if (!gameOverSoundPlayed) {
        toreMain.SgameOver.play();
        gameOverSoundPlayed = true;
      }
      toreMain.bgm.pause(); 
      
      textSize(24);
      fill(255);
      text("Ondata raggiunta: " + ondata, width/2, height/2 + 10);
      text("Uccisioni totali: " + uccisioniTotali, width/2, height/2 + 45);
      text("Ondata massima: " + ondataMassima, width/2, height/2 + 80);
      text("Premi [R] per ricominciare", width/2, height/2 + 130);
      textAlign(LEFT, TOP);
    }
  }
  
  void disegnaMenuTorri() {
    fill(0, 180);
    rect(0, height - 80, width, 80);
    
    float menuY = height - 70;
    float buttonWidth = 140;
    float buttonHeight = 60;
    float spacing = 20;
    
    for (int i = 0; i < costoTorre.length; i++) {
      float x = spacing + i * (buttonWidth + spacing);
      
      // Torre selezionata evidenziata in verde
      if (tipoTorreSelezionato == i) {
        fill(100, 200, 100, 200);
        stroke(0, 255, 0);
      } else {
        fill(50, 50, 80, 200);
        stroke(100, 100, 150);
      }
      
      rect(x, menuY, buttonWidth, buttonHeight+5, 5);
      
      fill(255);
      textSize(12);
      textAlign(LEFT, TOP);
      text(nomiTorri[i], x + 10, menuY + 18);
      text("$" + costoTorre[i], x + 10, menuY + 38);
      textSize(10);
      text(getDescrizioneTorre(i), x + 10, menuY + 52);
    }
  }
  
  String getDescrizioneTorre(int type) {
    switch(type) {
      case 0: return "Equilibrata";
      case 1: return "Attacco veloce";
      case 2: return "Alto danno";
      case 3: return "Danno ad area";
      default: return "";
    }
  }
  
  void disegnaAnteprima() {
    int gridX = (mouseX / 40) * 40;
    int gridY = (mouseY / 40) * 40;
    
    if (gridX < 0 || gridX >= width || gridY < 0 || gridY >= height) return;
    
    boolean posizionabile = puoiPosizionareTorre(gridX + 20, gridY + 20);
    boolean abbastanzaSoldi = soldi >= costoTorre[tipoTorreSelezionato];
    
    // Colore anteprima in base allo stato
    if (posizionabile && abbastanzaSoldi) {
      fill(100, 200, 100, 150);    // Verde - posizionabile
      stroke(0, 255, 0);
    } else if (!abbastanzaSoldi) {
      fill(255, 255, 0, 150);       // Giallo - soldi insufficienti
      stroke(255, 255, 0);
    } else {
      fill(200, 100, 100, 150);     // Rosso - posizione non valida
      stroke(255, 0, 0);
    }
    
    strokeWeight(2);
    rect(gridX, gridY, 40, 40);
    strokeWeight(1);
    
    fill(255);
    textSize(9);
    textAlign(CENTER);
    if (!abbastanzaSoldi) {
      text("Servono $" + costoTorre[tipoTorreSelezionato], gridX + 20, gridY + 25);
    } else if (!posizionabile) {
      text("Posizione non valida", gridX + 20, gridY + 25);
    } else {
      text(nomiTorri[tipoTorreSelezionato], gridX + 20, gridY + 25);
    }
    textAlign(LEFT);
  }
  
  // ==================== UTILITY ====================
  boolean puoiPosizionareTorre(float x, float y) {
    // Controlla collisione con altre torri
    for (Tower t : torri) {
      if (dist(t.x, t.y, x, y) < 40) return false;
    }
    
    if (percorsoCorrente == null) return true;
    
    // Controlla distanza dal percorso (minimo 35 pixel)
    for (int i = 0; i < percorsoCorrente.size() - 1; i++) {
      PVector p1 = percorsoCorrente.get(i);
      PVector p2 = percorsoCorrente.get(i+1);
      float d = distanzaPuntoLinea(x, y, p1.x, p1.y, p2.x, p2.y);
      if (d < 35) return false;
    }
    return true;
  }
  
  // Calcola la distanza tra un punto e un segmento
  float distanzaPuntoLinea(float px, float py, float x1, float y1, float x2, float y2) {
    float A = px - x1;
    float B = py - y1;
    float C = x2 - x1;
    float D = y2 - y1;
    
    float dot = A * C + B * D;
    float len_sq = C * C + D * D;
    float param = -1;
    
    if (len_sq != 0) param = dot / len_sq;
    
    float xx, yy;
    if (param < 0) { xx = x1; yy = y1; }
    else if (param > 1) { xx = x2; yy = y2; }
    else { xx = x1 + param * C; yy = y1 + param * D; }
    
    float dx = px - xx;
    float dy = py - yy;
    return sqrt(dx*dx + dy*dy);
  }
  
  // ==================== INPUT MOUSE ====================
  void mousePressed() {
    if (gameOver) return;
    
    // Click destro = vendi torre
    if (mouseButton == RIGHT) {
      removeTowerAt(mouseX, mouseY);
      return;
    }
    
    // Selezione torre dal menu
    float menuY = height - 70;
    float buttonWidth = 140;
    float buttonHeight = 60;
    float spacing = 20;
    
    if (mouseY > menuY && mouseY < menuY + buttonHeight) {
      for (int i = 0; i < costoTorre.length; i++) {
        float x = spacing + i * (buttonWidth + spacing);
        if (mouseX > x && mouseX < x + buttonWidth) {
          tipoTorreSelezionato = i;
          modalitaTorre = true;
          return;
        }
      }
    }
    
    // Costruzione torre
    if (modalitaTorre) {
      float gridX = (mouseX / 40) * 40 + 20;
      float gridY = (mouseY / 40) * 40 + 20;
      
      if (soldi >= costoTorre[tipoTorreSelezionato] && puoiPosizionareTorre(gridX, gridY)) {
        torri.add(new Tower(gridX, gridY, tipoTorreSelezionato));
        soldi -= costoTorre[tipoTorreSelezionato];
        mostraMessaggio("Torre costruita!", 40);
        if (toreMain.soundBuild != null) toreMain.soundBuild.play();
      }
      modalitaTorre = false;
    }
  }
  
  void mouseMoved() {
    cellaMouse.set((mouseX / 40) * 40, (mouseY / 40) * 40);
  }
  
  // ==================== INPUT TASTIERA ====================
  void keyPressed() {
    if (key == 't' || key == 'T') {
      modalitaTorre = !modalitaTorre;   // Attiva/disattiva modalità costruzione
    }
    if (key == 'r' || key == 'R') {
      reset();                          // Reset del gioco
    }
    if (key == ' ') {
      usaAbilita();                     // Usa abilità bomba
    }
    if (key >= '1' && key <= '4') {
      tipoTorreSelezionato = key - '1'; // Seleziona torre con tasti 1-4
      modalitaTorre = true;
    }
    if (key == 'u' || key == 'U') {
      upgradeTorreSottoMouse();         // Potenzia torre sotto il mouse
    }
  }
  
  // Potenzia la torre sotto il cursore
  void upgradeTorreSottoMouse() {
    Tower torreSelezionata = null;
    float distMinima = 30;
    
    for (Tower t : torri) {
      float d = dist(mouseX, mouseY, t.x, t.y);
      if (d < distMinima) {
        distMinima = d;
        torreSelezionata = t;
      }
    }
    
    if (torreSelezionata != null) {
      int costoUpgrade = torreSelezionata.getUpgradeCost();
      if (soldi >= costoUpgrade && torreSelezionata.level < 5) {
        soldi -= costoUpgrade;
        torreSelezionata.upgrade();
        mostraMessaggio("Torre livello " + torreSelezionata.level + "!", 60);
        if (toreMain.soundUpgrade != null) toreMain.soundUpgrade.play();
      } else if (torreSelezionata.level >= 5) {
        mostraMessaggio("Torre al massimo livello!", 40);
      } else {
        mostraMessaggio("Servono $" + costoUpgrade + " per upgrade!", 40);
      }
    } else {
      mostraMessaggio("Clicca su una torre per fare upgrade", 40);
    }
  }
  
  // Reset completo del gioco
  void reset() {
    nemici.clear();
    torri.clear();
    proiettili.clear();
    effetti.clear();
    dropItems.clear();
    ondata = 1;
    punteggio = 0;
    vite = 20;
    soldi = 300;
    gameOverSoundPlayed = false;
    gameOver = false;
    modalitaTorre = false;
    paused = false;
    isBossWave = false;
    nemiciDaGenerare = 0;
    timerGenerazione = 0;
    timerOndata = 180;
    puntiAbilita = 0;
    ricaricaAbilita = 0;
    uccisioniTotali = 0;
    selezionaPercorsoCasuale();
    mostraMessaggio("GIOCO RESETTATO!", 60);
  }
}
