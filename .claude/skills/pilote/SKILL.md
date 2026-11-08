---
name: pilote
description: Piloter d'autres sessions Claude Code depuis Claude Desktop, sans terminal. Lancer un ou plusieurs agents, voir où ils en sont, leur parler, les arrêter, repartir de zéro, les relancer, les fermer. À utiliser dès que l'utilisateur veut lancer, suivre ou gérer des agents ou des sessions.
---

# Pilote

Tu pilotes pour l'utilisateur d'autres sessions Claude Code, avec les outils du serveur `claude-code-remote`. Charge-les d'abord avec ToolSearch : `select:mcp__claude-code-remote__create_session,mcp__claude-code-remote__send_message,mcp__claude-code-remote__list_sessions,mcp__claude-code-remote__get_session,mcp__claude-code-remote__list_events,mcp__claude-code-remote__interrupt_session,mcp__claude-code-remote__set_session_title,mcp__claude-code-remote__archive_session,mcp__claude-code-remote__unarchive_session`.

L'utilisateur ne tape aucune commande. Parle simplement : jamais d'identifiant, jamais de jargon.

## Gestes

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

## Règles

- Toujours permission_mode « auto » : sinon l'agent refuse tes messages et reste bloqué sur ses réponses.
- Toute la tâche va dans le prompt de création.
- Pour attendre un agent, termine ton tour : son message te réveille. Pas de sleep.
- Quand un agent t'écrit, résume son message à l'utilisateur en une ligne.
- Les agents tournent dans le cloud d'Anthropic : ils ne voient pas les fichiers de l'ordinateur. Pour travailler sur un projet, il faut son repo GitHub (`source_url`).
- Ne touche jamais une session que tu n'as pas créée.
