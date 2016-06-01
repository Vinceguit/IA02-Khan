# Khan

##Prédicats

###library.pl

Prédicat | Action
-------- | --------
`element(Element, List)` | S'efface si `Element` est un élément de la liste `List`
`longueur(Long, List)` | Renvoie la longueur de la liste `List` dans `Long`
`retireElement(Element, ListIn, ListOut)` | Retire la première occurrence de `Element` dans la liste `ListeIn`, et renvoie le résultat dans `ListOut`
`findColour(IdPion, Colour)` | Renvoie la couleur (rouge ou ocre) du pion `IdPion` dans `Colour`
`remplacer(InBoard, Lin, Col, IdPion, IdCase, OutBoard)`| Place le pion `IdPion` à la ligne `Lin` et à la colonne `Col` du plateau `InBoard`, et renvoie l'indice de la case correspondante `IdCase`, ainsi que le plateau édité `OutBoard`

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

####Initialisation des côtés
```prolog
	lireCote(Cote)
```

```prolog
	randomCote(Cote)
```

####

##Présentation
Création d'un jeu de Khan avec Intelligence Artificiellle dans le cadre de l'UV IA02 de la formation Informatique à l'Université de Technologie de Compiègne.
PROJET IA02 – Jeu de KHAN
Liste de nos prédicats

possibleMoves (Board, Player, PossibleMoveList)
initBoard(Board)
generateMove(Board, Player, Move)
estLeKhan(Pièce)
tourActif(Joueur)
position(X,Y,in/out, nmoves)
nbMoves(n) → Pourra être placé dans une fonction récursive pour décompter le nombre de mouvements restants, le dernier tour devra pouvoir autoriser de manger une pièce
eatPower(Board, Player, PossibleMoveList) → Booléen, permet de modifier la liste des actions possibles lors de la dernière action
kalistaVivante(Player,X,Y) → Permet de déterminer si la Kalista est toujours en jeu
caseOccupee(Board)


Organisation de notre programme

Initialisation

Choix : Humain-Humain pour l'instant
Placement des cases
Choix du côté par Rouge, des rotations de matrices peuvent du coup être nécéssaires
Initialisation des positions des pièces (je te propose de représenter la position des pièces par un tableau contenant des éléments de la forme ([X,Y,in/off, nbMoves]), sachant que le premier élément du tableau serait d'office la Kalista. En fin de tour, on checkera la victoire en regardant ce premier élément. La Kalista est jouée comme les autres pions.
Mise en surbrillance de la zone ou Rouge peut mettre ses pièces
Placement des pièces de Rouge, deux pièces ne peuvent pas être placées au même endroit, la Kalista doit être placée en première
Mise en surbrillance de la zone ou Ocre peut mettre ses pièces
Placement des pièces d’Ocre
Tour de jeu

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

Annonce de victoire
Récupération du nom du joueur
Récupération de la nature du joueur (Humain-Machine)

Le joueur peut, après délibération du conseil des ministres, engager la responsabilité
du  programmeur  devant  l'Assemblée  Des Professeurs Inoubliables d'IA02 (API-IA02) sur le
vote d'un  projet  de  loi  de  finances  ou  de  financement  de  la  congolexicomatisation
des lois du marché. Dans ce  cas,  ce  projet est considéré comme adopté, sauf si une
chanson de Maître Gims, déposée dans les vingt-quatre  heures  qui  suivent,  est  votée
dans  les  conditions  prévues  à  l'alinéa  précédent. Le  joueur  peut,  en  outre,
recourir  à  cette  procédure  pour  un  autre projet (ex. LO21) ou une proposition de
loi par session (sur tuxa).
