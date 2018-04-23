% ---Begin Code---
%
% TODO: write a procedure named interpretBounds that takes:
% 1.) A Prolog query to execute
%
% 2.) The smallest number that a variable can be in an
%     arithmetic expression.
%
% 3.) The largest number that a variable can be in an
%     arithmetic expression.
%
% The intention with interpretBounds is that this lifts the
% restriction that arithmetic constraints must work with
% known values.  Here, if we try to use an arithmetic
% constraint with an unknown value, we will pick integers
% in the given range for the unknown values, and try with
% those.
%
% Your interpretBounds procedure needs to handle at least the
% following kinds of Prolog clauses:
% - true
% - arithmetic constraints (>, >=, <, =<, is)
% - conjunction
% - calls
%
% The constraint helper below has been provided, which
% can be helpful in determining if a given Prolog clause
% is an arithmetic constraint.
%
% Example queries follow:
%
% ?- interpretBounds((X < Y), 0, 2).
% X = 0,
% Y = 1 ;
% X = 0,
% Y = 2 ;
% X = 1,
% Y = 2 ;
% false.
%
% ?- interpretBounds((X is Y + Z, X > 0), 0, 2).
% X = Z, Z = 1,
% Y = 0 ;
% X = Y, Y = 1,
% Z = 0 ;
% X = Z, Z = 2,
% Y = 0 ;
% X = 2,
% Y = Z, Z = 1 ;
% X = Y, Y = 2,
% Z = 0 ;
% false.

interpretBounds(true, _, _):-!.
interpretBounds((A, B), Bound1, Bound2):-
    !,
    interpretBounds(A, Bound1, Bound2),
    interpretBounds(B, Bound1, Bound2).
interpretBounds(Exp, Bound1, Bound2):-
    constraint(Exp),
    term_variables(Exp, List),
    between(Bound1, Bound2, A),
    member(A, List),
    findall(pair(Exp, Body), clause(constraint(Exp), Body), Bodies),
    member(pair(Call, Body),Bodies),
    interpretBounds(Call, Bound1, Bound2).
interpretBounds(Exp, Bound1, Bound2):-
    constraint(Exp),
    ground(Exp),
    call(Exp),
    clause(constraint(Exp), Body),
    interpretBounds(Body, Bound1, Bound2).

% Succeeds if the given input is an arithmetic constraint
constraint((_ > _)).
constraint((_ >= _)).
constraint((_ < _)).
constraint((_ =< _)).
constraint((_ is _)).



% ---Begin Testing-Related Code---
% The test suite can be run like so:
%
% ?- runTests.
%
% It should succeed.  If it doesn't, you can figure
% out which test is failing by tracing runAlgebraicTests,
% runSortedTests, runSumTests, etc.
%

algebraic1 :-
    % X is Y + Z,
    % X < 2,
    % Y >= 1
    once(interpretBounds((X is Y + Z, X < 2, Y >= 1), 0, 2)),
    X == 1,
    Y == 1,
    Z == 0.

algebraic2 :-
    % X < Y < Z
    once(interpretBounds((X < Y, Y < Z), 0, 2)),
    X == 0,
    Y == 1,
    Z == 2.

algebraic3 :-
    % X > Y > Z
    once(interpretBounds((X > Y, Y > Z), 0, 2)),
    X == 2,
    Y == 1,
    Z == 0.

algebraic4 :-
    % X <= Y < Z
    setof([X, Y, Z], interpretBounds((X =< Y, Y < Z), 0, 2), Lists),
    Lists = [[0, 0, 1],
             [0, 0, 2],
             [0, 1, 2],
             [1, 1, 2]].

algebraic5 :-
    % X < Y <= Z
    setof([X, Y, Z], interpretBounds((X < Y, Y =< Z), 0, 2), Lists),
    Lists = [[0, 1, 1],
             [0, 1, 2],
             [0, 2, 2],
             [1, 2, 2]].

algebraic6 :-
    % X >= Y > Z
    setof([X, Y, Z], interpretBounds((X >= Y, Y > Z), 0, 2), Lists),
    Lists = [[1, 1, 0],
             [2, 1, 0],
             [2, 2, 0],
             [2, 2, 1]].

algebraic7 :-
    % X > Y >= Z
    setof([X, Y, Z], interpretBounds((X > Y, Y >= Z), 0, 2), Lists),
    Lists = [[1, 0, 0],
             [2, 0, 0],
             [2, 1, 0],
             [2, 1, 1]].

runAlgebraicTests :-
    algebraic1,
    algebraic2,
    algebraic3,
    algebraic4,
    algebraic5,
    algebraic6,
    algebraic7.

sorted([]).
sorted([_]).
sorted([A, B|Rest]) :-
    A =< B,
    sorted([B|Rest]).

generateSorted(Min, Max, List) :-
    interpretBounds(sorted(List), Min, Max).

makeList(0, []).
makeList(N, [_|T]) :-
    N > 0,
    NewN is N - 1,
    makeList(NewN, T).

generateAllSorted(Min, Max, ListSize, Lists) :-
    setof(L, (makeList(ListSize, L), generateSorted(Min, Max, L)), Lists).

runSortedTests :-
    generateAllSorted(0, 2, 0, [[]]),
    generateAllSorted(0, 2, 1, [[_]]),
    generateAllSorted(0, 2, 2, [[0, 0],
                                [0, 1],
                                [0, 2],
                                [1, 1],
                                [1, 2],
                                [2, 2]]),
    generateAllSorted(0, 2, 3, [[0, 0, 0],
                                [0, 0, 1],
                                [0, 0, 2],
                                [0, 1, 1],
                                [0, 1, 2],
                                [0, 2, 2],
                                [1, 1, 1],
                                [1, 1, 2],
                                [1, 2, 2],
                                [2, 2, 2]]).


sum([], 0).
sum([H|T], Result) :-
    sum(T, TResult),
    Result is TResult + H.

sumTest(Min, Max, Sum, ListSize, Expected) :-
    setof(L, (makeList(ListSize, L), interpretBounds(sum(L, Sum), Min, Max)), Expected).

runSumTests :-
    % List size: 1
    sumTest(0, 2, 0, 1, [[0]]),
    sumTest(0, 2, 1, 1, [[1]]),
    sumTest(0, 2, 2, 1, [[2]]),

    % List size: 2
    sumTest(-1, 1, 0, 2, [[-1, 1],
                          [0, 0],
                          [1, -1]]),
    sumTest(0, 2, 0, 2, [[0, 0]]),

    % List size: 3
    sumTest(-1, 1, 2, 3, [[1, 0, 1],
                          [1, 1, 0]]),
    sumTest(0, 2, 2, 3, [[0, 0, 2],
                         [0, 1, 1],
                         [0, 2, 0],
                         [1, 0, 1],
                         [1, 1, 0],
                         [2, 0, 0]]).

runTests :-
    runAlgebraicTests,
    runSortedTests,
    runSumTests.
