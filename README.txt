Welcome to Ocamlry! 
******************************************************************************
****************************Compiling and Running ***************************
******************************************************************************

To compile Ocamly run:
  cs3110 compile -l str,graphics controller.ml

To run and Play Ocamlry run:
  cs3110 run controller.ml

This will open up a new Ocamlry window and you will be able to start playing

*****************************************************************************
*************************Game Instructions **********************************
*****************************************************************************
  The objective of this game is to strategically capture the opposing players
units and building while defending your own.  For backup, the player is able 
to buy units from buildings that he/she currently owns.

Ocamlry features 3 types of units, they are as follows:
  Infrantry - represented by a triangle (weakest, able to capture buildings)
  Ocamlry   - represented by a square
  Tank      - represented by a circle (strongest unit in game)


On the players turn, he/she will be able to run the following instruction 
  
  move x1,y1 x2,y2 
    -This command will move a unit located at position (x1,y2) to position (x2,y2)
    -Trying to move a unit that is not your will not work
    -Trying to move a unit more spaces than it can move will also result in an invalid command

  attack x1,y1 x2,y2
    -Use this command when you wish to attack a unit at position (x2,y2) with 
     a unit at position (x1,y1) 
    -Note that a unit may only attack a unit that is (north,south,east,west) 
     of it
    -Note that you may not attack your own units 
  
  buy [unit_type] [building_location]
    -Given that the player has enought money typing, this will buy a unit of 
      type (infantry, tank, ocamlry) from the building at location [loc].  
  Capture x,y
    -To capture the enemys buildings, use this command.  Only an infantry unit 
     (triangle) may capture a building.  
    -Capturing you own building will result in an invalid command
  end
    -To end one's turn call end, after that, the other player will be able 
     to move his units
  Surrender
    -Command to end the game, displays a game over screen with the final score
     and winner
