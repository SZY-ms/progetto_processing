
class Menu {
  boolean active;
  int selectedOption;
  String[] options;
  float titleY;
  float time;
  boolean showingHelp;
  
  Menu() {
    active = true;
    selectedOption = 0;
    // Traduzione opzioni menu
    options = new String[]{"INIZIA GIOCO", "COME GIOCARE", "ESCI"};
    titleY = height / 3;
    time = 0;
    showingHelp = false;
  }
  
  void display() {
    if (showingHelp) {
      showInstructions();
      return;
    }
    
    // Sfondo sfumato
    for (int i = 0; i < height; i++) {
        float inter = map(i, 0, height, 0, 1);
        float r = lerp(20, 5, inter);
        float g = lerp(30, 10, inter);
        float b = lerp(60, 30, inter);
        stroke(r, g, b);
        line(0, i, width, i);
    }
    
    // Effetto stelle
    drawStars();
    
    // Titolo
    textAlign(CENTER, CENTER);
    float floatingY = titleY + sin(time) * 5;
    
    fill(0, 150);
    textSize(58);
    text("TOWER DEFENSE", width/2 + 3, floatingY + 3);
    
    for (int i = 0; i < 5; i++) {
      float alpha = map(i, 0, 5, 100, 255);
      fill(100 + i*30, 150 + i*20, 255, alpha);
      textSize(56 - i);
      text("TOWER DEFENSE", width/2, floatingY - i);
    }
    
    fill(200, 220, 255);
    textSize(20);
    text("Edizione Premium", width/2, floatingY + 50);
    
    // Opzioni del menu
    int startY = height / 2 + 40;
    for (int i = 0; i < options.length; i++) {
      float y = startY + i * 60;
      
      if (i == selectedOption) {
        fill(255, 255, 100);
        textSize(36);
        text("> " + options[i] + " <", width/2, y);
      } else {
        fill(150, 180, 220);
        textSize(28);
        text(options[i], width/2, y);
      }
    }
    
    // Istruzioni di controllo rapide
    fill(150, 150, 200, 150);
    textSize(13);
    text("Usa ↑ ↓ per selezionare    INVIO per confermare", width/2, height - 40);
    
    time += 0.03f;
  }
  
  void drawStars() {
    randomSeed(0);
    for (int i = 0; i < 100; i++) {
      float x = (i * 131) % width;
      float y = (i * 253) % height;
      float brightness = (sin(time + i) + 1) * 100;
      stroke(255, 255, 255, brightness);
      point(x, y);
    }
  }
  
  void showInstructions() {
    fill(0, 200);
    rect(0, 0, width, height);
    
    fill(20, 30, 50, 240);
    rect(width/2 - 300, height/2 - 200, 600, 400, 15);
    
    fill(255, 200, 100);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("COME GIOCARE", width/2, height/2 - 160);
    
    fill(200, 220, 255);
    textSize(14);
    textAlign(LEFT, CENTER);
    
    // Traduzione dei suggerimenti e controlli
    String[] tips = {
      "1. Premi [1-4] o clicca il menu in basso per scegliere la torre",
      "2. Clicca sulla griglia per costruire (il costo varia per tipo)",
      "3. Le torri attaccano i nemici nel raggio d'azione in automatico",
      "4. Ogni tipo di torre ha punti di forza diversi",
      "5. Premi [SPAZIO] per l'abilità speciale (danno a tutto schermo)",
      "6. Ogni ondata diventa più difficile con più nemici",
      "7. I nemici volanti seguono percorsi diversi",
      "8. Premi [R] per ricominciare, [ESC] per il menu"
    };
    
    for (int i = 0; i < tips.length; i++) {
      text(tips[i], width/2 - 270, height/2 - 110 + i * 28);
    }
    
    fill(255, 200, 100);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Premi un tasto per tornare indietro", width/2, height/2 + 170);
    
    textAlign(LEFT, TOP);
  }
  
  void keyPressed() {
    if (showingHelp) {
      showingHelp = false;
      return;
    }
    
    if (keyCode == UP) {
      selectedOption--;
      if (selectedOption < 0) selectedOption = options.length - 1;
    }
    else if (keyCode == DOWN) {
      selectedOption++;
      if (selectedOption >= options.length) selectedOption = 0;
    }
    else if (keyCode == ENTER || keyCode == RETURN) {
      selectOption();
    }
  }
  
  void selectOption() {
    switch(selectedOption) {
      case 0: active = false; break; // Inizia Gioco
      case 1: showingHelp = true; break; // Istruzioni
      case 2: exit(); break; // Esci
    }
  }
  
  void mousePressed() {
    if (showingHelp) showingHelp = false;
  }
}
