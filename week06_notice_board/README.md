# week06_notice_board — 6주차 과제 기록

> 빈칸(`______`)은 직접 관측하거나 직접 써서 채웁니다.
> AI가 실행했다고 쓴 문장은 실제 로그를 대신하지 않습니다. 확인하지 못한 항목은 **미검증**으로 남깁니다.

## 1. 실행 방법

```bash
cd week06_notice_board
flutter pub get
flutter run          # 앱 실행
flutter analyze      # 정적 분석
flutter test         # 위젯 테스트
```

- 구현 파일: `lib/main.dart` (제공된 `starter_main.dart`의 TODO 3곳만 구현)
- 테스트 파일: `test/widget_test.dart` (제공된 `notice_test.dart`, import 패키지명만 변경)
- 패키지 추가: 없음
- 실행 환경: macOS 15.8.1 / Chrome(웹, 스크린샷의 `localhost` 주소) / Flutter 3.47.2 stable (`flutter --version` 출력 기준)
- 의존성 준비 화면: [`pubget`](screenshots/pubget.png)

## 2. AC1–AC5 관측 기록

| AC | 확인 내용 | 관측 결과 | 판정(통과/실패/미검증) | 스크린샷 |
|---|---|---|---|---|
| AC1 | 실패 OFF에서 요청 → 즉시 loading, 진행 표시, 버튼 잠금, 이전 결과·오류 제거 | 요청 직후 `상태: loading`, 요청 횟수 1, 진행 표시와 "공지를 불러오는 중입니다." 문구, 버튼·스위치 비활성 (스크린샷 기준). 이전 결과 제거는 이 사진이 첫 요청이라 확인 못 함 | 일부 통과 / 이전 결과 제거는 미검증 | [`ac1-loading`](screenshots/ac1-loading.png) |
| AC2 | 1초 뒤 success, 공지 본문, 로딩 종료, 버튼 활성화 | `상태: success`, 본문 "6주차 실습 자료가 열렸습니다.", 진행 표시 없음, 버튼 활성화, 요청 횟수 1 (스크린샷 기준) | 통과 | [`ac2-success`](screenshots/ac2-success.png) |
| AC3 | 실패 ON 요청 → failure, 안내 문구, 다시 시도 버튼, 로딩 종료 | 스위치 ON, `상태: failure`, "공지를 불러오지 못했습니다.", "다시 시도" 버튼, 진행 표시 없음, 요청 횟수 2 (스크린샷 기준) | 통과 | [`ac3-failure`](screenshots/ac3-failure.png) |
| AC4 | 실패 OFF로 바꿔 재시도 → 새 loading 뒤 success, 이전 오류 제거 | 스위치 OFF, `상태: success`, 오류 문구 없음, 요청 횟수 3 (스크린샷 기준). 재시도 중간의 loading 화면은 따로 찍지 않음 | 통과 (중간 loading은 미검증) | [`ac4-retry`](screenshots/ac4-retry.png) |
| AC5 | 로딩 중 연속 클릭 → 버튼 잠금, 요청 횟수 한 번만 증가 | loading 상태에서 요청 횟수 1, 버튼 비활성 (스크린샷 기준). 로딩 중 약 4회 연속 클릭 | 통과 | [`ac5-single`](screenshots/ac5-single.png) |

## 3. 로딩·성공·실패·재시도 화면과 중복 클릭 전후 요청 횟수

| 화면 | 스크린샷 파일 | 비고 |
|---|---|---|
| 시작(idle) | [`ac0-idle`](screenshots/ac0-idle.png) | 요청 횟수 0 |
| 로딩 | [`ac1-loading`](screenshots/ac1-loading.png) | 요청 횟수 1 |
| 성공 | [`ac2-success`](screenshots/ac2-success.png) | 요청 횟수 1 |
| 실패 | [`ac3-failure`](screenshots/ac3-failure.png) | 요청 횟수 2 |
| 재시도 | [`ac4-retry`](screenshots/ac4-retry.png) | 요청 횟수 3 |
| 중복 클릭 | [`ac5-single`](screenshots/ac5-single.png) | loading 중 요청 횟수 1 |

중복 클릭 기록:

- 클릭 전 요청 횟수: 0 (새로 시작한 idle 상태, `ac0-idle` 참고)
- 연속 클릭 횟수: 약 4회 (로딩 중 비활성 버튼 클릭, 정확한 횟수는 기록하지 않음)
- 클릭 후 요청 횟수: 1 (`ac5-single`의 loading 화면)
- 판정: 통과 (연속 클릭 뒤에도 요청 횟수가 1에 머묾). 클릭 횟수가 정확하지 않아 "약 4회"로 표시

