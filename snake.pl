:- [tests].
:- use_module(library(clpfd)). % Import the module
:- set_prolog_flag(clpfd_monotonic, true). % setting to get useful errors sometimes


counter2([], 0).
counter2([X|Xs], N) :- dif(X, 2) -> counter(Xs, N); counter(Xs, N0), succ(N0, N).


% checks if valid solution possible and if given first three solve the solution

snake(RowClues, ColClues, Grid, Solution):- copyGrid(Grid,Solution),
checkRowClues(Solution,RowClues).
% checkColClues(Solution,ColClues),
% nonTouching(Solution). % snake cannot touch itself
% countNeighbors(Solution) % heads have 1 neighbor ,midpoints 2
% snakeConnected(Solution). % snake must be connected

countNeighbors(Solution) :- extend_grid(Solution, Grid), countHelper(Grid).
countHelper([First, Second, Third, Row]) :- check_neighbors_rows(First, Second, Third), countHelper([Second, Third, Row]).

copyGrid([],[]).
copyGrid([Row|G],[RowS|S]) :- copyRow(Row,RowS), copyGrid(G,S).

copyRow([],[]).
copyRow([-1|R],[_|S]) :- copyRow(R,S).
copyRow([Clue|R],[Clue|S]) :- copyRow(R,S).


checkRowClues([], []).
checkRowClues([X|S], [Y|H]) :- counter(X, N), counter2(X, M), (N + M = Y), checkRowClues([S],[H]).


checkColClues([],[]).
checkColClues(M, CL) :- transpose(M, Trans), checkRowClues(Trans, CL).


% check_neighbors_pattern(0,_,_,_,_).check_neighbors_pattern(Piece,N,E,S,W) :- 1 #=< Piece,count_cell(N,X1),
% count_cell(E,X2),
% count_cell(S,X3),
% count_cell(W,X4),
% Piece #= X1+X2+X3+X4.

check_neighbors_rows([_,N,A3|RowA],[W,M,E|RowB],[_,S,C3|RowC]) :-check_neighbors_pattern(M,N,E,S,W),check_neighbors_rows([N,A3|RowA],[M,E|RowB],[S,C3|RowC]).
% Extend a row by adding a 0 at both ends
extend_row(OldRow,NewRow) :- append([0|OldRow],[0],NewRow).
extend_grid(OldGrid,NewGrid) :- transpose(OldGrid,TransGrid),extend_grid_rows(TransGrid,RowTransGrid),transpose(RowTransGrid,RowGrid),extend_grid_rows(RowGrid,NewGrid).


extend_grid_rows([R, L], [NR, NL]) :- extend_grid_rows(L, NL), extend_row(R, NR).

count_cell(0,0).
count_cell(1,1).
count_cell(2,1).

blockTouch([A, B, C, D]) :-
    A + D #=< C + B + 1,
    C + B #=< A + D + 1,
    A + B + C + D #=< 3.

recursiveRow([],[]).
recursiveRow([A, B|First], [C, D|Second]) :- blockTouch([A, B, C, D]), recursiveRow([B, First], [D, Second]).

recursiveDown([]).
recursiveDown([First, Second|Rest]) :- recursiveRow([First], [Second]), recursiveDown([Second, Rest]).

nonTouching(S) :- recursiveDown(S).



% counter code found here at https://stackoverflow.com/questions/32691313/counter-in-prolog
counter([], 0).
counter([X|Xs], N) :- dif(X, 1) -> counter(Xs, N); counter(Xs, N0), succ(N0, N).
