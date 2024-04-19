%Matin Mobini 300283854
%Michael Massaad 300293612

%TESTCASE:nQueen(6, Board).  AND   queens4(Board).

% setting up the board and positons of Queens
queens(N, Queens) :-
    length(Queens, N),
	board(Queens, Board, 0, N, _, _),
	queens(Board, 0, Queens).

board([], [], N, N, _, _).
board([_|Queens], [Col-Vars|Board], Col0, N, [_|VR], VC) :-
	Col is Col0+1,
	functor(Vars, f, N),
	constraints(N, Vars, VR, VC),
	board(Queens, Board, Col, N, VR, [_|VC]).

constraints(0, _, _, _) :- !.
constraints(N, Row, [R|Rs], [C|Cs]) :-
	arg(N, Row, R-C),
	M is N-1,
	constraints(M, Row, Rs, Cs).

queens([], _, []).
queens([C|Cs], Row0, [Col|Solution]) :-
	Row is Row0+1,
	select(Col-Vars, [C|Cs], Board),
	arg(Row, Vars, Row-Row),
	queens(Board, Row, Solution).

% calling queens function to get values for L and then print those values through print_board
queens4(Board) :-
    queens(4, L),
    print_board(L, Board).

% Define valid entries
valid_entry('Q').
valid_entry('X').

% Print board with queens
print_board(Queens, Board) :-
    length(Queens, N),
    length(Board, N),
    maplist(same_length(Board), Board),
    fill_board(Queens, Board),
    maplist(print_row, Board).

% Fill the board with queens at specified positions
fill_board([], []).
fill_board([Q|Queens], [Row|Board]) :-
    fill_row(Q, Row),
    fill_board(Queens, Board).

% Fill a row with 'Q' at the specified position
fill_row(QueenCol, Row) :-
    length(Row, Length),
    numlist(1, Length, Positions),
    member(QueenCol, Positions),
    maplist(put_queen(QueenCol), Positions, Row).

% Helper predicate to put 'Q' at the specified position
put_queen(QueenCol, Col, Entry) :-
    (QueenCol = Col -> Entry = 'Q' ; Entry = 'X').

% Print a row of the board
print_row([]) :- nl.
print_row([H|T]) :-
    write(H),
    write(' '),
    print_row(T).

% calling queens function to get values for L and then print those values through print_board but now with N as dimensions
nQueen(N, Board) :-
    queens(N, L),
    print_board(L, Board).
