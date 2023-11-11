# Les centrales nucléaires dans le monde depuis 1960

## Introduction

Dans le jeu de données que nous allons analyser, les informations fournies concernent les centrales nucléaires répertoriées dans le monde. Les données proviennent d'un github et sont par conséquent déjà bien formées, même si bien sur il reste des transformations à faire. Les données disponible pour chaque observation sont:

| Donnée | Description |
| ------ | ------ |
| Id | Le numéro de l'entrée |
| Name | Le nom du réacteur |
| Latitude | Coordonnées du réacteur |
| Longitude | Coordonnées du réacteur |
| Country | Pays |
| Status | état de fonctionnement du réacteur |
| ReactorType | type de réacteur |
| ReactorModel | nom du model de réacteur |
| ConstructionStartAt | date du début de construction |
| OperationalFrom | date de début de fonctionnement |
| OperationalTo | date de fin de fonctionnement |
| Capacity | Capacité du réacteur en MWe |
| LastUpdatedAt | date de mis à jour de l'information |
| Source | source de l'information |

 Les données proviennent de [kaggle ](https://www.kaggle.com/datasets/marchman/geo-nuclear-data).

# User Guide

Pour utiliser ce dashboard, il vous faudra tout d'abord cloner le dépôt Git sur sa machine. Pour cela, vous devez avant toute chose installer le package `git2r` et l'importer:

```sh
>install.packages("git2r")
>library(git2r)
```

Vous devez ensuite désigner le dossier où vous souhaiter cloner le répertoire:

```sh
>destination_directory <- "chemin/vers/votre/répertoire"
```

Ainsi que désigner le dépôt Git avec la commande :
```sh
>repo_url <- "https://github.com/brieuc060303/R"
```

Vous pouvez désormais cloner le dépôt avec la commande :
```sh
>git2r::clone(url = repo_url, local_path = destination_directory)
```

Pour lancer le projet, il vous suffit d'utiliser la commande:

```sh
>runApp()
```
Dans la console. Vous pouvez aussi démarrer le dashboard en cliquant sur **Run App** en haut à droite de l'éditeur de fichier sur RStudio.

##  Rapport d’analyse

#### "Reactors' capacity"
Dans l'onglet "Reactors' capacity", on peut observer la répartition de la capacité des réacteurs nucléaires en MWe. Les capacités vont de 0 à 1500 MWe. On remarque qu'il y a beaucoup de capacité proche de 0, cela correspond au reste des réacteurs qui ont été mis à l'arrêt. A part cela, la répartition est plutot uniforme, elle ne varie pas énormément.

#### "Reactor Types"
Sur le deuxième graphique, on remarque que la plupart des réacteurs dans le monde était de type PWR(Pressurized Water Reactor), puis viennent BWR(Boiling Water Reactor), GCR(Gas-Cooled Reactor), LWGR(Light Water Graphite Reactor) et PHWR(Pressurized Heavy Water Reactor).

#### "Reactor's Map"
Pour le troisième graphique, qui consiste en une carte des réacteurs, on peut distinguer les ou se situent les réacteurs en fonctionnement en fonction des années.
On peut lancer l'animation pour voir l'évolution du nombre de réacteurs et de leur position. On remarque que les réacteurs sont beaucoup situés dans les pays développés, comme l'Amérique du Nord, les pays d'Europe et des pays d'Asie comme le Japon.

#### "Operational Reactors"
Sur ce graphique, un histogramme, on peut observer le nombre de réacteurs nucléaires en fonctionnement par année. On peut aussi remarquer qu'après les incidents de Tchernobyl et de Fukushima, le nombre de réacteurs a considérablement diminué. Ce nombre était croissant donc jusqu'à 1986 puis décroissant depuis, a subit une autre croissance et a diminué après Fukushima. On observe que ce nombre augmente peu à peu depuis.

#### "Conclusion"
En somme, cette étude approfondie des attaques de requins met en lumière divers facteurs contribuant à ces incidents, allant des aspects comportementaux humains à la présence spécifique de certaines espèces de requins. Ainsi grâce à cette étude nous avons pu voir les activités les plus dangereuses en terme d'attaque de requins, les personnes les plus touchées et les endroits ou les attaques peuvent le plus avoir lieu. Les résultats de cette étude fournissent des informations cruciales pour guider les politiques de prévention et les mesures de sécurité en matière d'attaques de requins. Ces données peuvent être utilisées pour informer le développement de campagnes de sensibilisation ciblées, la mise en œuvre de réglementations spécifiques, et l'amélioration des pratiques de sécurité individuelle et collective. En comprenant mieux les dynamiques complexes entourant ces incidents, les autorités et les communautés peuvent travailler de concert pour minimiser les risques et assurer la sécurité des personnes engagées dans des activités maritimes. 

## Developer Guide

Nous observerons ici la structuration du projet. Le projet est structuré en 4 fichiers, respectivement `server.R`, `ui.R`, `global.R` et `app.R` que nous étudierons.

## server.R

C'est dans ce fichier qu'est géré le back end du dashboard. Il a en charge la préparation des données, et la construction des output correspondant aux interactions détectées sur l'ui. Il contient une seule fonction qui a deux paramètres:

- `input` est une référence vers les widgets d’entrée de l'`ui`.
- `output` est une référence vers les widgets d’affichage de l'`ui`.

Pour chaque onglet, il va définir ce qui doit être affiché. A chaque fois, on fera appel à une fonction placée dans `global.R` afin de créer les graphiques.

C'est aussi ici que l'on va vérifier les checkboxs sélectionnées pour la carte des réacteurs.

## ui.R

Dans ce fichier, nous gérons le front end du dashboard. Nous divisons le front end en 3 parties:

- `header`, stocké dans la variable head, représente le titre de la page, toujours affiché.
- `sidebar`, stocké dans la variable sideBar, qui affiche les onglets. On peut la déployer ou non, et si on souhaite créer un nouvel onglet, on doit le faire ici.
- `body`, stocké dans la variable body, est ce qui est affiché par les onglets. Une petite partie en CSS permet de rendre le dashboard plus beau, puis dans chaque **tabItem** on vient définir ce qui doit être affiché par chaque onglet, que ce soit un simple graphique ou une sidebar affichée en dessous. C'est aussi ici que l'on définit les input qui peuvent être utilisées pour modifier les graphiques.
 
Enfin, on combine ces trois parties avec `dashboardPage` afin de créer une structure de tableau de bord que l'on pourra utiliser comme composant de l'application Shiny.

## global.R

On retrouvera dans ce fichier les fonctions utilitaires (lecture des données, nettoyage, création des graphs, etc…). On observe donc:
- `import` qui aura pour but d'importer les packages nécessaires, qui lira les données du fichier .csv et effectuera un premier nettoyage.
- `capacityPlot` est la fonction qui permet de créer l'histogram des différentes capacités de réacteur.
- `reactorType` est la fonction qui permet de créer le bargraph des différents types de réacteurs.
- `createReactorMap` est la fonction qui permet de créer la carte des différents réacteurs. Elle prend en compte deux paramètres, **df** le data frame filtré et **selectedYear** l'année sélectionnée sur la slideBar. Cette fonction créé aussi une pallette de couleur et assigne une couleur a chaque type de réacteur, puis prend en compte les réacteurs actifs l'année selectionnée et les affiche sur la carte du monde à leur position.
- `Operational` est la fonction qui permet de créer l'histogramme du fonctionnement des réacteurs par année.

Enfin, on va utiliser la fonction `import()` et assigner le dataframe à une variable df.

## app.R

Ce fichier contient une unique instruction permettant de créer une application web Shiny complète en combinant l'interface utilisateur **ui** et la logique côté serveur **server**.