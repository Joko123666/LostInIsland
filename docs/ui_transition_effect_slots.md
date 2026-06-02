# UI 전환/연출 요소 배치 후보

이 문서는 현재 UI 구조에서 전환, 연출, 보조 이미지가 들어갈 수 있는 위치를 정리한다. 기준은 플레이어의 시선 흐름, 행동 결과 인지 속도, 생존 정보의 가독성이다.

## 평가 요약

장점:

- 행동 완료 후 피드백이 `_play_post_action_feedback()`으로 모여 있어 결과 연출을 중앙에서 관리하기 좋다.
- 컷인, 화면 플래시/흔들림, 타일 강조, 감각 토스트, 이벤트 인트로, 컷신 레이어가 이미 분리되어 있다.
- 생성된 이미지 자산 중 `action_results`, `survival_status`, `base_growth`, `companion_state` 일부는 이미 UI와 연결되어 있어 확장 비용이 낮다.

단점:

- 시간/날씨 이미지, 타일 대표 이미지, 위험 신호 이미지는 아직 핵심 화면 흐름에 충분히 연결되지 않았다.
- 거점 진입/퇴장, 메뉴 열림/닫힘, 상태 상세 열림은 즉시 표시 방식이라 화면 전환 감각이 약하다.
- 여러 피드백이 동시에 발생할 수 있어 행동 직후 컷인, 토스트, 감각 버블, 화면 효과의 우선순위를 정하지 않으면 시선이 분산될 수 있다.

더 좋은 방식:

- 모든 연출을 개별 버튼에 직접 넣기보다, `행동 시작 -> 행동 완료 -> 결과 등급 -> 화면 반응` 순서로 효과를 배분한다.
- 자주 반복되는 행동은 0.25-0.6초 이내의 짧은 반응으로 제한하고, 하루 전환/거점 성장/컷신 같은 희소 이벤트에만 긴 전환을 쓴다.
- 생존 4수치(체력/기력/허기/수분)는 연출로 가리거나 축소하지 않고, 위험 변화가 발생했을 때만 주변 강조를 추가한다.

## 우선순위 기준

| 우선순위 | 의미 |
| --- | --- |
| P0 | 플레이어가 즉시 알아야 하는 결과, 위험, 시간 변화 |
| P1 | 장소감, 성장감, 선택 피드백을 높이는 연출 |
| P2 | 완성도와 감성은 올리지만 판단에는 덜 중요한 연출 |

## 삽입 위치 리스트

