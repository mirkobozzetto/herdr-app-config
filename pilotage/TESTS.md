# Tests : piloter des sessions Claude depuis Claude Desktop

Écrits AVANT exécution. Chaque test : geste Herdr, outil, attendu.
Orchestrateur : session cloud ouverte depuis Claude Desktop (origin desktop_app).
Sessions de test : titre `test-pilote-*` uniquement.

| # | Geste Herdr | Outil | Attendu (assertion) |
|---|---|---|---|
| T1 | Nouvel onglet agent | create_session | session créée, ok.txt = UN dans son transcript |
| T2 | Regarder un agent | list_events | je lis son dernier message |
| T3 | Taper dans un agent | send_message | ok.txt contient DEUX |
| T4 | Agent qui me répond | send_message (enfant → moi) | je reçois un tour venant de l'enfant |
| T5 | /clear d'un agent | archive + create_session avec handoff | B connaît STATE, pas la conversation de A |
| T6 | Interrompre | interrupt_session | tour de l'enfant arrêté (status idle) |
| T7 | Relancer | unarchive_session + send_message | l'enfant se souvient de sa conversation |
| T8 | Renommer | set_session_title | titre changé dans get_session |
| T9 | Board projets | set_session_tags + list_sessions(tags) | liste filtrée par tag projet |
| T10 | Arsenal dans un agent | create_session "/next:next" | sortie de next, pas "unknown" |
| T11 | /clear sur moi | aucun outil | KO attendu, relève via handoff |
| T12 | Visible dans Desktop | question à l'utilisateur | sessions test-pilote-* visibles |
| T13 | Fermer | archive_session | plus aucune test-pilote-* active |
