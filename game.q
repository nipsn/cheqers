\l util.q

/ all possible grid cells
\d .cell
empty:`$"[ ]"
checkerW:`$"[w]"
queenW:`$"[W]"
checkerB:`$"[b]"
queenB:`$"[B]"

\d .game
rW:8#(.cell.empty;.cell.checkerW)
rB:8#(.cell.checkerB;.cell.empty)
rEmpty:8#.cell.empty

grid:(enlist[rB],
      enlist[reverse rB],
      enlist[rB],
      (2#enlist rEmpty),
      enlist[rW],
      enlist[reverse rW],
      enlist[rW])

/ check if the given coordinates are valid
validCoords:{[x;y]
             (0<x<7)&
             (0<y<7)}

move:{[bw;coords;lr]
    povGrid:$[bw=`b;.util.rotateGrid grid;grid];        / rotate if bw=`b
    cxi:coords[0];                                      / vertical
    cyi:coords[1];                                      / horizontal
    if[povGrid[cxi][cyi]<>.cell.empty;                  /
        isW:(.cell.checkerW=povGrid[cxi][cyi])|         /
            (.cell.queenW  =povGrid[cxi][cyi]);         / coords point to black or white checker?
        target:$[isW;.cell.checkerW;.cell.checkerB];    / TODO: add queens to logic
        cyd:$[lr=`l;-1+cyi;1+cyi];                      / left move or right move
        cxd:-1+cxi;                                     / checkers move up (we rotating the grid)

        validMove:validCoords[cxd;cyd]&                 / if not out of bounds
                  ((bw=`w)=(isW))&                      / and moving its own pieces
                  (povGrid[cxd][cyd]=.cell.empty);      / and moving to an empty space
        if[validMove;                                   / apply the move
            povGrid[cxi]:@[povGrid[cxi];cyi;:;.cell.empty];
            povGrid[cxd]:@[povGrid[cxd];cyd;:;target]];
    ];
    povGrid:$[bw=`b;.util.rotateGrid povGrid;povGrid];  / rerotate the grid
    `.game.grid set povGrid;                            / set global
    show grid
    }