| 우선순위 | 위치/함수 | 넣을 연출 | 목적 | 추천 자산 |
| --- | --- | --- | --- | --- |
| P0 | `scripts/ui/main.gd::_play_post_action_feedback()` | 행동 완료 후 결과 등급별 피드백 라우팅 | 행동 결과를 한 번에 인지시키는 중앙 허브 | `action_results/*`, `danger_signals/*`, `tool_quality/*` |
| P0 | `scripts/ui/main.gd::_play_action_cutin()` | 컷인 진입/유지/퇴장 변주, 성공/실패별 배경 유지 시간 차등 | 중요한 행동 결과의 기억점 만들기 | 이미 연결된 `action_results/*`, `resource_objects/*`, `companion_state/*` |
| P0 | `scripts/ui/main.gd::_show_action_delta_toast()` | 체력/기력/허기/수분 변화가 클 때 수치 줄 강조, 위험색 펄스 | 생존 변화 누락 방지 | `survival_status/dehydration.png`, `hunger.png`, `exhaustion.png`, `wet_cold.png` |
| P0 | `scripts/ui/main.gd::_apply_time_flow_visuals()` | 시간대 변경 시 짧은 상단 배너, 맵 조명 크로스페이드, 야간 진입 경고 | 낮/밤/날씨가 행동 판단에 주는 영향을 빠르게 전달 | `time_weather/dawn.png`, `noon_heat.png`, `dusk.png`, `night_storm.png` |
| P0 | `scripts/ui/main.gd::_refresh_map_atmosphere_visibility()` | 비/폭풍/야간 분위기 강화, 풍경 레이어 알파 보정 | 맵을 보자마자 환경 위험을 느끼게 함 | `time_weather/night_storm.png`는 별도 경고 카드에 적합 |
| P0 | `scripts/ui/main.gd::_open_tile_context_menu()` | 타일 선택 링, 선택 패널 슬라이드, 위험 배지 플래시 | "지금 무엇을 선택했는지"를 명확히 함 | `terrain_tiles/*`, `danger_signals/*` |
| P1 | `scripts/ui/main.gd::_flash_tile_node()` | 현재 단순 색상 플래시를 선택 링/파동으로 확장 | 맵 위 행동 지점 시선 고정 | 타일 자체 효과, 별도 이미지 불필요 |
| P1 | `scripts/ui/main.gd::_play_move_tile_fx()` | 이동 시작/도착 방향성, 경로 잔상, 짧은 카메라/맵 패닝 | 이동 결과와 위치 변화를 자연스럽게 이해 | `terrain_tiles/jungle_trail.png`, `cliff_ledge.png` |
| P1 | `scripts/ui/main.gd::_show_action_sensory_bubble()` | 감각 문장 등장 시 아이콘/텍스트 페이드, 위험 단어 색 강조 | 텍스트 보조 피드백의 가독성 개선 | `danger_signals/*`, `resource_objects/*` |
| P1 | `scripts/ui/main.gd::_show_item_toast_from_result()` | 획득 아이템 팝, 아이템 이동 궤적과 토스트 연결 | 보상 획득의 즉시성 강화 | 기존 아이템 아이콘, 필요 시 `resource_objects/*` |
| P1 | `scripts/ui/main.gd::_finish_direct_item_move()` | 드래그 이동 성공 시 시작점-도착점 아크, 도착점 흡착 효과 | 인벤토리/필드/거점 간 물건 이동 피드백 | 기존 아이템 아이콘 |
| P1 | `scripts/ui/main.gd::_show_base_view()` | 거점 화면 진입 크로스페이드, 맵에서 거점 이미지로 줌 | 탐색 화면과 관리 화면의 전환 구분 | `base_growth/*` |
| P1 | `scripts/ui/main.gd::_hide_base_view()` | 거점 퇴장 페이드, 맵 정보 패널 복귀 애니메이션 | 화면 모드가 바뀌었다는 인지 보강 | `base_growth/*`는 진입 쪽에만 사용 |
| P1 | `scripts/ui/main.gd::_refresh_base_life_scene()` | 시설 증가 시 배경 이미지 크로스페이드, 새 시설 위치 하이라이트 | 거점 성장 체감 강화 | `base_growth/camp_bare.png`부터 `camp_refuge.png` |
| P1 | `scripts/ui/main.gd::_show_partner_reaction_feedback()` | 동료 반응 말풍선에 감정 상태 이미지/색상 변주 | 관계 변화와 조언의 중요도 구분 | `companion_state/*` |
| P1 | `scripts/ui/main.gd::_maybe_show_partner_suggestion()` | 타일 선택/행동 전후 조언의 등장 타이밍 정리 | 조언이 행동 버튼과 경쟁하지 않게 함 | `companion_state/companion_anxious.png`, `companion_trust.png` |
| P2 | `scripts/ui/main.gd::_show_status_detail()` | 상세 패널 열림 페이드, 상태 이미지 교체 크로스페이드 | 자세히 볼 때 상태 해석을 강화 | 이미 연결된 `survival_status/*`, `companion_state/*` |
| P2 | `scripts/ui/main.gd::_show_top_info_detail()` | 날짜/시간/날씨 상세 패널의 부드러운 열림 | 상단 HUD 클릭 피드백 보강 | `time_weather/*` |
| P2 | `scripts/ui/main.gd::_toggle_tool_menu()` | 인벤토리/제작/도구 메뉴 슬라이드 인, 닫힘 페이드 | 관리 화면의 모드 전환 감각 강화 | 메뉴별 기존 아이콘 |
| P2 | `scripts/ui/main.gd::_start_tool_craft_minigame()` | 제작 시작 전 작업대 이미지 페이드 인 | 미니게임 진입 감각 강화 | `tool_quality/tool_maintenance.png` |
| P2 | `scripts/ui/main.gd::_finish_tool_craft_minigame()` | 제작 품질 등급에 따른 결과 이미지/색상 | 성공, 조잡함, 실패 차이를 빠르게 전달 | `tool_quality/axe_crude.png`, `axe_damaged.png`, `axe_reliable.png` |
| P2 | `scripts/ui/main.gd::_show_event()` / `_play_event_intro()` | 이벤트 진입 블랙아웃, 배지, 짧은 사운드 대응 지점 | 랜덤/스토리 이벤트의 무게감 확보 | 이벤트 성격별 컷신 배경 |
| P2 | `scripts/ui/main.gd::_play_cutscene()` / `_apply_cutscene_step()` | 컷신 배경, 인물 초상, 텍스트 타이핑, 플래시/흔들림 | 스토리 전달력 강화 | 기존 컷신 이미지, 필요 시 생성 이미지 |

