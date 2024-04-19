%Matin Mobini 300283854
%Michael Massaad 300293612

%TESTCASE: sudoku([[2, A, 3, 1], [B, 1, C, 4], [4, 3, D, 2], [E, F, G, H]]).

% Transposes a list of lists.
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).

% Verifies rows satisfy Sudoku rules.
sudokurows(Rows) :-
    length(Rows, 4),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs), Vs ins 1..4, % Elements are between 1 and 4.
    maplist(all_distinct, Rows),
    transpose(Rows, Columns), % Transpose Rows to get Columns.
    maplist(all_distinct, Columns),
    Rows = [A,B,C,D], % Split Rows into A, B, C, and D.
    blocks(A, B), % check blocks formed by A and B.
    blocks(C, D). % check blocks formed by C and D.

% Verifies block of Sudoku numbers.
blocks([], []). 
blocks([N1,N2|Ns1], [N3,N4|Ns2]) :-
    all_distinct([N1,N2,N3,N4]),
    blocks(Ns1, Ns2).

% Solves and displays Sudoku puzzle.
sudoku(Rows) :-
    sudokurows(Rows),  % Solve Sudoku puzzle.
    maplist(portray_clause, Rows). % Display solved Sudoku puzzle.