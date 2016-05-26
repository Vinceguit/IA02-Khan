placerPionsIA(InBoard, Cote, rouge, OutBoard) :- placerPionIA(InBoard, Cote, ko, Board1),
                                                 placerPionIA(Board1, Cote, o1, Board2),
                                                 placerPionIA(Board2, Cote, o2, Board3),
                                                 placerPionIA(Board3, Cote, o3, Board4),
                                                 placerPionIA(Board4, Cote, o4, Board5),
                                                 placerPionIA(Board5, Cote, o5, OutBoard).

/*Pour l'instant, on appelle le placement de pion humain pour faire tourner le programme*/
placerPionIA(InBoard, Cote, TypePion, OutBoard) :- placerPion(InBoard, Cote, TypePion, OutBoard).
