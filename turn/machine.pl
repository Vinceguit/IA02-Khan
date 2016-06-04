/****TOUR MACHINE****/
playTurnAI(Colour, InBoard, OutBoard) :- print('Tour de l''ordinateur '), print(Colour), nl,
                                         generateMove(InBoard, Colour, Move),
                                         transfert(InBoard, Move, OutBoard).
