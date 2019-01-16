pragma solidity 0.5.2;


contract TicTacToe
{
   uint8 stepCounter ;
   bool public  isReady;
   address public activeUser;
   address public player1; // 1 = o
   address public player2; // 2 = x
   uint8[][] public board;
   int8 public winner = -1;

   constructor() public {
         isReady = true;
         stepCounter = 0;
         initArray();
   }

   modifier onlyActiveUser() {
       require( msg.sender == activeUser );
       _;
   }

   function initArray() internal  {
       board = new uint8[][](3);
       for (uint8 i=0; i < 3; i++) {
           uint8[] memory temp = new uint8[](3);
           for(uint8 j = 0; j < 3; j++){
                   temp[j]=0;
               }
           board[i] = temp;
       }
   }

   function setUser() public{

       require(
           player1 == address(0) ||
           player2 == address(0)
       );

       if(player1 == address(0) ){
           player1 = msg.sender;
       }else if(player2 == address(0)){
           player2 = msg.sender;
           activeUser = player2;
           isReady = false;
           for(uint8 i = 0; i < 2; i++ ){
               for(uint8 j = 0; j < 2; j++ ){
                   board[i][j] = 0;
               }
           }
       }

   }
   function drow(uint8 col, uint8 row) onlyActiveUser  public {
       require( row < 3  && col < 3 );
       require( board[col][row] == 0 );
       stepCounter = stepCounter + 1;

       if(msg.sender == player1 ){
           board[col][row] = 1;
           activeUser = player2;

       }else if(msg.sender == player2) {
            board[col][row] = 2;
            activeUser = player1;
       }

       if(!checkBoard() ){
           checkWinner();
           reset();
       }
   }

   function reset() internal{
       player1 = address(0);
       player2 = address(0);
       isReady = true;
       stepCounter = 0;

   }
   function checkWinner() internal{

   //[(0,0),(0,1),(0,2)]
   //[(1,0),(1,1),(1,2)]
   //[(2,0),(2,1),(2,2)]
           if(
               board[1][1] ==  board[0][1]  &&  board[1][1] ==  board[2][1] ||
               board[1][1] ==  board[0][0]  &&  board[1][1] ==  board[2][2] ||
               board[1][1] ==  board[0][2]  &&  board[1][1] ==  board[2][0] ||
               board[1][1] ==  board[1][0]  &&  board[1][1] ==  board[1][2] )
               {
               winner =  int8(board[1][1]);
            }else if(
                board[0][1] ==  board[0][0]  &&  board[0][1] ==  board[0][2] ||
                board[1][0] ==  board[0][0]  &&  board[1][0] ==  board[2][0]
                ){
                 winner =  int8(board[0][0]);
            }else if(
               board[2][1] ==  board[2][0]  &&  board[2][1] ==  board[2][2] ||
               board[1][2] ==  board[0][2]  &&  board[1][2] ==  board[2][2]){
                    winner =  int8(board[2][2]);
            }else{
                winner = 0;
            }



   }

   function checkBoard() internal view returns(bool){

       for(uint8 i = 0; i < 2; i++ ){
           for(uint8 j = 0; j < 2; j++ ){
              if( board[i][j] == 0) {
                  return true;
              }
           }
       }

       return false;
   }

}