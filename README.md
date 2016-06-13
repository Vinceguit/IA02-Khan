# Khan (jeu)

Ce projet est un jeu de Khan disposant d'une IA permettant des parties humain-humain, humain-machine et machine-machine; il s'inscrit dans le cadre de l'UV IA02 de l'Université de Technologie de Compiègne.

##Présentation et règles du jeu

Le Khan est un jeu de type abstrait. Il est composé d'un plateau de 6x6 cases; chaque case possède une valeur de 1 à 3.

Lors du début de partie, le premier joueur choisit le côté du plateau (2 lignes les plus proches d'un côté) sur lequel il souhaite commencer, puis place sa Kalista (reine) et ses pions (sbires) sur son côté; son adversaire fait de même sur le côté opposé.

Le but du jeu est de capturer la Kalista adverse en respectant les règles suivantes :
* Chaque pièce jouée doit se déplacer d'un nombre de cases égal à la valeur de la case de départ.
*  Le joueur ne peut déplacer une pièce sur une case où il en possède déjà une autre; de plus, un mouvement ne peut s'effectuer en passant par-dessus une pièce.
*  La capture d'une pièce adverse s'effectue en déplaçant une  pièce sur la case où se situe la pièce adverse.
*  Une fois une pièce jouée, celle-ci est coiffée d'une pièce appelée Khan; l'adversaire, lors de son coup suivant, sera alors obligé de déplacer une pièce se situant sur une case de même valeur que le Khan.
*  Lors du premier coup, le premier joueur peut déplacer la pièce qu'il souhaite, vu que le Khan n'est pas encore en jeu.
*  Si aucun pion ne respecte la contrainte du Khan, ou si les pions la respectant ne peuvent pas se déplacer, le joueur peut alors soit déplacer le sbire qu'il souhaite, soit remettre un sbire capturé en jeu sur une case de même valeur que le Khan, auquel cas il ne pourra pas se déplacer durant ce tour.

##Prédicats

###library.pl
Prédicat | Action
-------- | --------
`element(Element, List)` | S'efface si `Element` est un élément de la liste `List`
`longueur(Long, List)` | Renvoie la longueur de la liste `List` dans `Long`
`retireElement(Element, ListIn, ListOut)` | Retire la première occurrence de `Element` dans la liste `ListeIn`, et renvoie le résultat dans `ListOut`
`findColour(IdPion, Colour)` | Renvoie la couleur (rouge ou ocre) du pion `IdPion` dans `Colour`
`setKhan(IdPion)` | Change le statut `Status` de `pion(IdPion, Col, Lin, Status, IdCase)` de `in` à `khan`
`remplacer(InBoard, Lin, Col, IdPion, IdCase, OutBoard)`| Place le pion `IdPion` à la ligne `Lin` et à la colonne `Col` du plateau `InBoard`, et renvoie l'indice de la case correspondante `IdCase`, ainsi que le plateau édité `OutBoard`

###coord_parser.pl
Prédicat | Action
-------- | --------
`parse(Coord,Col,Lin)` | Convertit une coordonnée saisie sous la forme 'LettreChiffre' en position sur le plateau (Col : colonne, Lin : ligne); si mauvaise saisie utilisateur, renvoie la coordonnée (0, 0)

###display.pl
Prédicat | Action
-------- | --------
`afficherPlateau(Board)` | Affiche le plateau Board dans la console

###main.pl
```prolog
	initBoard(Board).
```
Ce prédicat retourne en paramètre le plateau de jeu initialisé, sous forme de liste de ligne [L1, ..., L6], chaque ligne étant une liste de tuples `[(Indice1, Type1), ..., (Indice6, Type6)]` contenant l'indice de la case (de 1 à 3) et le type de pion sur cette case (`b` = case blanche, `kr` = Kalista rouge, `ko` = Kalista ocre, `r1` à `r5` = sbires rouges, `o1` à `o5` = sbires ocres).

Lors de l'appel d'`initBoard(Board)`, chaque pion est généré dynamiquement  sous la forme d'un prédicat  
```prolog
	pion(IdPion, Col, Lin, Status, IdCase).
```
où `IdPion` est l'identifiant unique du pion, `Col` et `Lin` sa position sur le plateau, `Status` son statut (`in` s'il est en jeu; `khan` s'il porte le Khan; `out` s'il est hors-jeu), et `IdCase` l'indice de la case sur lequel il se trouve (1, 2 ou 3).

