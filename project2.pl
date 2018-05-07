%Jamian Vieira
%comp 560
%Prof. Gabrovsky Spring 2018
%initial state: Monkey is at the door,
%               Monkey is on floor,
%               box is at window,
%               Monkey doesn't have banana
%               smallbox is at window
% prolog structure: structName(val1,val2,...)



% state(monkeylocation, monkey onbox/onfloor, boxlocation,
% smallboxlocation, has/hasnot banana) legal actions



do(state(middle, onsmallbox, middle, onbigbox, hasnot),
   grab,
   state(middle, onsmallbox, middle, onbigbox, has)).

do(state(L, onfloor, L, M, Banana),
   climbbig,
   state(L, onbigbox, L, M, Banana)).

do(state(L, onbigbox, L, M, Banana),
   climbsmall,
   state(L, onsmallbox, L, M, Banana)).

do(state(L, onbigbox, L, M, Banana),
   unclimbbig,
   state(L, onfloor, L, M, Banana)).

do(state(L, onsmallbox, L, M, Banana),
   unclimbsmall,
   state(L, onbigbox, L, M, Banana)).

do(state(L1, onfloor, L1, M, Banana),
   pushbig(L1, L2),
   state(L2, onfloor, L2, M, Banana)).

do(state(M1, onfloor, L, M1, Banana),
   pushsmall(M1, M2),
   state(M2, onfloor, L, M2, Banana)).

do(state(L, onfloor, L, L,  Banana),
   stack,
   state(L, onfloor, L, onbigbox, Banana)).

do(state(L1, onfloor, Box, M, Banana),
   walk(L1, L2),
   state(L2, onfloor, Box, M, Banana)).



%canget(State): monkey can get banana in State

canget(state(_,_,_,_,has)).

canget(State1) :-
  do(State1, _, State2),
  canget(State2).

%getplan = list of actions

%canget(state(_,_,_,_,has), []).

%canget(State1, Plan):-
%  do(State1, Action, State2),
%  canget(State2, PartialPlan),
%  add(Action, PartialPlan, Plan),
%  !.

%add(X, L, [X|L]).

canget(state(_,_,_,_,has), []).
canget(State1, [H|T]):-
  do(State1, H, State2),
  canget(State2, T).



% use iterative deepening to prevent infinite cycles of the monkey
% walking back and forth or pushing the box back and forth
% ?- length(Path, _), canget(state(atdoor, onfloor,
% atwindow, atwall, hasnot), Path).
