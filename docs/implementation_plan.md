# Implementation Plan

갱신일: 2026-05-31

## Current Evaluation

### Strengths
- Godot autoload managers are split by responsibility: `GameState`, `CharacterManager`, `InventoryManager`, `WorldManager`, `CraftingManager`, `BaseManager`, `EventManager`, and `SaveManager`.
- The main scene now has a playable map-first UI with hex tile exploration, fog of war, character art, survival state, separate inventories, crafting, base placement, field items, cutscenes, and logs.
- Core data is resource-driven for regions, items, recipes, events, personalities, and states, so adding content does not require hard-coding every case.
- Save/load covers the important manager data, including world state, inventories, base state, crafting discoveries, events, and flags.
- The benchmark improvement loop has been implemented through item use, partner suggestions, tile memory, action feedback, survival state chains, base life presentation, and the 3-day guide loop.

### Weaknesses
- The game loop is broad enough to play, and the basic 3-day route is covered by `scripts/tests/three_day_survival_smoke.gd`; more bad-luck and alternate-choice cases still need coverage.
- Region actions now produce visual feedback and consequences, but 요리, 치료, 불 피우기 같은 행동별 고유 미니 판정은 더 세분화할 수 있다.
- Partner systems are functional, but 성격별 장기 이벤트와 거절/수락 루프는 더 많은 콘텐츠가 필요하다.
- Base presentation is more visual, but installed objects are still tokenized rather than freely placed interior props.
- `scripts/ui/main.gd` is too large and should be split once the next feature pass begins.

## Better Direction

The current prototype now has one vertical survival loop. The safer next step is to stabilize and test that loop before adding more breadth:

1. Expand the deterministic 3-day smoke simulation to cover bad luck, non-axe starting items, partner delay, and night mistakes.
2. Tune starting beach resources, daily decay, and action costs until bad luck is survivable but reckless play is punished.
3. Split UI code into map, tool menu, character panel, base view, cutscene, and feedback scripts.
4. Add deeper unique interaction to cooking, treatment, and fire-starting.
5. Expand partner personality events once the daily loop is stable.

Additional features should attach to this loop rather than becoming isolated menus.

## Card Survival-Style Resource Loop

Reference direction: translate card-combination survival into tile-map survival instead of copying the card interface.

- Each tile should behave like a resource card stack: terrain decides what can appear, investigation reveals quantity, and development improves repeat yield.
- Tools should not only be inventory trophies. A stone axe improves wood yield, a stone knife improves plant/fiber yield, and later tools can add rarer resource bonuses.
- Crafting should create intermediate components before large structures: sharp stone, rope, tools, then shelters or stations.
- Construction should consume resources separately from normal crafting. Development and base placement must therefore require materials, time, and stamina.
- Base structures should create persistent pressure relief: rain collectors produce water, fish traps produce food, drying racks unlock preserved food, and shelter pieces reduce weather strain.

## Phase 1 - Playable Survival Pressure

Goal: make a single day feel like a tactical survival decision.

- Add inventory item use for food and drink.
- Add fish as a resource and a fishing action for beach/river.
- Add optional partner accompaniment for region actions.
- Add weather and danger aftereffects to outdoor actions.
- Make companion actions reduce risk but consume partner stamina.
- Surface the action mode in the bottom command UI.
- Verify the project opens and the main scene runs.

Acceptance criteria:
- The player can gather, fish, rest, move, investigate, develop, consume food/drink, and choose sleep duration.
- Food/drink immediately changes hunger/thirst, stamina, and mood when relevant.
- Partner mode changes stamina cost, result text, trust/mood, and risk.
- Weather and danger can create fatigue/fear/mood/HP consequences.

## Phase 2 - Resources, Crafting, And Base

Goal: connect survival actions to long-term preparation.

- Add more resource types from the spec: shellfish, medicinal herbs, ruined fragments, and advanced minerals.
- Add cooking and processing recipes using existing `CraftRecipe`.
- Add station requirements for cooking/processing after the base has relevant placed objects.
- Expand base stats so comfort, stability, warmth, hygiene, storage, and work efficiency affect daily recovery and storm risk.
- Keep sleep/day transition feedback in the result panel and include base-generated yields.

Acceptance criteria:
- Base placement changes daily survival outcomes.
- Crafted objects are not only inventory trophies; they alter action efficiency or recovery.
- Day-end summaries clearly show gained/lost resources and status changes.

## Phase 3 - Partner Systems

Goal: make the partner a second lead, not a stat bonus.

- Add partner preferences beyond berry gifts.
- Add personality-specific modifiers for risky actions, investigation, conflict, and recovery.
- Add burden actions that are efficient but emotionally costly.
- Add more joint actions gated by trust and location.
- Add cooldowns for talk/gift/conflict events.

Acceptance criteria:
- The same action can be better or worse depending on partner personality and current mood.
- Ignoring the partner has visible consequences.
- High trust unlocks at least one unique exploration route.

## Phase 4 - Mystery And Endings

Goal: connect survival progress to exploration and ending routes.

- Add ancient ruin progress flags and clue items.
- Add partner-required ruin interactions.
- Add escape preparation items and ending gates.
- Add route checks for both escape, solo escape, partner-only loss, and staying on the island.

Acceptance criteria:
- The player can see what preparation is missing before an ending attempt.
- Ending routes depend on survival state, trust, and discovered clues.

## Phase 5 - Polish And Regression

Goal: stabilize the prototype into a testable MVP.

- Add scripted smoke checks for manager flows.
- Add UI pass for overflow at common desktop resolutions.
- Add balancing notes for day length, resource recovery, and danger rates.
- Keep `docs/ui_guidelines.md` updated when the UI direction changes.

Acceptance criteria:
- Godot headless load passes.
- Main scene can run for at least one frame.
- A manual checklist covers a 3-day survival loop.
