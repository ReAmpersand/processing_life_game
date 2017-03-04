int cellsize = 10;
int rowcell;
int columncell;
int neighbor_state;
int row;
int column;

int[][] current_cellstate;
int[][] next_cellstate;
int[][] inital_cellstate;
int[][] default_cellstate;


void setup(){
  frameRate(10);
  size(500, 500);
  background(255);

  //cellstate initialize
    //load inital state
  String[] stuff1;
  
  if((stuff1= loadStrings("inital_state.csv")) == null){
    println("error:cant load inital_state.csv");
    exit();
  }
  inital_cellstate = new int[stuff1.length][];
  current_cellstate = new int[stuff1.length][];
  for(int i=0; i<stuff1.length;i++){
    inital_cellstate[i] = int(split(stuff1[i],','));
  }

  println((rowcell = inital_cellstate.length) + " total rows in table");
  println((columncell = inital_cellstate[0].length) + " total columns in table");
  for(int i = 0; i < rowcell; i++){
    current_cellstate[i] = new int[inital_cellstate[i].length];
    System.arraycopy(inital_cellstate[i], 0, current_cellstate[i], 0, inital_cellstate[i].length);
  }
  
    //load default state
  String[] stuff2;
  
  if((stuff2= loadStrings("default_state.csv")) == null){
    println("error:cant load default_state.csv");
    exit();
  }
  default_cellstate = new int[stuff2.length][];
  next_cellstate = new int[stuff2.length][];
  for(int i=0; i<stuff2.length;i++){
    default_cellstate[i] = int(split(stuff2[i],','));
  }
  for(int i = 0; i < rowcell; i++){
    next_cellstate[i] = new int[default_cellstate[i].length];
    System.arraycopy(default_cellstate[i], 0, next_cellstate[i], 0, default_cellstate[i].length);
  }

  
    //size check
  int xsize = columncell * cellsize;
  int ysize = rowcell * cellsize;
  if(xsize != width || ysize != height){
    println("error:size is incorrect");
    exit();
  }

}


/*-----rule: 23/3-----*/
void draw(){
  //reset
  noStroke();
  fill(255);
  rect(0, 0, width, height);

  //mainloop
  for(row = 0; row < rowcell; row++){
    for(column = 0; column < columncell; column++){
      
      //cell draw
      if(current_cellstate[row][column] == 1){
        //brack
        fill(0);
      }else if(current_cellstate[row][column] == 0){
        //white
        fill(255);
      }else{
        println("error");
        exit();
      }
      rect(column*cellsize, row*cellsize, cellsize, cellsize);

      //get neighborcell state
      neighbor_state = 0;
      if(row != 0           && column != 0              && current_cellstate[row-1][column-1] == 1) neighbor_state++; //D1
      if(row != 0                                       && current_cellstate[row-1][column  ] == 1) neighbor_state++; //D2
      if(row != 0           && column != columncell - 1 && current_cellstate[row-1][column+1] == 1) neighbor_state++; //D3
      if(                      column != 0              && current_cellstate[row  ][column-1] == 1) neighbor_state++; //D4
      if(                      column != columncell - 1 && current_cellstate[row  ][column+1] == 1) neighbor_state++; //D5
      if(row != rowcell - 1 && column != 0              && current_cellstate[row+1][column-1] == 1) neighbor_state++; //D6
      if(row != rowcell - 1                             && current_cellstate[row+1][column  ] == 1) neighbor_state++; //D7
      if(row != rowcell - 1 && column != columncell - 1 && current_cellstate[row+1][column+1] == 1) neighbor_state++; //D8
      /*----------------------------------------------------------------------------------------.
      |                                                                                         |
      |  D1 D2 D3                                                                               |
      |  D4 D0 D5                                                                               |
      |  D6 D7 D8                                                                               |
      |                                                                                         |
      |                                                                                         |
      |  D1: (row-1, column-1)    D2: (row-1, column  )    D3: (row-1, column+1)                |
      |  D4: (row  , column-1)    D0: (row  , column  )    D5: (row  , column+1)                |
      |  D6: (row+1, column-1)    D7: (row+1, column  )    D8: (row+1, column+1)                |
      |                                                                                         |
      |                                                                                         |
      |  row==0                 -> D1,D2,D3 X                                                   |
      |  row==rowcell-1         -> D6,D7,D8 X                                                   |
      |  column==0              -> D1,D4,D6 X                                                   |
      |  column==columncell-1   -> D3,D5,D8 X                                                   |
      |                                                                                         |
      `----------------------------------------------------------------------------------------*/

      //decision nextstate

      if(neighbor_state == 3){
        next_cellstate[row][column] = 1;
      }else if(neighbor_state == 2 && current_cellstate[row][column] == 1){
        next_cellstate[row][column] = 1;
      }else{
        next_cellstate[row][column] = 0;
      }
    }
  }
  
  for(int i = 0; i < rowcell; i++){
    current_cellstate[i] = new int[next_cellstate[i].length];
    System.arraycopy(next_cellstate[i], 0, current_cellstate[i], 0, next_cellstate[i].length);
  }
  for(int i = 0; i < rowcell; i++){
    next_cellstate[i] = new int[default_cellstate[i].length];
    System.arraycopy(default_cellstate[i], 0, next_cellstate[i], 0, default_cellstate[i].length);
  }

}