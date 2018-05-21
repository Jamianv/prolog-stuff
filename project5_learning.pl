:-dynamic(known/3).
top_goal(X):-bird(X).
bird(laysan_albatross):-
  family(albatross),
  color(white).

bird(black_footed_albatross):-
  family(albatross),
  color(dark).

bird(whistling_swan) :-
  family(swan),
  voice(muffled_musical_whistle).

bird(trumpeter_swan) :-
  family(swan),
  voice(loud_trumpeting).

bird(canada_goose):-
  family(goose),
  season(winter),
  country(united_states),
  head(black),
  cheek(white).

bird(canada_goose):-
  family(goose),
  season(summer),
  country(canada),
  head(black),
  cheek(white).

bird(mallard):-
  family(duck),
  voice(quack),
  head(green).

bird(mallard):-
  family(duck),
  voice(quack),
  color(mottled_brown).

order(tubenose) :-
  nostrils(external_tubular),
  live(at_sea),
  bill(hooked).

order(waterfowl) :-
  feet(webbed),
  bill(flat).

family(goose) :-
   order(waterfowl),
   size(plump),
   flight(powerful).

family(duck) :-
   order(waterfowl),
   feed(on_water_surface),
   flight(agile).

family(albatross) :-
  order(tubenose),
  size(large),
  wings(long_narrow).

family(swan) :-
  order(waterfowl),
  neck(long),
  color(white),
  flight(ponderous).

country(united_states):- region(mid_west).

country(united_states):- region(south_west).

country(united_states):- region(north_west).

country(united_states):- region(mid_atlantic).

country(canada):- province(ontario).

country(canada):- province(quebec).

region(new_england):-
  state(X),
  member(X, [massachusetts, vermont, etc]).

region(south_east):-
  state(X),
  member(X, [florida, mississippi, etc]).

nostrils(X) :- ask(nostrils, X).
live(X) :- ask(live, X).
bill(X) :- ask(bill, X).
eats(X):- ask(eats, X).
size(X) :- menuask(size, X,[large, plump, medium, small]).
feet(X):- ask(feet, X).
wings(X):- ask(wings, X).
neck(X):- ask(neck, X).
color(X):- ask(color, X).
flight(X) :- menuask(flight, X, [ponderous, agile, flap_glide]).
feed(X) :- ask(feed, X).
head(X) :- ask(head, X).
tail(X) :- ask(tail, X).
voice(X) :- ask(voice, X).
season(X) :- ask(season, X).
cheek(X) :- ask(cheek, X).
flight_profile(X) :- ask(flight_profile, X).
throat(X) :- ask(throat, X).
state(X) :- ask(state, X).
province(X) :- ask(province, X).

ask(A, V):-
  known(yes, A, V),
  !.

ask(A, V):-
  known(_, A, V),
  !, fail.

ask(A, V):-
  \+multivalued(A),
  known(yes, A, V2),
  V \== V2,
  !, fail.

ask(Attr, Val):-
  write(Attr:Val),
  write('? '),
  read(Y),
  asserta(known(Y, Attr, Val)),
  Y == yes.

menuask(A, V, MenuList):-
  write('What is the value for '), write(A), write('?'), nl,
  write(MenuList),  nl,
  read(X),
  check_val(X, A, V, MenuList),
  asserta(known(yes, A, X)),
  X == V.

check_val(X, _, _, MenuList):-
  member(X, MenuList), !.

check_val(X, A, V, MenuList):-
  write(X), write(' is not a legal value, try again.'), nl,
  menuask(A , V, MenuList).

multivalued(voice).
multivalued(feed).


solve:-
  abolish(known, 3),
  top_goal(X),
  write('The answer is '), write(X), nl.

solve:-
  write('No answer found.'), nl.










