rule(5,
     lhs([av(turns_over, yes), av(gas_gauge, empty)]),
     rhs(av(problem, flooded), 80)).

fact(av(A, V), CF).

findgoal(av(Attr, Val), CF):-
    fact(av(Attr, Val), CF),
    !.
findgoal(av(Attr, Val), CF):-
    not(fact(av(Attr, _), _)),
    askable(Attr, Prompt),
    !,
    findgoal(av(Attr, Val), CF).