## 생성 이미지 추가 연결 후보

이번 추가 생성/배치:

| 파일 | 배치 위치 |
| --- | --- |
| `assets/generated/ui_transition_effects/time_shift.png` | 시간대 전환 배너 |
| `assets/generated/ui_transition_effects/danger_alert.png` | 위험 행동 컷인, 고위험 타일 컨텍스트 배경 |
| `assets/generated/ui_transition_effects/base_transition.png` | 거점 진입 컷인, 거점 컨텍스트 배경 |
| `assets/generated/ui_transition_effects/craft_transition.png` | 제작 컷인 |

아직 활용도가 낮은 자산:

| 자산 묶음 | 넣을 위치 | 이유 |
| --- | --- | --- |
| `time_weather/*` | `_apply_time_flow_visuals()`, `_show_top_info_detail()` | 시간 변화는 행동 가능 여부와 직접 연결되므로 이미지 보강 효과가 크다. |
| `terrain_tiles/*` | `_open_tile_context_menu()`, 하단 타일 정보 패널 | 선택한 장소의 성격을 글보다 빠르게 전달할 수 있다. |
| `danger_signals/*` | `_open_tile_context_menu()`, `_show_action_sensory_bubble()`, 조사/사냥 결과 | 위험이 행동 전에 보이면 선택 부담을 줄일 수 있다. |
| `resource_objects/*` | `_show_item_toast_from_result()`, 하단 필드 물품 요약 | 채집 대상과 획득 결과를 연결해 학습이 빨라진다. |
| `tool_quality/*` | 제작 미니게임 결과, 도구 상세 | 내구도/품질 텍스트를 시각적으로 보완한다. |

## 연출 강도 제한

| 상황 | 권장 길이 | 이유 |
| --- | ---: | --- |
| 일반 채집/이동/줍기 | 0.25-0.45초 | 반복 빈도가 높아 지연감이 생기기 쉽다. |
| 위험 발생/상태 급락 | 0.45-0.75초 | 놓치면 생존 판단이 틀어지므로 조금 더 강해야 한다. |
| 시간대 전환/야간 진입 | 0.6-1.0초 | 계획 변경을 유도해야 한다. |
| 거점 성장/중요 제작 성공 | 0.8-1.2초 | 희소 이벤트라 성취감을 줄 수 있다. |
| 컷신/이벤트 진입 | 0.8-1.5초 | 상호작용 흐름을 잠시 멈추는 것이 허용된다. |

## 구현 순서 제안

1. P0: `_apply_time_flow_visuals()`에 시간/날씨 이미지 배너를 연결한다.
2. P0: `_show_action_delta_toast()`에서 생존 4수치 변화가 큰 경우 강조 규칙을 추가한다.
3. P0: `_open_tile_context_menu()`에 위험/지형 대표 이미지가 들어갈 작은 미리보기 영역을 추가한다.
4. P1: `_show_base_view()`와 `_hide_base_view()`에 거점 진입/퇴장 전환을 추가한다.
5. P1: `_refresh_base_life_scene()`에서 거점 성장 단계 변경 시 크로스페이드를 추가한다.
6. P2: `_toggle_tool_menu()`와 `_show_status_detail()`에 짧은 패널 전환을 추가한다.
