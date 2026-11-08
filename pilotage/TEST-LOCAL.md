Test de pilotage en session locale Claude Code Desktop (sur le Mac). Tu ne crois rien sur parole : tu exécutes, tu lis la sortie, tu notes l'erreur exacte et tu passes à la suite.

Règles : tu ne touches que les sessions que tu crées, toutes nommées test-pilote-*. Tu travailles dans /tmp/test-pilote. Pas d'outil pour une étape = KO.

0. Inventaire : `claude --version`, `which claude hc herdr-projects`. ToolSearch « session », « agent », « message », « archive » : note le nom exact de chaque outil trouvé. `mkdir -p /tmp/test-pilote && cd /tmp/test-pilote && git init -q`.
1. Créer : `claude --bg --name test-pilote-a --permission-mode auto "Dans /tmp/test-pilote, écris ok.txt contenant UN, puis attends."` OK si `claude agents --json` la montre et si ok.txt contient UN.
2. Lire : `claude logs test-pilote-a`.
3. Écrire : ListAgents, puis SendMessage à test-pilote-a « Ajoute DEUX à ok.txt et renvoie-moi son contenu avec SendMessage. » OK si ok.txt contient DEUX, et note si tu reçois sa réponse.
4. Sessions Desktop : avec les outils natifs de Desktop (lister, lire, écrire, renommer, archiver les sessions de l'onglet Code), liste les sessions. Note si test-pilote-a y apparaît.
5. Ouvrir dans Desktop : `claude --desktop --resume <id de test-pilote-a>`. Demande-moi si elle s'est ouverte.
6. /clear : `claude stop test-pilote-a`, puis `claude --bg --name test-pilote-b --permission-mode auto "Lis /tmp/test-pilote/ok.txt. Que sais-tu de la conversation précédente ?"` OK si b connaît ok.txt mais pas la conversation de a.
7. Relancer : `claude stop test-pilote-b`, `claude respawn test-pilote-b`, puis SendMessage « Qu'as-tu fait avant ce redémarrage ? ».
8. Arsenal : `claude --bg --name test-pilote-c --permission-mode auto "/next:next"`, puis `claude logs test-pilote-c`. OK si on voit la sortie de next.
9. Herdr : `hc ls` et `herdr-projects list`.
10. Fermer : `claude stop` puis `claude rm` sur chaque test-pilote-*. OK si `claude agents --json --all` n'en montre plus.

Écris le rapport dans /tmp/test-pilote/RAPPORT.md : un tableau étape · OK/KO · commande ou outil · sortie clé (1 ligne). Puis montre-le-moi.
