A reader, which converts the source code of our language from a string of char­ac­ters into Racket-style paren­the­sized forms, also known as S-expres­sions.

An expander, which deter­mines how these paren­the­sized forms corre­spond to real Racket expres­sions (which are then eval­u­ated to produce a result).

The #lang line’s job is to tell Racket where to find that reader.

The reader, in turn, will tell Racket where to find the expander.