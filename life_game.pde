int cellsize = 10;
int rowcell;
int columncell;

/*
int[][] current_cellstate = new int[xcell][ycell];
int[][] next_cellstate = new int[xcell][ycell];
int[][] Inital_cellstate = new int [xcell][ycell];
*/
Table current_cellstate;
Table next_cellstate;
Table inital_cellstate;
Table default_cellstate;

void setup(){
  frameRate(4);
  size(500, 500);
  background(255);
  
  //cellstate Initialize
  if((inital_cellstate = loadTable("data/inital_state.csv", "csv")) == null){
    println("error:cant load table");
    exit();
  }
  println((rowcell = inital_cellstate.getRowCount()) + " total rows in table"); 
  println((columncell = inital_cellstate.getColumnCount()) + " total columns in table");
  current_cellstate = inital_cellstate;
  if((default_cellstate = loadTable("data/default.csv", "csv")) == null){
    println("error:cant load table");
    exit();
  }
  next_cellstate = default_cellstate;
  int xsize = columncell * cellsize;
  int ysize = rowcell * cellsize;
  if(xsize != width || ysize != height){
    println("error:size is incorrect");
    exit();
  }
}
//rule: 23/3
void draw(){
  //reset
  noStroke();
  fill(255);
  rect(0, 0, width, height);
  next_cellstate = default_cellstate;

  //mainloop
  for(int row = 0; row < rowcell; row++){
    for(int column = 0; column < columncell; column++){
      
      //cell draw
      if(current_cellstate.getInt(row, column) == 1){
        //brack
        fill(0);
      }else{
        //white
        fill(255);
      }
      quad(column*cellsize, row*cellsize, (column+1)*cellsize, row*cellsize, (column+1)*cellsize, (row+1)*cellsize, column*cellsize, (row+1)*cellsize);
      
      //get neighborcell state
      int neighbor_state = 0;
      if(row != 0           && column != 0              && current_cellstate.getInt(row - 1, column - 1) != 0) neighbor_state++;
      if(                      column != 0              && current_cellstate.getInt(row    , column - 1) != 0) neighbor_state++;
      if(row != rowcell - 1 && column != 0              && current_cellstate.getInt(row + 1, column - 1) != 0) neighbor_state++;
      if(row != 0                                       && current_cellstate.getInt(row - 1, column    ) != 0) neighbor_state++;
      if(row != rowcell - 1                             && current_cellstate.getInt(row + 1, column    ) != 0) neighbor_state++;
      if(row != 0           && column != columncell - 1 && current_cellstate.getInt(row - 1, column + 1) != 0) neighbor_state++;
      if(                      column != columncell - 1 && current_cellstate.getInt(row    , column + 1) != 0) neighbor_state++;
      if(row != rowcell - 1 && column != columncell - 1 && current_cellstate.getInt(row + 1, column + 1) != 0) neighbor_state++;
      
      //decision nextstate
      if(current_cellstate.getInt(row, column) == 0){
        switch(neighbor_state){
          case 3  : 
                   next_cellstate.setInt(row, column, 1);
                   break;
          default : 
                   break;
        
        }
      }else if(current_cellstate.getInt(row, column) == 1){
        switch(neighbor_state){
          case 2  :
          case 3  : 
                   next_cellstate.setInt(row, column, 1);
                   break;
          default :
                   next_cellstate.setInt(row, column, 0);
                   break;
        }
      }
    }
  }
  
  current_cellstate = next_cellstate;
}