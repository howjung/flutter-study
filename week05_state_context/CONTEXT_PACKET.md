# CONTEXT_PACKET.md - 5주차 작업 맥락 문서

## 1. 목표 (Goal)
- 사용자의 입력(버튼 클릭) 한 번에 즉시 반응하는 완료/취소 상태 토글 기능을 구현한다.
- 원본 상태와 계산값을 명확히 구분하여 불필요한 중복 변수 생성을 방지한다.

## 2. 상태 계약 및 데이터 흐름 (State Contract & Flow)
- **원본 상태 (Source of Truth):** `bool _isCompleted` (기본값: `false`)
- **계산된 값 (Derived State):**
  - `_statusText`: `_isCompleted`가 true이면 "작업 완료됨", false이면 "작업 진행 중"
  - `_statusColor`: `_isCompleted`가 true이면 초록색, false이면 주황색
  - `_buttonText`: `_isCompleted`가 true이면 "취소하기 (원복)", false이면 "완료하기"
- **이벤트 -> 상태 -> UI 흐름도:**
  `[버튼 클릭 이벤트]` ➔ `[_toggleStatus() 실행]` ➔ `[setState()로 _isCompleted 반전]` ➔ `[UI Rebuild 및 Getter를 통한 계산값 갱신]`

## 3. 프로젝트 컨텍스트 지도 (Context Map)
- `lib/main.dart`: UI 화면 구성 및 `StatefulWidget`을 통한 내장 상태 관리

## 4. 제약 조건 (Constraints)
- 외부 상태관리 패키지(Provider, Riverpod, Bloc 등)를 사용하지 않고 Flutter 기본 `setState`만 활용한다.
- 계산 가능한 값을 별도의 원본 변수로 중복 저장하지 않는다. (AC4 준수)

## 5. 인수 조건 (Acceptance Criteria)
- **AC1:** 앱 실행 시 초기 상태(`_isCompleted = false`)와 첫 화면("작업 진행 중")이 정확히 일치한다.
- **AC2:** 버튼 클릭 한 번으로 상태(`true`)와 화면("작업 완료됨")이 동시에 바뀐다.
- **AC3:** 취소 버튼을 누르면 역동작으로 값(`false`)과 화면("작업 진행 중")이 원래대로 원복된다.
- **AC4:** 표시되는 텍스트 및 색상은 원본 변수로 중복 관리하지 않고 getter로 직접 계산한다.
- **AC5:** 작업 맥락의 파일, 제약, AC가 실제 `lib/main.dart` 코드와 일치한다.
- **AC6:** 프롬프트 A/B 비교 관찰 결과를 작성하고 미확인 항목을 명확히 구분한다.
- **AC7:** 상태 기능, 컨텍스트 문서, 화면 증거, flutter analyze 결과가 모두 같은 기능을 가리킨다.