# UI Guidelines

## Highest UI Directive

The UI must communicate life and emotion before it communicates raw information.

Every UI decision should help the player naturally feel:
- survival pressure
- the passage of time
- changing weather
- emotional condition
- the relationship between the two survivors

The game must not look like a factory-style survival game or a number-management dashboard.

The intended feeling is:

> Two people living together on a deserted island.

When a UI choice is technically efficient but makes the game feel dry, mechanical, or spreadsheet-like, choose the warmer survival-life presentation instead. Numbers may exist, but they should be supported by images, icons, atmosphere, posture, color, spacing, and short emotional cues.

## Sensory Presentation Rule

The player should not feel like they are only manipulating data. Each important state change should be paired with at least one sensory cue:
- body cue: thirst, hunger, fatigue, pain, fear, dirt, warmth, cold
- world cue: wind, sand, mud, water sound, leaf movement, darkness, wet clothes
- object cue: weight, texture, smell, use feeling, whether it comforts or burdens the survivors

Use numbers for clarity, but use short sensory text, pressure overlays, card motion, nearby action bubbles, and ambient map cues to make the player feel the condition before they calculate it.

## Benchmark Position

This project should use a map-first structure inspired by turn-based strategy games, while keeping survival and partner information close to the player like a handheld survival adventure.

Use the benchmark as layout guidance, not visual copying.

## Core Principles

1. The map owns the screen.
   - The map should be the largest visual area.
   - The map should use a single full-map illustration as the primary visual source.
   - For the SRPG prototype map, use a 10x10 hex-feeling image-tile grid as the primary screen.
   - The outer two rows and columns are non-playable edge/ocean space; every inner tile is terrain.
   - Each grid coordinate must resolve to one PNG tile image file.
   - The world map visual style should be flat, RPG Maker-like, hex-tile friendly, and readable as a board-like survival map.
   - One large tile should communicate one dominant terrain or landmark.
   - Region selection and movement should happen directly on the map.
   - Panels must support map decisions, not compete with them.

2. Information follows selection.
   - The selected region appears in the bottom command area.
   - Region illustration, risk, investigation, development, and resources stay together.
   - Actions should only show when they are relevant to the selected/current region.
   - Unknown regions should not expose detailed traits until visited.

3. Survival is always visible, but compact.
   - Player and partner HP, stamina, hunger, thirst, mood, and trust use meters first, text second.
   - The right panel starts with the player/partner character visual, then wraps persistent survival state, inventory, and log around it.
   - Avoid long paragraphs in the side panel.

4. Visuals and data must be paired.
   - Every region information block should have a small illustration or terrain color.
   - The player/partner panel should show character art first, with key survival numbers attached as compact overlays.
   - Every numeric pressure should have a meter, icon, color, or short label.
   - Avoid pure text tables during active play.

5. Icons carry repeated information.
   - Resource, status, and command icons should appear wherever the same concept is repeated.
   - Buttons should use an icon plus a short Korean label.
   - Status bars should use an icon, meter, and number.
   - Inventory and resource lists should use item icons before item names.
   - Do not replace rare story choices with icons only; dialogue choices stay text-first.

6. Command hierarchy is fixed.
   - Top bar: date, weather, current time, sunrise/sunset, save/load.
   - Main field: world map and clickable regions.
   - Right panel: player/partner visual, compact survival state, inventory, recent log.
   - Bottom command bar: selected region, actions, crafting, base placement.

7. Keep the emotional core visible.
   - Partner status must stay near player status.
   - Relationship actions should be reachable without opening a separate menu.
   - Event windows should be calm and readable, with few choices.

## Layout Rules

- Reserve at least 55 percent of desktop width for the map.
- Side character panels may be compressed when the map tile scale increases. Keep character portraits readable, but give priority to the central map viewport.
- Keep the bottom command panel under 210 px tall unless it becomes tabbed.
- Use one-line action buttons where possible.
- Do not place repeated cards inside another card.
- Do not use decorative UI that hides map readability.

## Region Node Rules

