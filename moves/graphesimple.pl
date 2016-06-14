generateMove(BoardInit, Player, BestMove) :-

									/*On crée une copie temporaire des prédicats pion sous le nom de miniMaxPion*/
									findall((IdPion,Col,Lin,Etat,Marq),pion(IdPion,Col,Lin,Etat,Marq),ListePionsMinimax),
									recopiagePions(ListePionsMinimax),
									possibleMovesMiniMax(BoardInit,Player,List),
									sort(List,PossibleMoveList),
									testHeuristique(PossibleMoveList,Player,BoardInit,ListePionsMinimax,[],Lmoves),
									sort(Lmoves,L2),reverse(L2,L3),element((_,BestMove),L3),!,retractall(miniMaxPion(_,_,_,_,_)).
									
						
                                   

testHeuristique([(Col1,Lin1,Col2,Lin2)|L],Player,InBoard,ListePionsMinimax,L1,L3):- 
																		miniMaxPion(Pion,Col1,Lin1,_,_),
																		transfertMiniMax(InBoard,(Col1,Lin1,Col2,Lin2),Pion,OutBoard),
																		heuristic(OutBoard, Player, H),
																		append([(H,(Col1,Lin1,Col2,Lin2))],L1,L2),
																		retractall(miniMaxPion(_,_,_,_,_)),
																		recopiagePions(ListePionsMinimax),
																		testHeuristique(L,Player,InBoard,ListePionsMinimax,L2,L3).
testHeuristique([],_,_,_,L,L).


  recopiagePions([(IdPion,Col,Lin,Etat,Marq)|Q]) :- asserta(miniMaxPion(IdPion,Col,Lin,Etat,Marq)),recopiagePions(Q).
  recopiagePions([]).




