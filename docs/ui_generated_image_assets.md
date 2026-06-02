# UI 전달 강화 이미지 생성 결과

생성 방식: Codex built-in `image_gen`

저장 위치: `assets/generated/ui_signal_assets/`

목표는 기본 UI 정보를 대체하는 것이 아니라, 텍스트와 수치만으로 전달이 약한 순간에 보조 이미지로 즉시 인지시키는 것이다.

## 생성 자산 요약

| 분류 | 개수 | 용도 |
| --- | ---: | --- |
| 행동 결과 | 4 | 행동 완료 후 결과 패널/컷인 |
| 생존 상태 신호 | 4 | 상태 악화 알림, 초상화 보조 이미지 |
| 시간/날씨 | 4 | 시간대 HUD, 맵 분위기, 야간/폭풍 경고 |
| 위험 신호 | 4 | 타일 위험도, 조사 결과, 기억 배지 상세 |
| 자원 오브젝트 | 4 | 채집 대상, 하단 필드 정보, 오브젝트 상세 |
| 거점 성장 | 4 | 거점 화면 배경, 성장 단계 피드백 |
| 도구 품질 | 4 | 도구 상세, 제작 결과, 파손 경고 |
| 동료 상태 | 4 | 동료 패널, 관계/분담 상태 피드백 |
| 타일 대표 | 4 | 하단 타일 미리보기, 신규 지형 후보 |
| 전환/연출 배경 | 4 | 시간 전환, 위험 경고, 거점 진입, 제작 결과 컷인 |

전체 확인용 오버뷰:

- `assets/generated/ui_signal_assets/_overview.png`

원본 시트:

- `assets/generated/ui_signal_assets/sheets/action_results_sheet.png`
- `assets/generated/ui_signal_assets/sheets/survival_status_sheet.png`
- `assets/generated/ui_signal_assets/sheets/time_weather_sheet.png`
- `assets/generated/ui_signal_assets/sheets/danger_signals_sheet.png`
- `assets/generated/ui_signal_assets/sheets/resource_objects_sheet.png`
- `assets/generated/ui_signal_assets/sheets/base_growth_sheet.png`
- `assets/generated/ui_signal_assets/sheets/tool_quality_sheet.png`
- `assets/generated/ui_signal_assets/sheets/companion_state_sheet.png`
- `assets/generated/ui_signal_assets/sheets/terrain_tiles_sheet.png`

전환/연출 원본 시트:

- `assets/generated/ui_transition_effects/sheets/transition_backdrops_sheet.png`

## 개별 자산

### 행동 결과

| 파일 | 권장 사용처 |
| --- | --- |
| `action_results/water_found.png` | 물 발견, 샘 조사 성공 |
| `action_results/food_gathered.png` | 채집 성공, 식량 확보 |
| `action_results/trap_success.png` | 덫 확인 성공, 사냥 보상 |
| `action_results/tool_broken.png` | 도구 파손, 제작/행동 실패 경고 |

### 생존 상태 신호

| 파일 | 권장 사용처 |
| --- | --- |
| `survival_status/dehydration.png` | 수분 위험, 탈수 알림 |
| `survival_status/hunger.png` | 허기 위험, 음식 부족 |
| `survival_status/exhaustion.png` | 기력 저하, 피로 누적 |
| `survival_status/wet_cold.png` | 젖음, 체온 저하, 비 노출 |

주의: 체력/기력/허기/수분 미터를 대체하지 않는다. 이 이미지는 위험 상태를 강조하는 보조 피드백으로만 사용한다.

### 시간/날씨

| 파일 | 권장 사용처 |
| --- | --- |
| `time_weather/dawn.png` | 새벽/일출 분위기 |
| `time_weather/noon_heat.png` | 낮/고온/시야 좋음 |
| `time_weather/dusk.png` | 해질녘, 야간 전환 경고 |
| `time_weather/night_storm.png` | 밤, 폭풍, 저시야 경고 |

### 위험 신호

| 파일 | 권장 사용처 |
| --- | --- |
| `danger_signals/animal_tracks.png` | 짐승 흔적, 수렵 위험 |
| `danger_signals/poisonous_berries.png` | 독성 식물, 채집 위험 |
| `danger_signals/stagnant_water.png` | 오염수, 질병/탈수 리스크 |
| `danger_signals/unstable_rocks.png` | 낙상/부상 위험 |

