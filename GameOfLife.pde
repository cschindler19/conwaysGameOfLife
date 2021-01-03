int dimension = 100;
int size;
int gameSpeed = 10;
boolean paused = false;
boolean[][] list;
boolean[][] new_list;

void setup() {
  
  size(1000, 1000);
  frameRate(gameSpeed);
  
  size = width / dimension;
  
  rndBoard();
  
}

void draw() {
  background(0);
  frameRate(gameSpeed);
  
  // Display Stats
  fill(255);
  textSize(20);
  int maxHeight = height - 100;
  text("Game Speed:\t" + gameSpeed, 10, maxHeight + 20);
  text("Game Paused:\t" + paused, 10, maxHeight + 40);
  
  
  // Display the Game
  stroke(paused ? 255 : 0, 0, 0);
  for(int x = 0; x < width; x+= size) {
    for(int y = 0; y < height-100; y+= size) {
      if(list[x/size][y/size]) {
        fill(00, 255, 00);
      } else {
        fill(50);        
      }
      rect(x, y, size, size);
    }
  }
  
  if(!paused) {
    new_list = new boolean[dimension][dimension];
    for(int x = 0; x < dimension; x++) {
      for(int y = 0; y < dimension; y++) {
    
        nextGeneration(x, y);
        
      }
    }
    
    list = new_list;
  }
  
}

void nextGeneration(int _x, int _y) {
  int neighbors = 0;
  
  for(int r = -1; r <= 1; r++) {
    for(int c = -1; c <=1; c++) {
       try { 
         // Dont check the middle cell
         if(r == 0 && c == 0) {
           continue;
         }
         // Total number of neighbors around center
         if(list[_x + r][_y + c]) {
           neighbors++;
         }
         
       } catch(ArrayIndexOutOfBoundsException e) {
         continue;
       }
    }
  }
  

  // If the Cell is alive
  if(list[_x][_y] == true) {
    // Kill the cell if 4 or more neighbors or 1 or less
    if(neighbors >= 4 || neighbors <= 1) {
      new_list[_x][_y] = false;
    } else {
      // The Cell lives another day
      new_list[_x][_y] = true;
    }
    // If the Cell is dead
  } else if (list[_x][_y] == false) {
    // Birth new cell if exactly 3 neighbors
    if(neighbors == 3) {
      new_list[_x][_y] = true;
    }
  }

  
}

void rndBoard() {
  list = new boolean[dimension][dimension];
  for(int x = 0; x < dimension; x++) {
    for(int y = 0; y < dimension; y++) {
      list[x][y] = (int(random(0, 5)) == 0 ? true : false);
    }
  }
}

void editBoard() {
  float percX = (float)mouseX/width;
  float percY = (float)mouseY/(height);
  
  int indexX = int(dimension * percX);
  int indexY = int(dimension * percY);
  
  try {
    if(paused) {
      new_list[indexX][indexY] = !new_list[indexX][indexY];
    }
  } catch (ArrayIndexOutOfBoundsException e) {}
}

void keyPressed() {
  if (keyCode == UP && gameSpeed < 150) {
    gameSpeed += 5;
  } else if (keyCode == DOWN && gameSpeed > 5) {
    gameSpeed -= 5;
  }
  if(key == 'c') {
    list = new boolean[dimension][dimension];
    paused = true;
  }
  if(key == 'r') {
    rndBoard();
  }
  if(key == ' ') {
    paused = !paused;
  }
}

void mouseDragged() {
  editBoard();
}

void mousePressed() {
  editBoard();
}
