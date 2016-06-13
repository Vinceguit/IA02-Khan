/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*generateMove utilise l'algorithme AlphaBeta pour renvoyer Move, le meilleur mouvement*/

generateMove(BoardInit, Player, BestMove) :-

									/*On crée une copie temporaires des prédicats pion sous le nom de miniMaxPion*/
									findall((IdPion,Col,Lin,Etat,Marq),pion(IdPion,Col,Lin,Etat,Marq),ListePionsMinimax),
									recopiagePions(ListePionsMinimax),
									
								
									possibleMovesMiniMax(BoardInit,Player,List),
									sort(List,PossibleMoveList),
									
                                    exploMiniMax(PossibleMoveList,Player,4,BoardInit)	
									
									getBestMove(BoardInit,Player,BestMove),
									findall((Board,H),idNoeud(_,_,_,BoardInit,Board,H),L),
									meilleurBoard(L,B),
									transfertMini()
									possibleMovesMiniMax(Board,Player,L)
									rechercheIndex(L,Index,BestMove)
									
									retractall(miniMaxPion(_,_,_,_,_)).



  recopiagePions([(IdPion,Col,Lin,Etat,Marq)|Q]) :- asserta(miniMaxPion(IdPion,Col,Lin,Etat,Marq)),recopiagePions(Q).
  recopiagePions([]).

/*Cas1: Si on atteint une feuille  */
miniMax(Player, 0,InBoard,Board) :-
												heuristic(Board, Player, Heuristique),
												modifNoeud(MinOuMax,Alpha,Beta,InBoard,Board,Heuristique).

												
/*Cas2 si on atteint un noeud*/										
miniMax(Player,Strate,InBoard,Board) :- idNoeud(_,_,_,_,_,Board,_,_),
											 possibleMovesMiniMax(Board,Player,List),
											 sort(List,PossibleMoveList),
											 exploMiniMax(PossibleMoveList,Player,Strate,Board).

modifNoeud(MinOuMax,Alpha,Beta,InBoard,Board,H):- H>Alpha,retract(idNoeud(MinOuMax,Alpha,Beta,InBoard,Board,H)),
													  asserta(idNoeud(MinOuMax,Alpha,H,InBoard,Board,H)).
modifNoeud(MinOuMax,Alpha,Beta,InBoard,Board,H).




initNoeud(min,Alpha,Beta,InBoard,NewBoard):- idNoeud(_,Alpha,Beta,_,InBoard,Beta),
													 asserta(idNoeud(min,Alpha,Beta,InBoard,NewBoard,Beta)).
initNoeud(max,Alpha,Beta,InBoard,NewBoard):- idNoeud(_,Alpha,Beta,_,InBoard,_),asserta(idNoeud(max,Alpha,Beta,InBoard,NewBoard,Alpha)).

enregistrement(ListeEnregistrement):- findall((IdPion,Col,Lin,Etat,Marq),miniMaxPion(IdPion,Col,Lin,Etat,Marq),ListeEnregistrement).

exploMiniMax([(Col1,Lin1,Col2,Lin2)|Res],Player,Strate,InBoard) :-    			Value<Beta,
																				miniMaxPion(Pion,Col1,Lin1,_,_),
																				transfertMiniMax(InBoard,(Col1,Lin1,Col2,Lin2),Pion,OutBoard),
																				idNoeud(MinOuMax,Alpha,Beta,_,InBoard,Value),
																				opposeMinMax(MinOuMax,Oppose),
																				initNoeud(Oppose,Alpha,Beta,InBoard,OutBoard),
																				Strate-1 is NewStrate,
																				miniMax(Player,NewStrate,InBoard,OutBoard),
																				retractall(miniMaxPion(_,_,_,_,_),
																				recopiagePions(ListePions),
																				exploMiniMax(Res,Player,Strate,InBoard,ListePions).
																				

																				
exploMiniMax([(Col1,Lin1,Col2,Lin2)|_],Player,Strate,InBoard) :-  				
																				miniMaxPion(Pion,Col1,Lin1,_,_),
																				transfertMiniMax(InBoard,(Col1,Lin1,Col2,Lin2),Pion,OutBoard),
																				idNoeud(MinOuMax,Alpha,Beta,_,InBoard,_),
																				opposeMinMax(MinOuMax,Oppose),
																				initNoeud(Oppose,Alpha,Beta,InBoard,OutBoard),
																				Strate-1 is NewStrate,
																				miniMax(Player,NewStrate,InBoard,OutBoard).
exploMiniMax([],_,_,_).

opposeMinMax(min,max).
opposeMinMax(max,min).