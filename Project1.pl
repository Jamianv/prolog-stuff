male(jack).
male(peter).
male(chris).
male(joe).
male(roy).
male(christopher).
male(ryan).
male(jeff).
male(kanan).
male(johnathan).
male(adam).
male(matthew).

female(stassie).
female(karma).
female(susan).
female(jane).
female(carol).
female(sherry).
female(greta).
female(shayla).
female(molly).
female(becca).
female(tori).

parent(jack, stassie).
parent(karma, stassie).
parent(peter, becca).
parent(peter, tori).
parent(chris, shayla).
parent(jeff, molly).
parent(jeff, kanan).
parent(jane, christopher).
parent(jane, ryan).
parent(carol, adam).
parent(carol, matthew).
parent(carol, johnathan).
parent(sherry, jack).
parent(sherry, peter).
parent(sherry, jane).
parent(sherry, carol).
parent(joe, jack).
parent(joe, peter).
parent(joe, jane).
parent(joe, carol).
parent(greta, karma).
parent(greta, susan).
parent(greta, chris).
parent(greta, jeff).
parent(roy, karma).
parent(roy, susan).
parent(roy, chris).
parent(roy, jeff).

mother(X, Y) :-
    female(X),
    parent(X, Y).

father(X, Y) :-
    male(X),
    parent(X, Y).

child(X, Y):-
    parent(Y, X).

son(X, Y):-
    male(X),
    child(X, Y).

daughter(X, Y):-
    female(X),
    child(X, Y).

sibling(X, Y) :-
    parent(Z, X),
    parent(Z, Y),
    not(X = Y).


sister(X, Y) :-
    female(X),
    sibling(X,Y).

brother(X, Y) :-
    male(X),
    sibling(X, Y).

grandparent(X, Y):-
    parent(X, Z),
    parent(Z, Y).

grandmother(X,Y):-
    female(X),
    grandparent(X,Y).


grandfather(X,Y):-
    male(X),
    grandparent(X,Y).

aunt(X, Y):-
    female(X),
    parent(Z, X),
    grandparent(Z, Y),
    not(parent(X,Y)).

uncle(X, Y):-
    male(X),
    parent(Z, X),
    grandparent(Z, Y),
    not(parent(X,Y)).

cousin(X, Y):-
    parent(Z, X),
    parent(V, Y),
    sibling(Z, V).


