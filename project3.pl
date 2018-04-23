path(Node, Node, _, [Node]).
path(Start, Finish, Visited, [Start | Path]):-
    edge(Action, State1, State2),
    not(member(X, Visited)),
    path(X, Finish, [X|Visited], Path).

/* States are represented as a vector
   [Monkey-location, Monkey-onbox?, Box-location,
   Has-banana? ]
*/
edge(climb_box,[L, onfloor, L, Banana], [L, onbox, L, Banana]).
edge(grab, [L, onbox, L, hasnot], [L, onbox, L, has]).
