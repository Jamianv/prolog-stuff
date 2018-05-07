edge(state(middle, onbox, middle, hasnot),   % grab banana
     state(middle, onbox, middle, has) ).

edge(state(door, onfloor, window, hasnot),           % climb box
     state(window, onfloor, window, hasnot) ).

edge(state(window, onfloor, window, hasnot),           % unclimb box
     state(middle, onfloor, middle, hasnot) ).

edge(state(window, onfloor, window, hasnot),         % push box from L1 to L2
     state(middle, onfloor, middle, hasnot) ).

edge(state(middle, onfloor, middle, hasnot),        % walk from L1 to L2
     state(middle, onbox, middle, hasnot) ).

%path(state(_,_,_,has), []).
%path(X, A, P):-
%    path(X, [], A, P).


%path(Node, _, state(_,_,_,has), [Node]).
%path(State1, Visited, [Action | Actions], [State1 | States]):-
%    do(State1, Action, State2),
%    not(member(State2, Visited)),
%    path(State2, [State2 | Visited], Actions, States).

/*
canget(state(_,_,_,has),[], []).
canget(State1, Visited, [H|T]):-
    do(State1, H, State2),
    not(member(State2, Visited)),
    canget(State2,[State2|Visited], T).

canget(State1, Path):-
  canget(State1, [], Path).
*/

path(Node, Node, _, [Node]).
path(Start, Finish, Visited, [Start|Path]):-
    edge(Start, X),
    not(member(X, Visited)),
    path(X, Finish, [X | Visited], Path).




