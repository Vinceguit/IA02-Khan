/****TOUR MACHINE****/
playTurnAI(InBoard, Colour, OutBoard) :-
  print('Tour de l''ordinateur '), print(Colour), nl,
  
  generateMove(InBoard, Colour, (Col1,Lin1,Col2,Lin2)),
  pion(Pion,Col1,Lin1,_,_),!,
  transfert(InBoard, (Col1,Lin1,Col2,Lin2),Pion, OutBoard).
