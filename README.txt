Welcome to Ocamlry!
******************************************************************************
****************************Compiling and Running ***************************
******************************************************************************

To compile Ocamlry run:
  cs3110 compile -l str,graphics controller.ml

To run and Play Ocamlry run:
  cs3110 run controller.ml

This will open up a new Ocamlry window and you will be able to start playing

*****************************************************************************
*************************Game Instructions **********************************
*****************************************************************************
  The objective of this game is to strategically capture the opposing player's
units and building while defending your own.  For backup, the player is able
to buy units from buildings that he/she currently owns.

Ocamlry features 3 types of units, they are as follows:
  Infantry  - represented by a triangle.  Infantry units are the only ones 
              allowed to capture the enemies building.
              This unit cost 200, has 100hp and a max_movement of 3
  Ocamlry   - represented by a square
              It costs 500 to buy this unit and has 150 hp with a maximum 
              movemenet of 5 tiles per turn
  Tank      - represented by a circle.
              Strongest unit in the game.  This unit costs 1000, has 
              hp of 250 ,and has max movemement of 4 tiles per turn


On the player's turn, he/she will be able to run the following instruction

  move x1,y1 x2,y2
    -This command will move a unit located at position (x1,y2) to position
     (x2,y2)
    -Trying to move a unit that is not yours will not work
    -Trying to move a unit more spaces than it can move will also result in an
     invalid command

  attack x1,y1 x2,y2
    -Use this command when you wish to attack a unit at position (x2,y2) with
     a unit at position (x1,y1)
    -Note that a unit may only attack a unit that is (north,south,east,west)
     of it
    -Note that you may not attack your own units

  buy [unit_type] [building_location]
    -Given that the player has enough money, this will buy a unit of
      type (infantry, tank, ocamlry) from the building at location [loc].

  Capture x,y
    -To capture the enemy's buildings, use this command.  Only an infantry unit
     (triangle) may capture a building. Capturing takes two turns.
    -Capturing you own building will result in an invalid command

  end
    -To end one's turn call end, after that, the other player will be able
     to move his/her units

  Surrender
    -Command to end the game, displays a game over screen with the final score
     and winner
