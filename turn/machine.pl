/****TOUR MACHINE****/
playTurnAI(InBoard, Colour, OutBoard) :-
  print('Tour de l''ordinateur '), print(Colour), nl,
  print('Flag 1\n'),
  generateMove(InBoard, Colour, Move),
  print('Flag 2\n'),
  transfert(InBoard, Move, OutBoard).
