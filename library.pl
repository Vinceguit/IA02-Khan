/***********************************************************/
/*Bibliothèque de prédicats utiles dans différents fichiers*/
/***********************************************************/

/*Initialisation de la liste de pions. Retractall en cas d'exécution du programme auparavant*/
setListePions :- retractall(listePions(_)),
                 asserta(listePions([(kr, 0, 0), (r1, 0, 0), (r2, 0, 0), (r3, 0, 0), (r4, 0, 0), (r5, 0, 0),
                                     (ko, 0, 0), (o1, 0, 0), (o2, 0, 0), (o3, 0, 0), (o4, 0, 0), (o5, 0, 0)])).

/*Update de la position d'un pion dans la liste des pions*/
updateListePions(TypePion, Lin, Col) :- listePions(ListeIn),
                                        updatePion(ListeIn, TypePion, Lin, Col, ListeOut),
                                        retract(listePions(ListeIn)),
                                        asserta(listePions(ListeOut)).
updatePion([(TypePion, _, _)|Q], TypePion, Lin, Col, [(TypePion, Lin, Col)|Q]) :- !.
updatePion([T|QueueIn], TypePion, Lin, Col, [T|QueueOut]) :- updatePion(QueueIn, TypePion, Lin, Col, QueueOut).
