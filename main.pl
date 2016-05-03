
human(X):-write('You are human because you are '), write(X),
write('Lets play Khan').

%Création de la matrice des mouvements
a = [[2,3,1,2,2,3], [2,1,3,1,3,1], [1,3,2,3,1,2], [3,1,2,1,3,2], [2,3,1,3,1,3], [2,1,3,2,2,1]].
affiche([]).
affiche([[D]|R]) :- write(D), nl,!, affiche(R).
