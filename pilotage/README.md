# Pilote : piloter des sessions Claude depuis Claude Desktop

À donner aux autres : [kit/Pilote.zip](kit/Pilote.zip), un dossier avec le plugin, un LISEZ-MOI et le tutoriel.
Tutoriel : [TUTORIEL.md](TUTORIEL.md). Preuves brutes : [PREUVES.md](PREUVES.md).

## Ce qui marche (testé le 2026-11-08, sans clic)

| Geste Herdr | Ce qu'on dit à Claude | Preuve |
|---|---|---|
| Nouvel agent | « Lance un agent qui… » | 2 agents en parallèle : haïku + liste de courses reçus |
| Board | « Où on en est ? » | tableau Agent · État · Ce qu'il attend |
| Taper dans un agent | « Dis à X de… » | 2e haïku écrit sur demande |
| L'agent te prévient | rien, il écrit tout seul | messages reçus sans clic |
| Interrompre | « Arrête X » | travail coupé au paragraphe 1/3 |
| /clear d'un agent | « Repars de zéro avec X » | le nouvel agent ne connaît que le point d'étape |
| Relancer | « Relance X » | « Avant l'interruption : paragraphe 1/3 écrit… » |
| Fermer | « Ferme tout » | toutes les sessions archivées |
| Projet GitHub | « Lance un agent sur github.com/… » | fichier du repo lu, mot de contrôle renvoyé |
| Voir dans Desktop | barre latérale | agents rangés sous la session (vu par Mirko) |

## Deux modes, choisis tout seuls

| | Mode cloud | Mode local (tmux ou Herdr) |
|---|---|---|
| Quand | session cloud de Desktop | session locale de Desktop, sur le Mac |
| Fichiers du Mac | non, il faut un repo GitHub | oui |
| Fichiers entre agents | non, chacun son espace | oui, même disque |
| `/clear` d'un agent | « Repars de zéro » (nouvel agent) | vrai `/clear`, tapé dans son terminal |
| `/clear` de soi | non | oui si Pilote tourne dans tmux ou Herdr ; non dans la fenêtre Desktop |
| Agents dans la barre Desktop | oui | non, ils sont dans tmux ou Herdr |
| Testé | oui, 100 % | tmux : oui, 100 % · Herdr : commandes reprises de tes mods, pas lancées ici |

## Ce qui ne marche pas

| Geste | Pourquoi |
|---|---|
| `/clear` de Pilote dans la fenêtre Desktop | elle n'est pas un terminal : ouvrir une nouvelle session |
| Mode Herdr testé ici | herdr.dev bloqué par le réseau du cloud, compilation refusée par le classifieur |

## Fichiers

- `plugin/pilote/` : le plugin (une skill). `plugin/build.sh` refait `plugin/pilote.zip`.
- `kit/Pilote/` : le dossier à distribuer. `kit/Pilote.zip` : le même, zippé.
- `PROMPT.md` : la version à coller, pour qui ne veut pas installer de plugin.