- Current region uses a warm highlight.
- Reachable regions use a green/soft highlight.
- Unreachable regions are visible but subdued.
- Visited region buttons show name plus one key trait.
- Unvisited region buttons show unknown/exploration state only.
- Detailed data belongs in the bottom region panel.

## Fog Of War Rules

- Beach starts revealed because it is the opening location.
- A tile is revealed only when an adjacent investigated tile exposes it.
- Unvisited terrain tiles are covered by fog image overlays above their tile image.
- Fogged terrain tiles cannot be clicked or operated.
- Revealed but non-adjacent tiles remain visible, but do not become the active operation target until reachable again.
- Hidden tiles must not reveal resource counts, investigation, development, or exact danger until revealed.
- Fog should obscure information without hiding that a destination exists.

## Main Map Layout Rules

- The map screen is the game's default and primary screen.
- The 10x10 tile map stays centered.
- Large information-dense tiles use a larger base tile size and camera panning. Do not shrink tile information back into unreadable mini badges just to show the full island at once.
- The player portrait is a tall vertical panel on the left with status below it.
- The companion portrait is a tall vertical panel on the right only when a companion is present; otherwise show a restrained empty companion state.
- Inventory, crafting, base, and log details are compressed into icon buttons at the map's upper-left.
- Icon menus open subpanels over the map area and should close without changing the current map state.
- Entering a base swaps the central map area into that base's interior/subscreen, with a clear return-to-map command.

## SRPG Map Command Rules

- Clicking a region should select it and open a compact map-side command panel instead of immediately firing most actions.
- In tile-map mode, clicking a revealed playable tile opens the tile command panel.
- Current region menus show local actions: investigate, gather, fish, develop, rest.
- Adjacent region menus show movement first; unknown adjacent regions must still hide detailed resources and danger.
- The command panel should show time and stamina cost before the player commits.
- Partner accompaniment is a mode, not a separate duplicate action. It should be visible near the action list and affect cost/risk/result text.
- Disabled actions should remain visible when useful, but the reason must be inferable from time, stamina, night restriction, or location state.
- The bottom command bar can mirror the same actions for speed, but the map menu is the primary SRPG-style interaction path.

## Time And Restriction Rules

- Action time is represented in 30-minute slots. UI text should convert slot count into minutes.
- Daylight time comes from the current season's sunrise and sunset. During daylight, normal action cost and result expectations apply.
- At night, investigate and craft are blocked. Other actions remain possible, but their time and stamina costs increase.
- Food and drink effects should show both survival recovery and stamina recovery when relevant.
- Rest consumes time instead of ending the day and restores stamina.
- Sleep must let the player choose duration. Longer sleep restores more stamina and mood, but reduces hunger and thirst.

## Resource, Crafting, And Construction Rules

- Tile context panels should show known resources. Uninvestigated tiles may list resource names, while investigated tiles may show counts.
- Gather results should be affected by terrain, investigation, development, weather, tools, companion assistance, and base bonuses.
- Crafting rows should show requirements, station requirements, time, stamina, and night restriction state before commitment.
- Construction is a two-step loop: craft a placeable item, then enter the base and spend placement time/stamina to install it.
- Base structures should advertise their practical effect through the base summary rather than long tutorial text.

## Action Presentation Rules

- Every committed map action should produce feedback stronger than a log line.
- The result panel should include an image backdrop, action icon, result text, gained items, and status deltas.
- Status changes should be grouped by actor: player first, partner second.
- Movement should flash the destination node after the map refreshes.
- Random risk aftereffects should be appended to the same result panel so the player sees why HP, mood, fear, or fatigue changed.
- Story events may appear after the action result; event panels should be visually above normal action feedback.

## Color Direction

- Use terrain colors for the map: sand, grass, stone, forest, water.
- Use warm gold only for current selection and important choice focus.
- Use red/orange sparingly for danger, injury, or critical resources.
- Avoid making the whole UI blue/slate; survival panels can be dark, but the map must carry natural color.

## MVP UI Roadmap

1. Current: node-based illustrated island map.
2. Next: add selected-region hover/preview and resource chips.
3. Later: replace node map with TileMapLayer + Camera2D.
4. Later: split bottom command panel into tabs when crafting/base lists grow.
