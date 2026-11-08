# Pilote : diriger plusieurs agents Claude depuis Claude Desktop

Pas de terminal. Tu parles à un Claude, il lance et dirige les autres pour toi.

## Installer (une fois, 1 minute)

1. Télécharge [pilote.zip](plugin/pilote.zip).
2. Dans Claude Desktop : **Customize > Plugins > Add > Upload plugin**, puis choisis `pilote.zip`.
3. Ouvre l'onglet **Code** et démarre une nouvelle session.

Tes agents apparaissent dans la barre latérale, rangés sous ta session.

## Exemple 1 : deux agents en parallèle

> /pilote Lance deux agents : « poème » qui écrit un haïku sur la mer, et « courses » qui écrit une liste de 5 courses.

Puis, quand tu veux :

> Où on en est ?

Claude répond par un tableau : agent · état (en cours, t'attend, fini) · ce qu'il attend de toi.

## Exemple 2 : parler à un agent

> Dis à « poème » d'écrire un deuxième haïku, sur la montagne.

L'agent fait le travail et Claude te résume sa réponse en une ligne.

## Exemple 3 : travailler sur un projet GitHub

> /pilote Lance un agent « relecture » sur github.com/moi/mon-site qui relit le README et liste les fautes.

## Exemple 4 : arrêter, repartir de zéro, relancer, fermer

> Arrête « courses ».

> Repars de zéro avec « relecture » : garde seulement ce qui est fait et ce qui reste.

> Relance « poème ».

> Ferme tout.

## Bon à savoir

- Les agents travaillent dans le cloud d'Anthropic, pas sur ton ordinateur. Pour un projet, il faut son lien GitHub.
- Chaque agent a son propre espace : un nouvel agent ne voit pas les fichiers d'un autre. Pour garder des fichiers, travaille sur un projet GitHub.
- Ils te préviennent tout seuls quand ils ont fini.
- Claude ne touche qu'aux agents qu'il a lancés lui-même.
