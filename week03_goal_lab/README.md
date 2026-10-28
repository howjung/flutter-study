# 3주차 과제 - StudyGoal 추가·완료 전환 제출

## 1. 제출 정보
* **GitHub 저장소 링크:** https://github.com/howjung/week03_goal_lab
* **Commit ID:** `6751ec6`
* **Commit Message:** `feat: implement StudyGoal acceptance criteria`

---

## 2. 요구사항 및 AC 문서

### ① 사용자 목표와 스토리
* **기능 이름:** StudyGoal 추가·완료 전환
* **대상 사용자:** 학습 목표를 체계적으로 관리하고 달성 여부를 확인하고 싶은 학생/학습자
* **사용자가 해결하려는 문제:** 계획한 학습 목표를 직관적으로 추가하고, 진행 상황(완료 여부)을 한눈에 파악해 학습 효율을 높이고 싶다.
* **사용자 스토리:**
  > 사용자로서, 새로운 학습 목표를 등록하고 완료한 목표의 상태를 토글하여 변경하기를 원한다. 그래서 나의 학습 진행 상황을 명확히 파악하고 목표를 차근차근 달성할 수 있다.

### ② 기능 범위와 제약
| 항목 | 내용 |
| :--- | :--- |
| **포함 범위** | 1. 텍스트 입력을 통한 새로운 학습 목표 생성 (`_addGoal`)<br>2. 목표 목록의 완료 체크박스 클릭을 통한 상태 전환 (`_toggleGoal`)<br>3. 추가된 목표 목록 화면에 즉시 리렌더링 표시 |
| **제외 범위** | 1. 목표 삭제 및 수정 기능<br>2. 로컬DB/Firebase 등 데이터 영구 저장 (메모리 상태 관리만 진행)<br>3. 목표 카테고리 분류 및 필터링(전체/진행중/완료) 기능 |
| **입력** | 사용자가 입력창에 작성하는 목표 텍스트 (`String`), 체크박스 탭 이벤트 |
| **출력** | 화면 내 `ListTile` 목록 업데이트, Checkbox 상태(Checked/Unchecked) 변경 및 취소선 표시 |
| **예외** | 목표 입력창이 비어있거나 공백만 포함된 경우(`text.trim().isEmpty`) 목록에 추가하지 않음 |
| **UI 제약** | 입력값이 빈 상태로 추가 시도 시 텍스트 필드 하단 스낵바(SnackBar)로 경고 표시 / 완료된 목표는 취소선(`TextDecoration.lineThrough`)과 연한 색상으로 구분 |

### ③ 수용조건과 완료 증거
| 수용조건 | Given / When / Then | 완료 증거 |
| :--- | :--- | :--- |
| **AC1: 정상 입력과 정상 결과** | **Given** 사용자가 학습 목표 입력창을 열고 있다.<br>**When** 목표("2020")를 입력하고 추가 버튼을 누른다.<br>**Then** 입력한 내용이 학습 목표 목록에 추가되고 입력창은 초기화된다. | 실행 화면 스크린샷 (`2020` 등록 확인)<br><br><img width="1312" height="740" alt="image" src="https://github.com/user-attachments/assets/0aa93474-8c9d-4c1b-8267-8e79578f0db8" /> |
| **AC2: 빈 값 또는 오류 결과** | **Given** 사용자가 학습 목표 입력창을 열고 있다.<br>**When** 아무것도 입력하지 않은 상태에서 추가 버튼을 누른다.<br>**Then** 목록에 항목이 추가되지 않으며, "목표를 입력해주세요." 안내 스낵바가 표시된다. | 실행 화면 스크린샷 (하단 스낵바 확인)<br><br><img width="1312" height="740" alt="image" src="https://github.com/user-attachments/assets/586638ec-d4ce-4057-86d7-49daab76b703" /> |
| **AC3: 상태가 바뀌는 결과** | **Given** 목록에 목표("2030") 항목이 uncompleted 상태로 존재한다.<br>**When** 해당 항목의 체크박스를 탭한다.<br>**Then** 체크박스가 체크 처리되고, 텍스트에 취소선 스타일과 연한 색상이 적용된다. | 실행 화면 스크린샷 (`2030` 체크 및 취소선 확인)<br><br><img width="1312" height="740" alt="image" src="https://github.com/user-attachments/assets/7dde92f1-1543-4b43-a56d-1a84be0d9e2c" /> |
