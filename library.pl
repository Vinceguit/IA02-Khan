/***********************************************************/
/*Bibliothèque de prédicats utiles dans différents fichiers*/
/***********************************************************/

/*Initialisation de la liste de pions. Retractall en cas d'exécution du programme auparavant*/
setListePions :- retractall(listePions(_, _)),
                 asserta(listePions(ocre,[(ko, 0, 0), (o1, 0, 0), (o2, 0, 0), (o3, 0, 0), (o4, 0, 0), (o5, 0, 0)])),
                 asserta(listePions(rouge, [(kr, 0, 0), (r1, 0, 0), (r2, 0, 0), (r3, 0, 0), (r4, 0, 0), (r5, 0, 0)])).

/*Update de la position d'un pion dans la liste des pions*/
updateListePions(TypePion, Lin, Col) :- findColour(TypePion, Colour),
                                        listePions(Colour, ListeIn),
                                        updatePion(ListeIn, TypePion, Lin, Col, ListeOut),
                                        retract(listePions(Colour, ListeIn)),
                                        asserta(listePions(Colour, ListeOut)).

/*Renvoie la couleur d'un pion à partir de son type*/
findColour(TypePion, rouge) :- element(TypePion, [kr, r1, r2, r3, r4, r5]), !.
findColour(TypePion, ocre) :- element(TypePion, [ko, o1, o2, o3, o4, o5]), !.

/*Màj effective de la liste de pions*/
updatePion([(TypePion, _, _)|Q], TypePion, Lin, Col, [(TypePion, Lin, Col)|Q]) :- !.
updatePion([T|QueueIn], TypePion, Lin, Col, [T|QueueOut]) :- updatePion(QueueIn, TypePion, Lin, Col, QueueOut).
