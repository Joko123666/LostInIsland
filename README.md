# LostInIsland

Godot 4.6 기반의 섬 생존 게임 프로토타입입니다. 플레이어는 조사, 채집, 제작, 휴식, 수면, 거점 관리, 파트너 상호작용을 통해 섬에서 생존합니다.

## Shared Context

새 대화나 새 작업 세션에서 이어서 작업할 때는 먼저 [docs/SHARED_CONTEXT.md](docs/SHARED_CONTEXT.md)를 읽습니다.

## Requirements

- Godot `4.6.3-stable`
- Git

Windows 로컬 검증에 사용한 실행 파일 예:

```powershell
C:\Users\lockd\Desktop\Godot_v4.6.3-stable_win64_console.exe
```

## Run

Godot 에디터에서 [project.godot](project.godot)을 열거나, 콘솔에서 실행합니다.

```powershell
Godot_v4.6.3-stable_win64_console.exe --path .
```

## Test

프로젝트 로드 검증:

```powershell
Godot_v4.6.3-stable_win64_console.exe --headless --path . --editor --quit
```

스모크 테스트:

```powershell
Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/three_day_survival_smoke.gd
Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/time_adjustment_smoke.gd
Godot_v4.6.3-stable_win64_console.exe --headless --path . --script scripts/tests/wall_reveal_smoke.gd
```

각 테스트가 성공하면 다음 문자열을 출력합니다.

- `THREE_DAY_SURVIVAL_SMOKE_OK`
- `TIME_ADJUSTMENT_SMOKE_OK`
- `WALL_REVEAL_SMOKE_OK`

## Project Structure

- [scenes/main/Main.tscn](scenes/main/Main.tscn): 메인 UI 씬
- [scripts/ui/main.gd](scripts/ui/main.gd): 핵심 UI 구성과 상호작용
- [scripts/managers](scripts/managers): 게임 상태, 월드, 인벤토리, 캐릭터, 제작, 거점 매니저
- [scripts/tests](scripts/tests): 헤드리스 검증 스크립트
- [data](data): 아이템, 레시피, 이벤트, 지역 데이터
- [assets](assets): 아이콘, 타일, 캐릭터, 연출 이미지
- [docs](docs): UI 방향, 정보 우선순위, 현재 구조 문서

## Git Notes

다음 경로는 로컬 생성물로 취급해 Git에서 제외합니다.

- `.godot/`
- `build/`
- `saves/`

현재 큰 이미지 파일은 GitHub 단일 파일 제한보다 작으므로 Git LFS는 필수가 아닙니다. 향후 50MB 이상 자산이 늘어나면 LFS 도입을 검토합니다.
