# 4주차 과제: 모바일 화면과 결정 근거표

## 1. 화면 제약표 (Layout constraints)

| 항목 | 좁은 화면 (360px) | 넓은 화면 (800px) |
|---|---|---|
| **사용 가능 폭** | 360px | 800px |
| **열 수 (Columns)** | 1열 | 2열 |
| **바깥 여백 (Padding)** | 16px | 16px |
| **카드 간격 (Spacing)** | 16px | 16px |
| **긴 텍스트 처리** | Card 내 Column/Expanded로 가로 오버플로 방지 및 줄바꿈 처리 | 2열 카드 공간 내 자동 줄바꿈 및 말줄임표 처리 |

---

## 2. 결정 근거표 (Decision Evidence)

| 판단 | 근거 위치 | 확인 내용 | 적용 이유 |
|---|---|---|---|
| **LayoutBuilder 선택** | Flutter 공식 문서 (`Adaptive layout general approach`) / 교재 2.7 | 전체 화면 크기(`MediaQuery`)가 아닌 부모 위젯의 지역 `BoxConstraints.maxWidth`를 기준으로 열 수를 분기해야 함을 확인 | 600px 경계값을 기준으로 600px 미만 시 1열, 이상 시 2열 그리드로 전환하도록 구현 |
| **ValueKey(goal.id) 선택** | Flutter API (`Key` class) / 교재 2.8 | 배열 인덱스는 재정렬 시 위치가 바뀌므로 식별자로 부적절하며, 데이터의 고유 식별자(ID)를 위젯의 Key로 연결해야 Element와 State가 정상 매칭됨을 확인 | 순서 뒤집기 실행 후에도 입력한 TextField 메모 상태가 해당 `goal.id` 카드를 따라 유지되도록 설정 |
| **ValueKey 적용 코드** | `lib/main.dart`의 `GridView.builder` `itemBuilder` | `StudyCard` 위젯 생성 시 `key: ValueKey(goal.id)` 전달 | 안정적인 ID 전달로 위젯 트리 재구성 시 데이터 식별 유지 |

---

## 3. 제출 전 검증 체크리스트 (Verification)

- [x] **AC1**: 360px 폭 실행 시 1열 배치 및 가로 오버플로(`RenderFlex overflow`) 없음
- [x] **AC2**: 800px 폭 실행 시 2열 배치 및 카드 간격 16px 유지
- [x] **AC3**: 각 카드의 메모란에 글자 입력 후 `순서 뒤집기` 클릭 시, 메모가 화면 위치가 아닌 해당 `goal.id` 카드에 유지됨
- [x] **`flutter analyze`**: 경고(Warning) 및 오류(Error) 없이 0 issues 통과 완료
- [x] **보안 검증**: 개인 식별 정보, 비밀번호, API 토큰 미포함 확인