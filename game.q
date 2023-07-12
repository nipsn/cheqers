\l util.q

/ all possible grid cells
\d .cell
empty:`$"[ ]"
checkerW:`$"[w]"
queenW:`$"[W]"
checkerB:`$"[b]"
queenB:`$"[B]"

checkers:checkerW,checkerB
queens:queenW,queenB
whites:queenW,checkerW
blacks:queenB,checkerB

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
             (0<=x<=7)&
             (0<=y<=7)}

/check if queens on the first and last row
checkQueens:{[g]
    g[0]:@[topRow;where(topRow:g[0])=.cell.checkerW;:;.cell.queenW];
    g[7]:@[botRow;where(botRow:g[7])=.cell.checkerB;:;.cell.queenB];
    g}

showGrid:{[bw]show($[bw=`b;.util.rotateGrid;::])grid}

userChoice:{break}

move:{[bw;coords;lr]
    povGrid:$[bw=`b;.util.rotateGrid grid;grid];        / rotate if bw=`b
    cxi:coords[0];                                      / vertical
    cyi:coords[1];                                      / horizontal
    if[povGrid[cxi][cyi]<>.cell.empty;                  / if we are not trying to move an empty
        target:povGrid[cxi][cyi];                       / checker we want to move
        cyd:$[lr=`l;-1+cyi;1+cyi];                      / left move or right move
        cxd:$[target in .cell.queens;1+cxi;-1+cxi];     / checkers move up, queens move down
        validMove:validCoords[cxd;cyd]&                 / if not out of bounds
                  ((bw=`w)=(target in .cell.whites))&   / and moving its own pieces
                  (povGrid[cxd][cyd]=.cell.empty);      / and moving to an empty space
        $[validMove;                                    / apply the move
            [povGrid[cxi]:@[povGrid[cxi];cyi;:;.cell.empty];
             povGrid[cxd]:@[povGrid[cxd];cyd;:;target]]
          not validMove;
            -2"not a valid move"
        ];
    ];
    povGrid:$[bw=`b;.util.rotateGrid povGrid;povGrid];  / rerotate the grid
    `.game.grid set checkQueens povGrid;                / set global
    showGrid[bw];
    validMove}

