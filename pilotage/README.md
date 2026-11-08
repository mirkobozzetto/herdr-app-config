# Piloter des sessions Claude depuis Claude Desktop

Testé le 2026-11-08 depuis une session cloud ouverte dans Claude Desktop.
Spec : [TESTS.md](TESTS.md). Preuves brutes : [PREUVES.md](PREUVES.md).

## Résultat

| Geste Herdr | Outil | Résultat | Preuve |
|---|---|---|---|
| Nouvel agent | `create_session` | OK | enfant écrit ok.txt = `UN` |
| Regarder un agent | `list_events` (kinds `result`) | OK | texte final de l'enfant lu |
| Board (working / needs you / done) | `list_sessions(mine: true)` | OK | `status_bucket` + `needs_action` par session |
| Filtrer par projet | `list_sessions(tags)` | KO | `tags filter is not currently available` (filtrer soi-même, les tags sont renvoyés) |
| Taper dans un agent | `send_message` | OK en `auto` | enfant `auto` : ok.txt = `UN DEUX TROIS` |
| | | KO en `acceptEdits` | « Une autre session n'a pas autorité pour me diriger » |
| Agent qui rend compte | `send_message` vers `@parent` | OK en `auto` | reçu sans clic : « UN DEUX » |
| | | bloqué en `acceptEdits` | « Waiting on permission: Send Message », OK après clic humain |
| Interrompre | `interrupt_session` | OK | `terminal_reason: aborted_streaming` |
| Renommer | `set_session_title` | OK | `test-pilote-a-renommee` |
| /clear d'un agent | archive + nouvelle session avec STATE dans le prompt | OK | « Je ne sais rien de la conversation de la session précédente » |
| Relancer | `unarchive_session` + `send_message` | OK | se souvient : « j'ai écrit STATE.md et vérifié ok.txt » |
| Fermer | `archive_session` | OK | 5/5 `SESSION_STATUS_ARCHIVED` |
| Voir dans Desktop | barre latérale | OK | enfants rangées sous l'orchestrateur |
| Arsenal dans un agent | `/next:next` | KO sans installation | « La commande /next:next n'est pas installée » |
| | 2 commandes `claude plugin` | OK | 7 plugins `√ enabled`, `/next:next` reconnu |
| /clear sur l'orchestrateur | aucun | KO | pas d'outil, relève par handoff |
| Pré-autoriser l'enfant | `extra_allowed_tools` / `append_system_prompt` | KO | ignoré / refusé « Instruction Poisoning » |

## Les 3 règles qui font marcher le pilotage

1. Créer chaque session en `permission_mode: "auto"`, sinon elle refuse les ordres et bloque sur ses réponses.
2. Mettre toute la tâche dans le prompt de création, et finir par « envoie le résultat à @parent avec send_message ».
3. Chaque session cloud a son propre conteneur : rien n'est partagé, le contexte passe par le prompt (ou un repo git, non testé).

## Installer pour quelqu'un d'autre

1. Claude Desktop, nouvelle session Code en environnement cloud.
2. Menu de l'environnement (barre de titre de la session) > Edit > Setup script, coller [setup.sh](setup.sh). Arsenal est alors dans chaque nouvelle session.
3. Coller [PROMPT.md](PROMPT.md) comme premier message.

## Pas testé

- Sessions locales de Desktop (onglet Code sur le Mac) : autres outils, non testés ici.
- `source_url` (une session sur un repo) et le partage de fichiers entre sessions par git.
- Le setup script dans un environnement : l'outil a refusé de l'écrire (« network settings are in a shape this tool does not edit »). Script vérifié à la main dans ce conteneur.
