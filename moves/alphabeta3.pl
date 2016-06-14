/**********************************************/
/*Détermination du meilleur mouvement possible*/
/**********************************************/

/*generateMove utilise l'algorithme AlphaBeta pour renvoyer Move, le meilleur mouvement*/

generateMove(BoardInit, Player, BestMove) :-

									/*On crée une copie temporaires des prédicats pion sous le nom de miniMaxPion*/
									write('Bug1.1'),findall((IdPion,Col,Lin,Etat,Marq),pion(IdPion,Col,Lin,Etat,Marq),ListePionsMinimax),
									write('Bug1.2'),recopiagePions(ListePionsMinimax),
									write('Bug1.3'),possibleMovesMiniMax(BoardInit,Player,List),
									write('Bug1.4'),sort(List,PossibleMoveList),
									asserta(idNoeud(max,-100,100,BoardInit,_,-100)),
                                    write('Bug1.5'),exploMiniMax(PossibleMoveList,Player,2,BoardInit),
									write('Bug1.6'),findall((Board,H),idNoeud(_,_,_,BoardInit,Board,H),L),
									write('Bug1.7'),meilleurBoard(0,L,BestBoard),!,nl,affiche(BestBoard),nl,
									write('Bug1.8'),findall(Board,idNoeud(_,_,_,BoardInit,Board,_),ListeIdNoeud).
									
									/*write('Bug1.9'),tupleBoardMove(PossibleMoveList,ListeIdNoeud,[],ListeTuples),
									write('Bug1.10'),element((BestMove,BestBoard),ListeTuples),
									
									write('Bug11'),retractall(miniMaxPion(_,_,_,_,_)).*/
									
meilleurBoard(Max,[(Board,H)|L],B) :- H>Max, H is Max, B is Board, meilleurBoard(Max,L,B).
meilleurBoard(Max,[_|L],B) :- meilleurBoard(Max,L,B).
meilleurBoard(_,[],_).

tupleBoardMove([Move|Q],[T|(_,_,_,_,Board,_)],L1,L3):- append([(Move,Board)],L1,L2),tupleBoardMove(Q,T,L2,L3).
tupleBoardMove([],[],L,L).



  recopiagePions([(IdPion,Col,Lin,Etat,Marq)|Q]) :- asserta(miniMaxPion(IdPion,Col,Lin,Etat,Marq)),recopiagePions(Q).
  recopiagePions([]).

/*Cas1: Si on atteint une feuille  */
miniMax(Player, 0,InBoard,Board) :-
												write('Bug6.1'),heuristic(Board, Player, Heuristique),
												write('Bug6.2'),modifNoeud(InBoard,Board,Heuristique).
												

												
/*Cas2 si on atteint un noeud*/										
miniMax(Player,Strate,InBoard,Board) :-            
											 write('Bug5.2'),possibleMovesMiniMax(Board,Player,List),
											 write('Bug5.3'),sort(List,PossibleMoveList),
											 write('Bug5.4'),exploMiniMax(PossibleMoveList,Player,Strate,Board),
											 write('Bugdelamort'), idNoeud(_,_,_,Board,_,Value),
											 write('Bug5.5'),modifNoeud(InBoard,Board,Value).
											 

modifNoeud(InBoard,Board,H):- idNoeud(MinOuMax,Alpha,Beta,InBoard,Board,_),H>Alpha,retract(idNoeud(MinOuMax,Alpha,Beta,InBoard,Board,_)),
													  asserta(idNoeud(MinOuMax,Alpha,Beta,InBoard,Board,H)).
modifNoeud(_,_,_,_).




initNoeud(min,Alpha,Beta,InBoard,NewBoard):- write('Bug3.1'),idNoeud(_,Alpha,Beta,_,InBoard,_),
													 write('Bug3.2'),asserta(idNoeud(min,Alpha,Beta,InBoard,NewBoard,Beta)).
initNoeud(max,Alpha,Beta,InBoard,NewBoard):- write('Bug3.3'),idNoeud(_,Alpha,Beta,_,InBoard,_),write('Bug3.4'),asserta(idNoeud(max,Alpha,Beta,InBoard,NewBoard,Alpha)).

enregistrement(ListeEnregistrement):- findall((IdPion,Col,Lin,Etat,Marq),miniMaxPion(IdPion,Col,Lin,Etat,Marq),ListeEnregistrement).

exploMiniMax([(Col1,Lin1,Col2,Lin2)|Res],Player,Strate,InBoard) :-    			Strate>=0,
																				write('Bug2.findall'),findall((IdPion,Col,Lin,Etat,Marq),miniMaxPion(IdPion,Col,Lin,Etat,Marq),ListePions),
																				write('Bug2.0'),idNoeud(MinOuMax,Alpha,Beta,_,InBoard,Value),
																				write('Bug2.1'),Value<Beta,
																				write('Bug2.2'),miniMaxPion(Pion,Col1,Lin1,_,_),!,
																				write('Bug2.3'),transfertMiniMax(InBoard,(Col1,Lin1,Col2,Lin2),Pion,OutBoard),
																				
																				write('Bug2.5'),opposeMinMax(MinOuMax,Oppose),
																				write('Bug2.6'),initNoeud(Oppose,Alpha,Beta,InBoard,OutBoard),
																				write('Bug2.7'), print(Strate),NewStrate is Strate-1,
																				
																				write('Bug2.8'),miniMax(Player,NewStrate,InBoard,OutBoard),
																				write('Bug2.9'),retractall(miniMaxPion(_,_,_,_,_)),
																				write('Bug2.10'),recopiagePions(ListePions),
																				write('Bug2.11'),exploMiniMax(Res,Player,Strate,InBoard).
																				

																				
exploMiniMax([(Col1,Lin1,Col2,Lin2)|_],Player,Strate,InBoard) :-  				
																				write('Bug4.1'),miniMaxPion(Pion,Col1,Lin1,_,_),
																				write('Bug4.2'),transfertMiniMax(InBoard,(Col1,Lin1,Col2,Lin2),Pion,OutBoard),!,
																				write('Bug4.3'),idNoeud(MinOuMax,Alpha,Beta,_,InBoard,_),
																				write('Bug4.4'),opposeMinMax(MinOuMax,Oppose),
																				write('Bug4.5'),initNoeud(Oppose,Alpha,Beta,InBoard,OutBoard),
																				write('Bug4.6'),NewStrate is Strate-1,
																				write('Bug4.findall'),findall((IdPion,Col,Lin,Etat,Marq),miniMaxPion(IdPion,Col,Lin,Etat,Marq),ListePions),
																				write('Bug4.7'),miniMax(Player,NewStrate,InBoard,OutBoard),
																				write('Bug4.8'),recopiagePions(ListePions).
exploMiniMax([],_,_,_).

opposeMinMax(min,max).
opposeMinMax(max,min).