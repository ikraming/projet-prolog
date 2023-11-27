
addh([H, M], Minutes, [NH, NM]) :-
    TotalMinutes is H * 60 + M + Minutes,
    NH is TotalMinutes // 60 mod 24,
    NM is TotalMinutes mod 60.


affiche([H, M]) :-
    format('~`0t~d~2|~`0t~d~2|', [H, M]).


lig(Arret1, Arret2, Ligne) :-
    ligne(Ligne, _, Arrets, _, _),
    member([Arret1, _], Arrets),
    member([Arret2, _], Arrets),
    nth0(Index1, Arrets, [Arret1, _]),
    nth0(Index2, Arrets, [Arret2, _]),
    Index1 < Index2.


ligtot(Arret1, Arret2, Nom, [HR, MR]):-
    lig(Arret1, Arret2, Nom),
    ligne(Nom, _, _, [[HD,MD], Intervalle, [HA,MA]], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE  is HR *60 +MR,

    write(TEMPSDONNE),nl,
    write(TEMPSDEPART),nl,
    (TEMPSDONNE < TEMPSDEPART ->
       true

    ;

        false
    ).



ligtard(Arret1, Arret2, Nom, [HR, MR]):-
    lig(Arret1, Arret2, Nom),
    ligne(Nom, _, _, [[HD,MD], Intervalle, [HA,MA]], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE  is HR *60 +MR,
    TEMPSARRET  is HA *60 + MA,
    write(TEMPSDONNE),nl,
    write(TEMPSDEPART),nl,
    (TEMPSDONNE > TEMPSDEPART, TEMPSDEPART > TEMPSARRET  ->
       S =TEMPSDONNE - Intervalle,
       S >=TEMPSDEPART

    ;

        true
    ).





itinTot(Arret1, Arret2, [HR, MR], Parcours) :-
    ligtot(Arret1, Arret2, Nom, [HR, MR]),
    ligne(Nom, _, LArrets, [[HD, MD], _, _], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE is HR * 60 + MR,

    % Obtenir la liste des arrêts entre Arret1 et Arret2
    trouverArrets(LArrets, Arret1, Arret2, ListeArrets),

    % Calculer le parcours (nom des arrêts) entre Arret1 et Arret2
    maplist(nth1(1), ListeArrets, ParcoursNoms),

    % Vérifier si l'horaire donné est avant l'heure de départ la plus tôt
    (TEMPSDONNE < TEMPSDEPART ->
        Parcours = ParcoursNoms
    ;
        % Sinon, échouer
        false
    ).




% Prédicat pour calculer la somme des intervalles entre deux arrêts
sommeIntervalle(Ligne, Arret1, Arret2, Resultat) :-
    % Récupérer les détails de la ligne
    ligne(Ligne, _, LArret, [[_, _], Intervalle, _], _),

    % Trouver la liste des arrêts entre Arret1 et Arret2
    trouverArrets(LArret, Arret1, Arret2, Arrivees),

    % Extraire les intervalles entre les arrêts
    maplist(nth1(2), Arrivees, IntervalleArrivees),
    sumlist(IntervalleArrivees, SommeEnMinutes),
    Heures is SommeEnMinutes // 60,
    Minutes is SommeEnMinutes mod 60,


    Resultat = [Heures, Minutes].

% Prédicat pour trouver la liste des arrêts entre Arret1 et Arret2
trouverArrets(ListeArrets, Arret1, Arret2, Arrivees) :-
    append(_, [[Arret1, _] | Arrivees], ListeArrets),
    member([Arret2, _], Arrivees).


itinTard(Arret1, Arret2, horaire, Parcours):-

    ligne(Nom, _, _, [[HDep, MDep], Intervalle, _], _),

    % Calculer la somme des intervalles entre Arret1 et Arret2
    sommeIntervalle(Nom, Arret1, Arret2, Resultat),

    % Calculer le temps de départ et d'arrivée
    HeuresDepart is HDep,
    MinutesDepart is MDep,
    TEMPSDEPART_TOTAL is HeuresDepart * 60 + MinutesDepart,

    % Convertir le temps de départ en forme [h, m]
    TEMPSDEPART = [div(TEMPSDEPART_TOTAL, 60), mod(TEMPSDEPART_TOTAL, 60)],

    TEMPSARRIVEE_TOTAL is TEMPSDEPART_TOTAL + Resultat,

    % Convertir le temps d'arrivée total en forme [h, m]
    TEMPSARRIVEE = [div(TEMPSARRIVEE_TOTAL, 60), mod(TEMPSARRIVEE_TOTAL, 60)],

    % Convertir le temps donné en forme [h, m]
    TEMPSDONNE = [div(TEMPSDONNE, 60), mod(TEMPSDONNE, 60)],
    write(TEMPSDONNE),nl,
    write(TEMPSARRIVEE_TOTAL ),nl,


    (TEMPSDONNE > TEMPSARRIVEE ->
        true
    ;
        % Sinon, échouer
        false
    ).

%exo4
% Mettre à jour les prédicats pour prendre en compte les options
ligtot1(Arret1, Arret2, Nom, [HR, MR], Options) :-
    % Extraire les options
    member(reseau(Reseau), Options),
    member(prefLongueur(PrefLongueur), Options),
    member(prefCorrespondances(PrefCorrespondances), Options),

    % Ajouter la logique pour vérifier le réseau, la longueur du trajet et le nombre de correspondances

    lig(Arret1, Arret2, Nom),
    ligne(Nom, _, _, [[HD,MD], Intervalle, [HA,MA]], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE  is HR *60 +MR,

    write(TEMPSDONNE),nl,
    write(TEMPSDEPART),nl,
    (TEMPSDONNE < TEMPSDEPART ->
       true

    ;

        false
    ).

ligtard1(Arret1, Arret2, Nom, [HR, MR], Options) :-
    % Extraire les options
    member(reseau(Reseau), Options),
    member(prefLongueur(PrefLongueur), Options),
    member(prefCorrespondances(PrefCorrespondances), Options),

    % Ajouter la logique pour vérifier le réseau, la longueur du trajet et le nombre de correspondances

    lig(Arret1, Arret2, Nom),
    ligne(Nom, _, _, [[HD,MD], Intervalle, [HA,MA]], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE  is HR *60 +MR,
    TEMPSARRET  is HA *60 + MA,
    write(TEMPSDONNE),nl,
    write(TEMPSDEPART),nl,
    (TEMPSDONNE > TEMPSDEPART, TEMPSDEPART > TEMPSARRET  ->
       S =TEMPSDONNE - Intervalle,
       S >=TEMPSDEPART

    ;

        true
    ).

itinTot1(Arret1, Arret2, [HR, MR], Parcours, Options) :-
    % Extraire les options
    member(reseau(Reseau), Options),
    member(prefLongueur(PrefLongueur), Options),
    member(prefCorrespondances(PrefCorrespondances), Options),

    % Ajouter la logique pour vérifier le réseau, la longueur du trajet et le nombre de correspondances

    ligtot1(Arret1, Arret2, Nom, [HR, MR], Options),
    ligne(Nom, _, LArrets, [[HD, MD], _, _], _),
    TEMPSDEPART is HD * 60 + MD,
    TEMPSDONNE is HR * 60 + MR,

    % Obtenir la liste des arrêts entre Arret1 et Arret2
    trouverArrets(LArrets, Arret1, Arret2, ListeArrets),

    % Calculer le parcours (nom des arrêts) entre Arret1 et Arret2
    maplist(nth1(1), ListeArrets, ParcoursNoms),

    % Vérifier si l'horaire donné est avant l'heure de départ la plus tôt
    (TEMPSDONNE < TEMPSDEPART ->
        Parcours = ParcoursNoms
    ;
        % Sinon, échouer
        false
    ).

itinTard1(Arret1, Arret2, horaire, Parcours, Options) :-
    % Extraire les options
    member(reseau(Reseau), Options),
    member(prefLongueur(PrefLongueur), Options),
    member(prefCorrespondances(PrefCorrespondances), Options),

    % Ajouter la logique pour vérifier le réseau, la longueur du trajet et le nombre de correspondances

    ligne(Nom, _, _, [[HDep, MDep], Intervalle, _], _),

    % Calculer la somme des intervalles entre Arret1 et Arret2
    sommeIntervalle(Nom, Arret1, Arret2, Resultat),

    % Calculer le temps de départ et d'arrivée
    HeuresDepart is HDep,
    MinutesDepart is MDep,
    TEMPSDEPART_TOTAL is HeuresDepart * 60 + MinutesDepart,

    % Convertir le temps de départ en forme [h, m]
    TEMPSDEPART = [div(TEMPSDEPART_TOTAL, 60), mod(TEMPSDEPART_TOTAL, 60)],

    TEMPSARRIVEE_TOTAL is TEMPSDEPART_TOTAL + Resultat,

    % Convertir le temps d'arrivée total en forme [h, m]
    TEMPSARRIVEE = [div(TEMPSARRIVEE_TOTAL, 60), mod(TEMPSARRIVEE_TOTAL, 60)],

    % Convertir le temps donné en forme [h, m]
    TEMPSDONNE = [div(TEMPSDONNE, 60), mod(TEMPSDONNE, 60)],
    write(TEMPSDONNE),nl,
    write(TEMPSARRIVEE_TOTAL ),nl,

    % Vérifier si le temps donné est inférieur au temps d'arrivée
    (TEMPSDONNE > TEMPSARRIVEE ->
        Parcours = ParcoursNoms
    ;
        % Sinon, échouer
        false
    ).
% exo5

% Exemple d'interface utilisateur
interface_utilisateur :-
    writeln("Stations desservies par les transports publics :"),
    writeln("[station1, station2, station3, ...]"),
    nl,
    write("Choisissez une station de départ : "),
    read(StationDepart),
    write("Choisissez une station d'arrivée : "),
    read(StationArrivee),
    write("Choisissez le type de réseau (metro, bus, train) : "),
    read(TypeReseau),
    write("Préférence par rapport à la longueur du trajet (court, normal, long) : "),
    read(PreferenceLongueur),
    write("Nombre de correspondances maximal : "),
    read(NbCorrespondances),
    % Appel du prédicat parcours_possibles avec les paramètres choisis par l'utilisateur
    parcours_possibles(StationDepart, StationArrivee, TypeReseau, PreferenceLongueur, NbCorrespondances).

% prédicat pour afficher un itinéraire
afficher_itineraire([[Arret1, HoraireDebut], [Arret2, HoraireFin]]) :-
    write(Arret1),
    write(" à "),
    affiche(HoraireDebut),
    write(" -> "),
    write(Arret2),

    write(" à "),
    affiche(HoraireFin).

ligne(11, metro, [
                   [mairie_lilas, 0],
                   [porte_lilas, 3],
                   [telegraphe,1],
                   [place_fetes,1],
                   [jourdain, 1],
                   [pyrenees, 1],
                   [belleville, 2],
                   [goncourt, 2],
                   [republique, 3],
                   [arts_metiers, 2],
                   [rambuteau, 1],
                   [hotel_de_ville, 1],
                   [chatelet, 1]
                   ], [[5,15],5,[1,30]], [[5,0],5,[2,0]]
).
ligne(2, metro, [
		 [nation, 0],
		 [avron, 1],
		 [alexandre_dumas,2],
		 [philippe_auguste,1],
		 [pere_lachaise,2],
		 [menilmontant,2],
		 [couronnes,1],
		 [belleville,2],
		 [colonel_fabien,1],
		 [jaures,1],
		 [stalingrad,2],
		 [la_chapelle,1],
		 [barbes_rochechouart,3],
		 [anvers,2],
		 [pigalle,1],
		 [blanche,2],
		 [place_clichy,3],
		 [rome,2],
		 [villiers,3],
		 [monceau,2],
		 [courcelles,2],
		 [ternes,3],
		 [charles_de_gaulle_etoile,3],
		 [victor_hugo,2],
		 [porte_dauphine,3]
		 ], [[5,0],2,[1,45]], [[5,15],2,[1,55]]
).

ligne(3, metro, [
		 [pont_levallois_becon,0],
		 [anatole_france,2],
		 [louise_michel,3],
		 [porte_de_champerret,2],
		 [pereire,2],
		 [wagram,2],
		 [malesherbes,3],
		 [villiers,2],
		 [europe,3],
		 [saint_lazare,4],
		 [havre_caumartin,2],
		 [opera,3],
		 [quatre_septembre,3],
		 [bourse,2],
		 [sentier,3],
		 [reaumur_sebastopol,3],
		 [arts_metiers,3],
		 [temple,2],
		 [republique,3],
		 [parmentier,2],
		 [rue_saint_maur,3],
		 [pere_lachaise,4],
		 [gambetta,2],
		 [porte_de_bagnolet,3],
		 [gallieni,3]
		 ], [[5,35],4,[0,20]], [[5,30],4,[0,20]]
).

ligne(bis_3, metro, [
		    [porte_lilas,0],
		    [saint_fargeau,2],
		    [pelleport,1],
		    [gambetta, 2]
		    ], [[6,0],7,[23,45]], [[6,10],7,[23,55]]
).

ligne(5, metro, [
		 [bobigny_pablo_picasso, 0],
		 [bobigny_pantin, 2],
		 [eglise_de_pantin, 3],
		 [hoche,4],
		 [porte_pantin,3],
		 [ourcq,4],
		 [laumiere,3],
		 [jaures,3],
		 [stalingrad,2],
		 [gare_du_nord,3],
		 [gare_de_est,1],
		 [jacques_bonsergent,2],
		 [republique,3],
		 [oberkampf,2],
		 [richard_lenoir,2],
		 [breguet_sabin,2],
		 [bastille,2],
		 [quai_de_la_rapee,3],
		 [gare_austerlitz,2],
		 [saint_marcel,3],
		 [campo_formio,2],
		 [place_italie,3]
		], [[5,24],3,[1,20]], [[5,30],3,[1,0]]
).

ligne(bis_7, metro, [
		    [pre_saint_gervais,0],
		    [place_fetes, 3],
		    [danube, 0],
		    [bolivar, 2],
		    [buttes_chaumont, 2],
		    [botzaris, 2],
		    [jaures, 3],
		    [louis_blanc,2]
		    ], [[5,35],8,[0,0]], [[5,50],8,[23,45]]
).




