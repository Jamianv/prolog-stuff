:-op(200,xfy,and).
:-op(300,xfy,or).
:-op(700,xfx,then).
:-op(800,fx,if).

read_file(File,Term):-
    open(File, read, Stream),
    repeat,
      read(Stream, Term),
        (
         Term == end
         ->  !;
         print(Term),
         fail
        ),
    close(Stream).