###Dossier init
####Initialisation des joueurs
```prolog
	initPlayers.
```
Ce prédicat retire tous les prédicats `player(Colour, TypePlayer)` éventuellement définis lors d'une précédente exécution. Il demande ensuite à l'utilisateur d'entrer le type de chaque joueur `TypePlayer` (`humain` ou `machine`), pour ensuite déclarer le prédicat `player(Colour, TypePlayer)` pour chaque joueur.

####Initialisation des côtés
```prolog
	lireCote(Cote)
```

```prolog
	randomCote(Cote)
```

####Placement des pions pour un humain

####Placement des pions pour une machine

###Dossier moves
####Liste des mouvements possibles
```prolog
	possibleMoves(Board, Player, PossibleMoveList)
```

####Détermination du meilleur mouvement possible (Intelligence artificielle)
```prolog
	generateMove(Board, Player, Move)
```

###Dossier turn
####Tour de jeu principal

####Côté humain

####Côté machine

##Déroulement du jeu

Le lancement du jeu s'effectue à l'aide de la commande `play.`.

###Initialisation

Tout d'abord, on demande à l'utilisateur quel type il souhaite affecter à chaque joueur (`humain.` ou `machine.`).

On affiche ensuite le plateau vide, afin de permettre à l'utilisateur de visualiser ce dernier.

Le joueur rouge choisit le côté du plateau sur lequel il souhaite commencer; si c'est une machine, on choisit le côté aléatoirement. Si c'est un humain, on lui demande de saisir le côté qu'il souhaite (`gauche.`, `droite.`, `haut.`, `bas.`).

Ensuite, chaque joueur doit placer ses pièces sur le plateau; si c'est une machine, on place les pièces automatiquement de manière aléatoire.

Si le joueur est un humain, on demande à l'utilisateur la coordonnée sur laquelle il souhaite placer un pion pour la kalista et les 5 sbires. Les coordonnées vont de `'A1'.` à `'F6.'`. Si la case saisie est déjà occupée par un autre pion ou si elle ne se situe pas du bon côté, un message d'erreur s'affiche et l'utilisateur doit rentrer à nouveau la coordonnée de cette pièce.

A chaque placement de pion pour le joueur, et à la fin de l'initialisation pour la machine, on affiche l'état du plateau.

###Boucle principale (A reformuler)

Savoir où est le Khan

Si tour 1, pas de Khan la pièce est jouée librement
Si tour > 1, le nombre de mouvement est déterminée par la position du Khan

Determiner quelles pièces ont le droit de bouger ?

	Si tour 1, toutes les pièces rouge peuvent bouger
	Sinon, on liste les mouvements des pièces sur des cases similaires au Khan, puis on élague les mouvements dispo, puis les pièces dispo.

prédicat blocage()

	Si vrai : pas de mouvement possible en prenant en compte le Khan.
On joue une autre pièce : on récupère les mvts possibles des pièces sur des cases non similaires au Khan, puis on élague les mvts dispos, puis les pièces dispos.
OU
On remet une pièce en jeu sur une case similaire au Khan

Si pas de remise en jeu : choix de la pièce et du mouvement (Proposition des choix possibles)

Il faut sélectionner la pièce → affichage des mouvements possibles pour la pièce
Si on change de pièce, il faut désafficher les positions et afficher les nouvelles

Sinon : choix de la case

Prise d’une pièce

Possible si nbMoves(1) et si la pièce est une pièce adverse
Il doit y avoir suppression de la pièce adverse, son indice in doit passer en out

Y-a-t-il victoire ? (vrai si pièce prise & pièce est Kalista)

Il ne sera pas nécéssaire de scanner toutes les pièces hors du jeu mais seulement la pièce qui vient d’être sortie
Si la pièce est prise, on peut passer à l’annonce de victoire

Placement du Khan sur la pièce jouée (si pas de victoire et pas de blocage de mvt par le Khan à l’étape 3)

###Fin de jeu

Dès que l'une des deux Kalistas est prise, on sort de la boucle principale et on renvoie le joueur qui a pris la Kalista dans un prédicat `winner(Colour, TypePlayer)`, où `Colour` est le joueur (rouge/ocre) et `TypePlayer` son type (humain ou machine). On récupère alors le gagnant dans le prédicat `play` pour l'afficher, puis l'exécution se termine.