## 4. 프롬프트 A/B 비교

**미실행.** 요청 A/B를 두 개의 새 대화에서 실제로 보내 비교하지 않았습니다. 응답 차이와 선택 이유를 지어서 쓰지 않기 위해 아래 항목은 모두 **미검증**으로 남깁니다.

- 사용 모델(표시 이름): 미실행
- 사용 시각: 미실행
- 공통 자료와 `starter_main.dart` 전문을 두 대화에 동일하게 제공했는가: 미실행

| 항목 | A의 실제 결과 | B의 실제 결과 | 근거 |
|---|---|---|---|
| TODO 외 변경·새 패키지 | 미검증 | 미검증 | 없음 |
| AC1–AC5 | 미검증 | 미검증 | 없음 |
| await와 오류 설명 | 미검증 | 미검증 | 없음 |
| 미실행의 정확한 표시 | 미검증 | 미검증 | 없음 |

- 선택한 요청: 없음(비교 미실행)
- 이 저장소의 `lib/main.dart`는 A/B 응답을 적용한 것이 아니라, 제공된 `starter_main.dart`의 TODO 3곳을 직접 채운 코드입니다.
- 이 코드는 `flutter analyze`, `flutter test`, 화면 관측(AC1–AC5)으로 검증했습니다(2~3, 5번 참고).

> 한 번의 결과로 모든 AI의 성능을 일반화하지 않습니다. 더 긴 답변을 더 정확한 답변으로 판단하지 않습니다.

실패 기록: 실제 앱 실행에서 AC1–AC5 관측 중 발견한 실패는 없음. (A/B 비교는 미실행이라 해당 없음)

## 5. 도구 계약 — `flutter analyze`

| 항목 | 내용 |
|---|---|
| 목적 | 현재 Dart 코드의 정적 진단 |
| 명령 | `flutter analyze` |
| 입력 | Flutter SDK, 의존성 준비, pubspec.yaml이 있는 프로젝트 폴더 |
| 내 프로젝트 경로 | `~/flutter-study/week06_notice_board` |
| 출력 | 분석 문구, 종료 코드 |
| 오류 구분 | SDK 없음 / 프로젝트 경로 오류 / 의존성 실패 / 코드 분석 오류 |
| 권한 | 프로젝트에서 분석 명령 실행. 소스 자동 수정·배포·외부 업로드 금지 |
| 부작용 | 도구 캐시 갱신 가능. 준비 단계에서 의존성 다운로드 가능 |
| 성공 기준 | 종료 코드 0, 분석 오류 없음 |
| 한계 | 실제 화면 동작은 AC별 실행으로 별도 확인 |

실행 기록:

- 실행 시각: 2026-10-07 약 06:03~06:14 (스크린샷 파일 저장 시각 기준의 근사값, 터미널에 시계 표시 없음)
- 실행 폴더: `week06_notice_board` (스크린샷 터미널 제목 기준)
- 명령 전문: `flutter analyze`
- 종료 코드: 0 (스크린샷 `flutter analyze; echo "exit=$?"` 출력의 `exit=0`: [`flutter-analyze-exit-code`](screenshots/flutter-analyze-exit-code.png))
- 결과 구분: 분석 오류 없음 (`No issues found!`, 종료 코드 0)
- 분석 원문:

```text
(스크린샷으로 대체: [`flutter-analyze_flutter-test`](screenshots/flutter-analyze_flutter-test.png))
스크린샷에 보이는 출력: Analyzing week06_notice_board... / No issues found! (ran in 2.9s)
```

`flutter test` 기록 (선택):

```text
(같은 스크린샷)
스크린샷에 보이는 출력: 테스트 3개(AC1·AC2·AC5 / AC3·AC4 / 확장) 진행 후 All tests passed! (+3)
```

## 6. 자신의 설명

> 이 6번 설명은 AI의 도움을 받아 초안을 작성했고, 제출 전에 본인이 코드(`lib/main.dart`의 `loadNotice`)와 대조해 읽고 수정해야 합니다.

