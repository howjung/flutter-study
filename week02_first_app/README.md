# 2주차 과제 - 첫 Flutter 실행 증거 묶음

## 1. 개발환경 체크리스트 및 진단 결과

### 필수 체크리스트
- [x] `git --version` 실행 확인
- [x] `flutter --version` 실행 확인
- [x] `flutter doctor -v` 실행 결과를 통한 Android 개발 환경 상태 파악
- [x] `flutter devices` 실행 대상 확인 (Chrome 등)

### `flutter doctor -v` 진단 및 분석
<img width="1340" height="973" alt="image" src="https://github.com/user-attachments/assets/3de085fd-6511-49e1-bfbe-1263a7e2072c" />

* **경고/오류 판단:** `flutter doctor -v` 실행 결과, Chrome 웹 개발 환경은 정상(`[✓]`)이나 Android toolchain/SDK 미설치(`[✗]`)로 판단되었습니다.
* **다음 행동:** 이번 주차 웹 실행 검증 완료 후, 3주차 실습 전까지 Android Studio 설치 및 Android SDK 커맨드라인 툴 설정을 완료하여 재진단할 예정입니다.

---

## 2. 첫 앱 실행 결과

* **프로젝트 이름:** `week2_first_app`
* **실행 명령:** `flutter run -d chrome`
* **Device 이름/ID:** Chrome (`chrome`)
* **실행 시각:** 2026-09-08 12:55:55
* **변경 문구:** 본인 맞춤 안내 및 첫 Flutter 앱 실행 확인 문구 변경

<img width="1312" height="1008" alt="스크린샷 2026-09-08 12 55 55" src="https://github.com/user-attachments/assets/d5040b71-a5b2-4b9b-9beb-002685c67d32" />

---

## 3. GitHub 저장소 및 첫 Commit 정보

* **본인 소유 저장소 링크:** https://github.com/howjung/week2_first_app
* **Commit ID:** `e1b9891`
* **Commit Message:** `chore: verify first Flutter run`

---

## 4. 학습기록

| 항목 | 작성 내용 |
| :--- | :--- |
| **목표** | macOS 환경에서 Flutter 개발 환경을 진단하고, 웹(Chrome) 대상을 통해 첫 Flutter 앱을 정상 실행하려 했다. |
| **관찰** | `flutter doctor -v` 실행 결과 Chrome 및 VS Code 환경은 정상이나, Android toolchain이 미설치(`[✗]`)된 것을 보았다. |
| **원인** | Android Studio 및 SDK 커맨드라인 툴 환경이 아직 완료되지 않아 Android 타겟 연결에 미설치 항목이 확인되었다. |
| **행동** | 우선 동작 가능한 Chrome 환경(`-d chrome`)으로 앱 실행을 검증하고, `main.dart` 문구를 수정한 뒤 Git 커밋 및 GitHub 푸시를 수행했다. |
| **결과** | Chrome 브라우저에서 변경된 문구가 정상 반영된 Flutter 첫 앱 동작 증거 및 Commit 기록을 확보했다. |
| **다음** | 3주차 강의 시작 전까지 Android Studio 및 SDK 환경 설정을 마무리하고 `flutter doctor -v`로 Android 개발 환경을 다시 진단할 예정이다. |
