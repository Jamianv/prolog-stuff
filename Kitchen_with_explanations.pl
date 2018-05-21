:-dynamic(known/3).
top_goal(X) :- bird(X).

order(tubenose) :-
   nostrils(external_tubular),
   live(at_sea),
   bill(hooked).
order(waterfowl) :-
   feet(webbed),
   bill(flat).
order(falconiforms) :-
   eats(meat),
   feet(curved_talons),
   bill(sharp_hooked).
order(passerformes) :-
   feet(one_long_backward_toe).

family(albatross) :-
   order(tubenose),
   size(large),
   wings(long_narrow).
family(swan) :-
   order(waterfowl),
   neck(long),
   color(white),
   flight(ponderous).
family(goose) :-
   order(waterfowl),
   size(plump),
   flight(powerful).
family(duck) :-
   order(waterfowl),
   feed(on_water_surface),
   flight(agile).
family(vulture) :-
   order(falconiforms),
   feed(scavange),
   wings(broad).
family(falcon) :-
   order(falconiforms),
   wings(loan_pointed),
   head(large),
   tail(narrow_at_tip).
family(fly_catcher) :-
   order(passerformes),
   bill(flat),
   eats(flying_insects).
family(swallow) :-
   order(passerformes),
   wings(long_pointed),
   tail(forked),
   bill(short).

bird(laysan_albatross) :-
   family(albatross),
   color(white).
bird(black_footed_albatross) :-
   family(albatross),
   color(dark).
bird(fulmar) :-
   order(tubenose),
   size(medium),
   flight(flap_glide).
bird(whistling_swan) :-
   family(swan),
   voice(muffled_musical_whistle).
bird(trumpeter_swan) :-
   family(swan),
   voice(loud_trumpeting).
bird(canada_goose) :-
   family(goose),
   season(winter),
   country(united_states),
   head(black),
   cheek(white).
bird(canada_goose) :-
   family(goose),
   season(summer),
   country(canada),
   head(black),
   cheek(white).
bird(snow_goose) :-
   family(goose),
   color(white).
bird(mallard) :-
   family(duck),
   voice(quack),
   head(green).
bird(mallard) :-
   family(duck),
   voice(quack),
   color(mottled_brown).
bird(pintail) :-
   family(duck),
   voice(short_whistle).
bird(turkey_vulture) :-
   family(vulture),
   flight_profile(v_shaped).
bird(california_condor) :-
   family(vulture),
   flight_profile(flat).
bird(sparrow_hawk) :-
   family(falcon),
   eats(insects).
bird(peregrine_falcon) :-
   family(falcon),
   eats(birds).
bird(great_crested_flycatcher) :-
   family(flycatcher),
   tail(long_rusty).
bird(ash_throated_flycatcher) :-
   family(flycatcher),
   throat(white).
bird(barn_swallow) :-
   family(swallow),
   tail(forked).
bird(cliff_swallow) :-
   family(swallow),
   tail(square).
bird(purple_martin) :-
   family(swallow),
   color(dark).

country(united_states) :- region(new_england).
country(united_states) :- region(south_east).
country(united_states) :- region(mid_west).
country(united_states) :- region(south_west).
country(united_states) :- region(north_west).
country(united_states) :- region(mid_atlantic).

country(canada) :- province(ontario).
country(canada) :- province(quebec).
country(canada) :- province(etc).

region(new_england) :-
   state(X),
   member(X, [massachusetts, vermont, etc]).
region(south_east) :-
   state(X),
   member(X, [florida, mississippi, etc]).
region(canada) :-
   province(X),
   member(X, [ontario, quebec, etc]).

%attributes whose values come from the user

nostrils(X) :- ask(nostrils, X).
live(X) :- ask(live, X).
bill(X) :- ask(bill, X).
size(X) :-
   menuask(size, X, [large, plump, medium, small]).
eats(X) :- ask(eats, X).
feet(X) :- ask(feet, X).
wings(X) :- ask(wings, X).
neck(X) :- ask(neck, X).
color(X) :- ask(color, X).
flight(X) :-
   menuask(flight, X, [ponderous, powerful, agile,
         flap_glide, other]).
feed(X) :- ask(feed, X).
head(X) :- ask(head, X).
tail(X) :-
   menuask(tail, X, [narrow_at_tip, forked, long_rusty,
           square, other]).
voice(X) :- ask(voice, X).
season(X) :- menuask(season, X, [winter, summer]).
cheek(X) :- ask(cheek, X).
flight_profile(X) :-
   menuask(flight_profile, X, [flat, v_shaped, other]).
throat(X) :- ask(throat, X).
state(X) :-
   menuask(state, X, [massachusetts, vermont, florida,
           mississippi, etc]).
province(X) :-
   menuask(province, X, [ontario, quebec, etc]).
multivalued(voice).
multivalued(color).
multivalued(eats).

ask(A, V):-
    known(yes, A, V), % succeed if true
    !.	% stop looking

ask(A, V):-
    known(_, A, V), % fail if false
    !, fail.

ask(A, V):-
    write(A:V), % ask user
    write('? : '),
    read(Y), % get the answer
    asserta(known(Y, A, V)), % remember it
    Y == yes.	% succeed or fail

ask(A, V):-
    not(multivalued(A)),
    known(yes, A, V2),
    V \== V2,
    !, fail.

menuask(A, V, MenuList) :-
    write('What is the value for'), write(A), write('?'), nl,
    write(MenuList), nl,
    read(X),
    check_val(X, A, V, MenuList),
    asserta( known(yes, A, X) ),
    X == V.

check_val(X, _, _, MenuList) :-
    member(X, MenuList), !.

check_val(X, A, V, MenuList) :-
    write(X), write(' is not a legal value, try again.'), nl,
    menuask(A, V, MenuList).



solve :-
    retractall(known(,,,)),
    top_goal(X),
    write('The answer is '), write(X), nl.

solve :-
    write('No answer found.'), nl.

how(Goal) :-
	clause(Goal,Body),
	prove(Body,[]),
	write_body(4,Body).

whynot(Goal) :-
	clause(Goal,Body),
	write_line([Goal,'fails because: ']),
	explain(Body).
whynot(_).

explain(true).
explain((Head,Body)) :-
	check(Head),
	explain(Body).

check(H) :- prove(H,[]), write_line([H,succeeds]), !.
check(H) :- write_line([H,fails]), fail.

write_list(_,[]).
write_list(N,[H|T]) :-
	tab(N),write(H),nl,
	write_list(N,T).

write_body(N,(First,Rest)) :-
	tab(N),write(First),nl,
	write_body(N,Rest).
write_body(N,Last) :-
	tab(N),write(Last),nl.

write_line(L) :-
	flatten(L,LF),
	write_lin(LF).

write_lin([]) :- nl.
write_lin([H|T]) :-
	write(H), tab(1),
	write_lin(T).

flatten([],[]) :- !.
flatten([[]|T],T2) :-
	flatten(T,T2), !.
flatten([[X|Y]|T], L) :-
	flatten([X|[Y|T]],L), !.
flatten([H|T],[H|T2]) :-
	flatten(T,T2).
