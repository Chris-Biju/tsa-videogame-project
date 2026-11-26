# How the game is wired together

Open **`tsa-26-27-videogame/project.godot`** in Godot. This is now the only project;
the old `tsa-game-2026/` and `tsa-game-2026-(4.6)/` folders were merged into it.

## The three rules

1. **ContentDB** (`scripts/ContentDB.gd`, autoload named `ContentDB`, not `ContentDb`) holds *definitions*: buildings, costs,
   quests, dialogue, events, classes, tech, and the balancing numbers
   (`STARTING_STATE`, `WEEKLY_SUPPLY`, `WEEKLY_UPKEEP`, quota rewards, XP...).
   It never changes during play.
2. **GameState** (`scripts/game_state.gd`, autoload) holds the *current playthrough*
   (week, resources, buildings, quests, level/XP) and the *rules* that change it.
3. **Screens only display GameState and send it requests.** They never change each
   other directly. After any change GameState emits `state_changed`, and every
   open screen redraws itself.

```
screen button ──request──▶ GameState.try_place_building(...)
                                │ checks ContentDB, updates data
                                ▼
                       state_changed / notification_requested
                                │
            every open screen redraws, NotificationLayer shows the message
```

## Requests screens can make

| Request | Used by |
|---|---|
| `GameState.start_new_game(class_id)` | GameRoot (after character select) |
| `GameState.try_place_building(id, tile)` / `get_build_block_reason(id, tile)` | ColonyScreen, BuildMenu |
| `GameState.try_repair_building(tile)` | ColonyPanel |
| `GameState.try_research(tech_id)` | TechScreen |
| `GameState.accept_quest(q)` / `decline_quest(q)` / `try_complete_quest(id)` | QuestConversation, QuestScreen |
| `GameState.advance_week()` → report dictionary | GameRoot (End Week) |
| `GameState.add_xp(n)` → may emit `level_up` | anything that rewards the player |

Everything returns or shows a reason when it fails, so the UI never has to repeat the rules.

## Scene flow (`scenes/main.tscn` → `scenes/GameRoot.tscn` + `scenes/game_root.gd`)

`main.tscn` is just `Main (Node)` holding the `GameRoot` scene. GameRoot contains the
ScreenManager, the ModalLayer popups and the NotificationLayer.

```
CharacterSelect ─confirm─▶ Colony + first villager request (QuestConversation)
Colony ─End Week─▶ ResourceReport ─▶ WeeklyEvents popup ─▶ new villager request ─▶ Colony
Colony ─Quests/Research buttons─▶ QuestScreen / TechScreen ─Back─▶ Colony
```

- `ScreenManager` swaps full screens. A screen that wants to navigate declares
  `signal navigate_requested(screen_name: String)` and emits `"colony"`, `"quests"`, `"tech"`...
  To add a screen, add it to `SCREENS` in `scenes/screen_manager.gd`.
- Popups (report, event, quest conversation, level up) live in `ModalLayer` in `GameRoot.tscn`.
  Don't wire them with editor signal connections. `game_root.gd` connects them in code,
  and a second editor connection would make things run twice.

## Order of the weekly turn (`GameState.advance_week`)

1. Production from operational buildings plus Empire supply (`WEEKLY_SUPPLY`), unless an event paused it
2. Upkeep (`WEEKLY_UPKEEP`). A shortage costs morale
3. Risium quota is delivered or missed
4. Expired quests fail
5. The next week starts: a new quota and a new event, applied immediately (e.g. a damaged building stops producing)

## Testing one scene on its own

Colony, Quest, Tech, QuestConversation and WeeklyEvents scenes can be run alone with **F6**.
If no game has started they call `GameState.start_preview_game_if_needed()` or show sample content.

## Adding content

- **A building:** add it to `ContentDB.BUILDINGS`. It shows up in the build menu automatically.
  Buildings marked `cost_tbd` show as disabled until a real `cost` is filled in.
  Harvesters also need `production_per_week`.
- **A quest:** add it to `VILLAGER_QUESTS` and its lines to `QUEST_DIALOGUE`, plus `reward_effects`
  such as `{"kristals": 5, "morale": 5}`. Only quests whose `objective_type` is in
  `GameState.SUPPORTED_QUEST_TYPES` (`build`, `deliver`, `spend_resources`) are offered.
  Add a type there once the puzzle or choice system that resolves it exists.
- **An event:** add it to `WEEKLY_EVENTS` and handle its `effect_type` in `GameState._apply_event`.
