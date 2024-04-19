%Matin Mobini 300283854
%Michael Massaad 300293612

%TESTCASE: most_repeated([10, 25, 34, 25, 16, 10, 25, 16, 16, 16], Result).


% Define a predicate to count occurrences of an element in a list
count_occurrences(_, [], 0).  % Base case: Count is 0 for an empty list

count_occurrences(X, [X|T], N) :- count_occurrences(X, T, N1), N is N1 + 1.  % If X is the head of the list, increment count

count_occurrences(X, [Y|T], N) :- X \= Y, count_occurrences(X, T, N).  % If X is not the head, continue counting in the tail

% Define a predicate to find the maximum count of elements in a list
max_count([], 0).

max_count([X|Xs], Max) :-
    max_count(Xs, Max1),
    count_occurrences(X, [X|Xs], Count),
    Max is max(Max1, Count).

% Define a predicate to find all elements with the maximum count
most_repeated(List, Result) :-
    max_count(List, MaxCount),
    findall(X, (member(X, List), count_occurrences(X, List, Count), Count == MaxCount), RepeatedList),
    list_to_set(RepeatedList, Result). % Remove duplicates from the list of most repeated numbers
