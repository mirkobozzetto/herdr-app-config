## Choisir le mode, au début

1. Si les outils `claude-code-remote` sont là (ToolSearch « create_session ») : **mode cloud**, plus bas.
2. Sinon, la session tourne sur l'ordinateur : **mode local**. Lance `command -v hc herdr tmux claude`.
   - `hc` présent (app Herdr) : utilise Herdr. Lance d'abord `hc --help` et vérifie la syntaxe.
   - sinon `tmux` et `claude` présents : utilise tmux.
   - sinon : dis à l'utilisateur qu'il faut tmux (`brew install tmux`) ou Herdr, ou passe en mode cloud.

## Mode local (tmux)

Chaque agent est une session tmux nommée `pilote-<nom>`, qui lance un vrai Claude dans le dossier de l'utilisateur.

| L'utilisateur dit | Tu fais |
|---|---|
| « Lance un agent qui… » | génère un uuid, puis `tmux new-session -d -s pilote-<nom> -x 160 -y 45 -c <dossier> "claude --session-id <uuid> --permission-mode acceptEdits"`. Attends 8 s, puis tape la tâche (voir « Lui écrire »). Note nom → uuid. |
| « Où on en est ? » | `ListAgents` : chaque agent apparaît avec busy / idle et son terminal tmux. Pour le détail : `tmux capture-pane -p -t pilote-<nom>`. |
| « Montre-moi ce qu'a fait X » | `tmux capture-pane -p -S -60 -t pilote-<nom>`, puis résume. |
| « Dis à X de… » | `SendMessage` au nom donné par ListAgents. Ou bien tape : `tmux send-keys -t pilote-<nom> -l "<texte>"`, puis, à part, `tmux send-keys -t pilote-<nom> Enter`. |
| « Arrête X » | `tmux send-keys -t pilote-<nom> Escape`. |
| « Repars de zéro avec X » | `tmux send-keys -t pilote-<nom> -l "/clear"`, puis Enter, à part. |
| « Relance X » | `tmux new-session -d -s pilote-<nom> -c <dossier> "claude --resume <uuid> --permission-mode acceptEdits"`. Jamais `--continue` : il reprend la mauvaise conversation. |
| « Ferme X » / « Ferme tout » | `tmux kill-session -t pilote-<nom>`, seulement pour tes sessions `pilote-*`. Jamais `tmux kill-server`. |
| « Vide-toi » (toi-même) | possible seulement si tu tournes toi-même dans tmux : lance en arrière-plan `(sleep 8; tmux send-keys -t "$TMUX_PANE" -l /clear; sleep 1; tmux send-keys -t "$TMUX_PANE" Enter) &` et termine ton tour. Dans l'app Desktop : propose une nouvelle session. |

Règles du mode local :
- Le texte et Enter partent toujours en deux `send-keys` séparés, sinon Claude ne valide pas.
- Pour qu'un agent te réponde de lui-même, demande-lui : « renvoie-moi le résultat avec SendMessage ».
- Si l'écran d'un agent montre une question (permission, dossier de confiance), montre-la à l'utilisateur et tape sa réponse.
- Les agents partagent le disque : ils voient les fichiers de l'utilisateur et ceux des autres agents.

## Mode local (Herdr)

Mêmes gestes, avec `hc` : `hc run --bg --keep --no-parent --cwd <dossier> --json` (nouveau terminal, renvoie son adresse), `hc ls --json` (tableau), `hc send <adresse> "<texte>"` (message), `hc keys <adresse> / c l e a r enter` (touches, pour /clear), `hc read <adresse> --lines 40` (lire), `hc kill <adresse>` (fermer). `hc send` n'exécute jamais une commande /, d'où `hc keys` pour /clear.

## Mode cloud


Tu pilotes pour l'utilisateur d'autres sessions Claude Code, avec les outils du serveur `claude-code-remote`. Charge-les d'abord avec ToolSearch : `select:mcp__claude-code-remote__create_session,mcp__claude-code-remote__send_message,mcp__claude-code-remote__list_sessions,mcp__claude-code-remote__get_session,mcp__claude-code-remote__list_events,mcp__claude-code-remote__interrupt_session,mcp__claude-code-remote__set_session_title,mcp__claude-code-remote__archive_session,mcp__claude-code-remote__unarchive_session`.

L'utilisateur ne tape aucune commande. Parle simplement : jamais d'identifiant, jamais de jargon.

### Gestes

| L'utilisateur dit | Tu fais |
|---|---|
| « Lance un agent qui… » | `create_session` : title court (le nom de l'agent), permission_mode « auto », tags [« pilote »], prompt = toute la tâche + « Quand c'est fini, envoie un résumé en 3 lignes à @parent avec send_message. » Pour un projet GitHub : ajoute `source_url`. |
| « Où on en est ? » | `list_sessions` (mine: true), garde seulement les sessions dont `parent_session_id` est ta session (`get_session` sans argument donne ton id). Tableau : Agent · État · Ce qu'il attend. États : WORKING = en cours, BLOCKED = t'attend, REVIEW_READY = à relire, COMPLETED = fini. |
| « Montre-moi ce qu'a fait X » | `list_events` avec kinds [« result »], puis résume. |
| « Dis à X de… » | `send_message` à X. |
| « Arrête X » | `interrupt_session`. |
| « Renomme X en Y » | `set_session_title`. |
| « Repars de zéro avec X » | demande à X un point d'étape (fait / reste à faire) envoyé à @parent, `archive_session` X, puis `create_session` d'un nouvel agent avec ce point d'étape dans son prompt. |
| « Relance X » | `unarchive_session` puis `send_message`. |
| « Ferme X » / « Ferme tout » | `archive_session`. |

### Règles

- Toujours permission_mode « auto » : sinon l'agent refuse tes messages et reste bloqué sur ses réponses.
- Toute la tâche va dans le prompt de création.
- Pour attendre un agent, termine ton tour : son message te réveille. Pas de sleep.
- Quand un agent t'écrit, résume son message à l'utilisateur en une ligne.
- Les agents tournent dans le cloud d'Anthropic : ils ne voient pas les fichiers de l'ordinateur. Pour travailler sur un projet, il faut son repo GitHub (`source_url`).
- Chaque agent a son propre espace : un nouvel agent ne voit pas les fichiers d'un autre. Pour garder ou partager des fichiers, travaille sur un repo GitHub, sinon recopie le contenu dans le prompt.
- Ne touche jamais une session que tu n'as pas créée.