### await 전후의 상태
- await 이전(`setState`로 loading 전환 시점): 이미 loading이면 바로 return해 중복 요청을 막고, 아니면 요청 횟수를 올린 뒤 `setState`로 상태를 `loading`으로 바꾸고 이전 결과(`_notice`)와 오류(`_error`)를 지웁니다. 그래서 요청 직후 진행 표시가 나오고 버튼이 잠깁니다.
- await 동안: `fetchNotice`가 끝나길 기다리는 것은 `loadNotice` 함수의 뒷부분뿐입니다. 앱 전체가 멈추지 않고 화면은 loading으로 유지됩니다. 버튼이 `onPressed: null`이라 눌러도 반응이 없고, 함수 맨 앞의 loading 검사가 한 번 더 막습니다.
- await 이후(`mounted` 확인 뒤 success/failure 전환): 기다리는 사이 화면이 사라졌을 수 있어서 `if (!mounted) return;`으로 확인한 뒤에만 `setState`를 호출합니다. 성공이면 `_notice`를 저장하고 `success`, 실패면 오류 문구를 저장하고 `failure`로 바꿉니다. `setState` 안에서는 await하지 않고 동기 변경만 합니다.

### 오류 처리
- `try/catch`에서 하는 일과 사용자에게 보이는 문구, 로그에만 남기는 내용: 실패 ON이면 `fetchNotice`가 `Exception('NOTICE_UNAVAILABLE')`을 던지고 `catch`가 잡습니다. 사용자 화면에는 "공지를 불러오지 못했습니다."만 보이고, 실제 예외 내용은 `debugPrint`(`NOTICE_LOAD_FAILED: ...`) 로그에만 남깁니다. 내부 오류 ID를 사용자에게 그대로 보여주지 않기 위해서입니다. 실패 뒤에는 "다시 시도" 버튼으로 같은 `loadNotice`를 다시 호출해 복구합니다(AC3, AC4).

### 결과 검증의 한계
- 테스트·analyze가 확인하지 못하는 것, 미검증으로 남긴 것: `flutter analyze`는 코드의 정적 문제만 확인하고 실제 화면 동작은 확인하지 못합니다. `flutter test`는 정해진 시나리오만 확인하며, 통과가 화면에서 직접 본 것을 대신하지 않습니다. 화면 관측에서 미검증으로 남긴 것은 AC1의 "이전 결과 제거"(성공 뒤 재요청 때의 loading 화면을 찍지 않음)와 AC4의 재시도 중간 loading 화면입니다. AC5의 연속 클릭 횟수는 정확히 세지 않은 "약 4회"입니다. 프롬프트 A/B 비교는 실행하지 않았습니다. 모의 서비스(1초 지연)이므로 실제 네트워크 오류나 지연은 검증하지 못했습니다.

### 교재 이해 확인
- Future와 Stream의 차이: Future는 나중에 값 하나(또는 오류 하나)를 한 번 돌려주고, Stream은 값이 시간에 따라 여러 번 이어서 옵니다.
- 동시성과 병렬성의 차이: 동시성은 여러 작업을 번갈아 진행하며 겹쳐 다루는 것이고, 병렬성은 여러 작업이 실제로 같은 시간에 동시에 실행되는 것입니다.
- 공지 요청에 Future가 맞는 이유: 공지는 한 번 요청해서 결과 하나(본문 또는 오류)를 받는 작업이라 Future가 맞습니다. 값이 계속 갱신되는 작업이 아닙니다. 기다리는 동안 UI가 멈추지 않는 것도 필요한 조건입니다.
- async만으로 CPU 계산이 다른 isolate로 이동하지 않는 이유: `async`/`await`는 기다리는 시간 동안 다른 작업이 진행되게 해 줄 뿐, 코드를 다른 스레드나 isolate로 옮기지 않습니다. 무거운 CPU 계산은 `async` 함수 안에서도 같은 isolate에서 실행되어 UI를 막을 수 있어서, 필요하면 `Isolate`를 직접 써야 합니다.

### 선택 활동
- StreamController / isolate 예제 실행 여부, 실제 출력, 플랫폼: 미실행
- 속도 개선을 측정한 것처럼 쓰지 않습니다.

## 7. 제출 링크

- 개인 GitHub 저장소: https://github.com/howjung/flutter-study (개인 학습용, 주차별 실습·과제 모음)
- 제출 대상 폴더: `week06_notice_board/`
- 제출 commit 링크: ______
- 제출 commit의 코드와 검증한 코드가 일치함을 확인: `lib/main.dart`와 `test/widget_test.dart`를 수정하지 않은 채 같은 commit에 포함함 (`flutter analyze` 종료 코드 0, `flutter test` 통과 후 변경 없음)
