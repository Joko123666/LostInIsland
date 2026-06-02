# Shared Context

Last updated: 2026-06-02

이 문서는 LostInIsland 프로젝트를 새 대화, 새 작업자, 새 Codex 세션에서 빠르게 이어받기 위한 공통 요약이다. 큰 기능 변경, 구조 변경, Git/CI 변경이 생기면 이 파일도 함께 갱신한다.

## Project

- Godot `4.6.3-stable` 기반 섬 생존 게임 프로토타입.
- 메인 씬은 `scenes/main/Main.tscn`.
- 핵심 UI는 `scripts/ui/main.gd`에 집중되어 있다.
- 플레이 루프는 조사, 이동, 채집, 제작, 휴식, 수면, 거점 관리, 파트너 상호작용 중심이다.

## Git And CI

- GitHub remote: `https://github.com/Joko123666/LostInIsland.git`
- 기본 브랜치: `main`
- 현재 CI: `.github/workflows/godot-smoke.yml`
- CI는 push, pull request, 수동 실행에서 Godot headless import와 3개 스모크 테스트를 실행한다.
- 로컬 생성물인 `.godot/`, `build/`, `saves/`는 Git에서 제외한다.
- 현재 대형 이미지 파일은 GitHub 단일 파일 제한 이하라 Git LFS는 필수는 아니다. 향후 50MB 이상 자산이 늘면 LFS 도입을 검토한다.

## Verification

Windows 로컬 검증에 사용한 Godot 실행 파일:

```powershell
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe
```

기본 검증:

```powershell
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe --headless --path . --editor --quit
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/three_day_survival_smoke.gd
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/time_adjustment_smoke.gd
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/wall_reveal_smoke.gd
```

성공 출력:

- `THREE_DAY_SURVIVAL_SMOKE_OK`
- `TIME_ADJUSTMENT_SMOKE_OK`
- `WALL_REVEAL_SMOKE_OK`

## Core Architecture

- `scripts/managers/game_state.gd`: 날짜, 시간, 날씨, 행동 가능 시간, 게임오버 상태.
- `scripts/managers/world_manager.gd`: 타일 맵, 조사/이동/채집/사냥/휴식 실행, 벽 차단, 안개 공개.
- `scripts/managers/character_manager.gd`: 플레이어/파트너 상태, 회복, 소모, 관계.
- `scripts/managers/inventory_manager.gd`: 플레이어/파트너 인벤토리, 아이템 이동, 도구 내구도.
- `scripts/managers/crafting_manager.gd`: 레시피 로드, 제작 가능 여부, 제작 실행.
- `scripts/managers/base_manager.gd`: 거점 보관, 배치물, 휴식/수면 보정.
- `scripts/managers/event_manager.gd`: 이벤트 트리거와 결과 처리.
- `scripts/ui/main.gd`: 메인 UI, 지도, 하단 정보 패널, 팝업, 미니게임, 피드백 연출.

## Current Gameplay And UI Decisions

- 생존 핵심 정보인 몸/숨/허기/수분은 과도하게 압축하지 않고 명확하게 보여준다.
- 인벤토리와 필드 간 아이템 이동은 드래그 앤 드롭 조작을 유지한다.
- 휴식/수면은 단순 클릭 실행이 아니라 시간 조정 팝업을 거친다.
- 휴식: 15분부터 2시간까지, 15분 단위.
- 수면: 1시간부터 20시간까지, 1시간 단위.
- 체력이 0이 된 사람이 있으면 게임오버를 출력한다.
- 조사 시 벽, 절벽, 깊은 물길 등으로 막힌 방향의 타일은 밝혀지지 않는다.
- 벽으로 막힌 경로 표시는 타일 내부가 아니라 타일 사이 벽 선 위에 배치한다.
- 미탐색 타일은 지형이 흐릿하게 비치지 않도록 완전히 덮는다.
- 이미 공개된 타일 중 현재 위치에서 멀거나 벽으로 직접 닿지 않는 타일만 안개로 가린다.
- 타일 사이 간격은 약간 벌렸고, 전체 타일 묶음 아래에는 단색 배경 이미지를 깔았다.
- 좌상단 메뉴는 아이콘과 텍스트를 함께 보여주며, hover/선택 반응을 강화했다.
- 선택지와 버튼에는 hover 외곽선 또는 약한 하이라이트를 둔다.
- 거점 UI는 정보 중요도 기준으로 재구성했고, 불필요하게 큰 텍스트/버튼 공간을 줄이는 방향이다.

## Important Files

- `README.md`: 실행, 테스트, 구조, Git 관리 기본 안내.
- `.github/workflows/godot-smoke.yml`: GitHub Actions 스모크 테스트.
- `docs/current_game_state.md`: 현재 시스템 구조와 상태 요약.
- `docs/ui_information_priority.md`: UI 정보 중요도.
- `docs/ui_generated_image_assets.md`: 생성 이미지 자산 목록.
- `docs/ui_transition_effect_slots.md`: 전환/연출 리소스 배치 계획.
- `docs/wireframes/current_game_state_wireframe.png`: 현재 와이어프레임 이미지.
- `assets/tiles/map_tile_backplate.svg`: 타일 묶음 아래 단색 배경 이미지.

## Management Gaps

아직 진행하지 않은 관리 보강:

- `LICENSE` 추가.
- 릴리스/빌드 절차 문서화.
- Git LFS 도입 기준 또는 자산 관리 정책 문서화.
- 필요 시 `play_flow_audit.gd`를 CI에 포함할지 검토. 현재 CI는 빠른 스모크 테스트만 포함한다.

## Update Rule

다음 변경이 생기면 이 문서를 함께 갱신한다.

- 새 핵심 시스템 추가 또는 매니저 구조 변경.
- 주요 UI 정보 배치 원칙 변경.
- 조사, 이동, 안개, 생존 수치 같은 핵심 규칙 변경.
- GitHub Actions, 테스트, 원격 저장소, 빌드 절차 변경.
- 새 대화에서 반복해서 설명해야 할 맥락이 생긴 경우.