### 자원 오브젝트

| 파일 | 권장 사용처 |
| --- | --- |
| `resource_objects/berry_bush.png` | 베리 덤불 |
| `resource_objects/freshwater_spring.png` | 담수 샘 |
| `resource_objects/driftwood_pile.png` | 표류목/나뭇가지 |
| `resource_objects/stone_outcrop.png` | 돌무더기/점토/석재 |

### 거점 성장

| 파일 | 권장 사용처 |
| --- | --- |
| `base_growth/camp_bare.png` | 미개발 야영지 |
| `base_growth/camp_fire_shelter.png` | 불/임시 쉘터 |
| `base_growth/camp_improved.png` | 침상/빗물받이/보관함 |
| `base_growth/camp_refuge.png` | 안정된 거점 |

### 도구 품질

| 파일 | 권장 사용처 |
| --- | --- |
| `tool_quality/axe_crude.png` | 조잡한 도끼 |
| `tool_quality/axe_damaged.png` | 손상된 도끼 |
| `tool_quality/axe_reliable.png` | 안정적인 도끼 |
| `tool_quality/tool_maintenance.png` | 정비/수리/제작 준비 |

### 동료 상태

| 파일 | 권장 사용처 |
| --- | --- |
| `companion_state/companion_trust.png` | 신뢰/협력 |
| `companion_state/companion_anxious.png` | 불안/거리감 |
| `companion_state/companion_separated.png` | 따로 행동 중 |
| `companion_state/companion_relieved.png` | 안도/회복 |

주의: 이 묶음은 캐릭터 고정 초상화가 아니라 관계 상태를 상징하는 장면이다. 동료 초상화를 대체하기보다 대화/상태 결과 패널에 쓰는 편이 안전하다.

### 타일 대표

| 파일 | 권장 사용처 |
| --- | --- |
| `terrain_tiles/cliff_ledge.png` | 암벽/절벽 지형 |
| `terrain_tiles/ruined_marker.png` | 오래된 표식/단서 지형 |
| `terrain_tiles/jungle_trail.png` | 어두운 숲길/저시야 지형 |
| `terrain_tiles/base_clearing.png` | 거점 후보 공터 |

### 전환/연출 배경

| 파일 | 권장 사용처 |
| --- | --- |
| `assets/generated/ui_transition_effects/time_shift.png` | 시간대 전환 배너 |
| `assets/generated/ui_transition_effects/danger_alert.png` | 위험 행동 컷인, 고위험 타일 선택 배경 |
| `assets/generated/ui_transition_effects/base_transition.png` | 거점 진입 컷인, 거점 컨텍스트 배경 |
| `assets/generated/ui_transition_effects/craft_transition.png` | 제작 컷인, 제작 결과 연출 |

## 다음 연결 우선순위

완료:

1. 행동 컷인 배경에 `action_results/*`, `danger_signals/*`, `resource_objects/*`, `tool_quality/*`, `companion_state/*`를 상황별로 연결했다.
2. 상태 상세 패널에 `survival_status/*`와 `companion_state/*`를 보조 이미지로 연결했다.
3. 거점 화면의 생활 장면 배경에 `base_growth/*`를 배치 시설 상태별로 연결했다.
4. 시간대 전환 배너에 `time_weather/*`와 `ui_transition_effects/time_shift.png`를 연결했다.
5. 타일 컨텍스트 메뉴 배경에 `terrain_tiles/*`, `danger_signals/*`, `resource_objects/*`, `ui_transition_effects/danger_alert.png`, `ui_transition_effects/base_transition.png`를 연결했다.
6. 생존 수치 변화 토스트에서 위험 변화가 큰 경우 `survival_status/*`를 강조 아이콘으로 사용한다.
7. 거점 진입/퇴장 화면에 짧은 페이드/슬라이드 전환을 추가했다.

남은 연결 후보:

1. 위험 타일/기억 배지 상세에 `danger_signals/*`를 더 직접적으로 연결한다.
2. 기존 오브젝트 아이콘보다 큰 상세 이미지가 필요할 때 `resource_objects/*`를 하단 필드 정보에 연결한다.
