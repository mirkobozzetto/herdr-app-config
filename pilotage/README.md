# Piloter des sessions Claude depuis Claude Desktop

Testé le 2026-11-08 depuis une session cloud ouverte dans Claude Desktop, sans clic sauf mention.
Spec : [TESTS.md](TESTS.md). Preuves brutes : [PREUVES.md](PREUVES.md).

## Résultat

| Geste Herdr | Outil | Résultat | Preuve |
|---|---|---|---|
| Nouvel agent | `create_session` | OK | enfant écrit ok.txt = `UN` |
| Regarder un agent | `list_events` (kinds `result`) | OK | texte final de l'enfant lu |
| Board (working / needs you / done) | `list_sessions(mine: true)` | OK | `status_bucket` + `needs_action` par session |
| Filtrer par projet | `list_sessions(tags)` | KO | `tags filter is not currently available` (filtrer soi-même) |
| Taper dans un agent | `send_message` | OK en `auto` | ok.txt = `UN DEUX TROIS` |
| | | KO en `acceptEdits` | « Une autre session n'a pas autorité pour me diriger » |
| Agent qui rend compte | `send_message` vers `@parent` | OK en `auto` | reçu sans clic : « UN DEUX » |
| Interrompre | `interrupt_session` | OK | `terminal_reason: aborted_streaming` |
| Renommer | `set_session_title` | OK | `test-pilote-a-renommee` |
| /clear d'un agent | archive + nouvelle session avec STATE dans le prompt | OK | « Je ne sais rien de la conversation de la session précédente » |
| Relève via git | `create_session(source_url, source_revision)` | OK | mot de contrôle `PERROQUET-42` renvoyé |
| Relancer | `unarchive_session` + `send_message` | OK | « j'ai écrit STATE.md et vérifié ok.txt » |
| Fermer | `archive_session` | OK | 10/10 `SESSION_STATUS_ARCHIVED` |
| Voir dans Desktop | barre latérale | OK | enfants rangées sous l'orchestrateur (vu par Mirko) |
| Arsenal dans un agent | environnement « Arsenal » + `/next:next` | OK | scan arsenal : « No open brief/propose work found. Nothing to resume. » |
| | installation par l'enfant lui-même | KO | « [Untrusted Code Integration] » |
| PROMPT.md joué par une autre session | orchestrateur → sous-orchestrateur → enfant | OK | « Aucune erreur. » |
| /clear sur l'orchestrateur | aucun | KO | pas d'outil, relève par handoff |
| Modifier l'environnement Default | `update_environment` | KO | « network settings are in a shape this tool does not edit » |

## Les 3 règles qui font marcher le pilotage

1. Créer chaque session en `permission_mode: "auto"`, sinon elle refuse les ordres et bloque sur ses réponses.
2. Mettre toute la tâche dans le prompt de création, et finir par « envoie le résultat à @parent avec send_message ».
3. Chaque session cloud a son propre conteneur : le contexte passe par le prompt ou par git (`source_url`).

## Installer pour quelqu'un d'autre

1. Claude Desktop, nouvelle session Code dans le cloud.
2. Coller [PROMPT.md](PROMPT.md) comme premier message.
3. Cliquer « Approuver » sur la carte qui crée l'environnement Arsenal. C'est le seul clic.

## Pas testé

- Sessions locales de Desktop (onglet Code sur le Mac) : autres outils, non testés ici.
- Hook SessionStart de next : les hooks des plugins sont chargés (`hooks_init_origin: other_plugin`), mais aucune sortie de hook n'apparaît dans le transcript.
