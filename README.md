
# ShareLingo 앱 기획 및 아키텍처 문서

## ✏️ 앱 개요

- **제목**: ShareLingo
- **목적**: 언어교류로 언어학습. 사용자들이 서로 다른 언어로 게시글을 주고받고 자연스럽게 언어를 교환할 수 있는 SNS 앱
- **프로젝트 기간**: 2025년 05월 16일

---

## 📱 화면 및 기능 개요

### 스플래시 화면
- 앱 로딩 시 초기 스플래시 화면

<img src="https://github.com/user-attachments/assets/834622fa-14cd-40d3-9974-ec29424906e8" alt="Screenshot_1748175373" width="300"/>


### BottomNavigationBar
- 홈탭
- 글 작성 탭
- 나의 프로필 탭

### 피드탭 (홈 페이지)
- 게시글 리스트: 사용자 프로필 이미지, 사용자 이름, 모국어 ↔ 배우고 싶은 언어, 글, 사진
 코멘트 버튼, 태그 표시, 무한 스크롤


<img src="https://github.com/user-attachments/assets/b1da6d02-cb9b-47d1-a62f-8419ce1d4589" alt="Screenshot_1748175373" width="300"/>


### 글작성 페이지
- 내용 TextField
- 사진 업로드 버튼
- 태그 선택 (태그 페이지로 이동)
- 게시 버튼
 
<img src="https://github.com/user-attachments/assets/721e2a09-7271-49db-92f7-2ef2ef91baae" alt="Screenshot_1748175373" width="300"/>


### 태그 선택 페이지
- 태그 리스트 표시
  
<img src="https://github.com/user-attachments/assets/a0d71263-46e6-43e7-b15c-f631040bcfe3" alt="Screenshot_1748175373" width="300"/>

### 글 상세 페이지 / 코멘트 페이지
- 게시글 상세: 프로필, 이름, 내용, 사진
- 댓글 리스트: 댓글내용, 작성일
- 하단 댓글 입력창 및 아이콘

<img src="https://github.com/user-attachments/assets/034f9500-cbe1-4628-a5f3-9af9446e024a" alt="Screenshot_1748175373" width="300"/>
<img src="https://github.com/user-attachments/assets/5424c122-91ed-4a34-af42-2bcced054cf2" alt="Screenshot_1748175373" width="300"/>

### 로그인 페이지
- Google 로그인 버튼

<img src="https://github.com/user-attachments/assets/e0883a3c-c68a-46e7-a021-4ed26f52dbf4" alt="Screenshot_1748175373" width="300"/>
<img src="(https://github.com/user-attachments/assets/06bbd7b0-f26d-4b93-839a-62c53a65cb89" alt="Screenshot_1748175373" width="300"/>

### 프로필 수정 페이지
- 이름, 프로필 사진, 모국어, 배우고 싶은 언어, 자기소개 수정

  
<img src="https://github.com/user-attachments/assets/1b1eac50-9a91-4ff7-b201-0e431b022d54" alt="Screenshot_1748175373" width="300"/>


### 프로필 페이지
- 이름, 프로필 사진, 모국어 ↔ 배우고 싶은 언어, 자기소개


<img src="https://github.com/user-attachments/assets/68ef4af9-ccc7-4ff2-9026-acd5cb5b733d" alt="Screenshot_1748175373" width="300"/>
<img src="https://github.com/user-attachments/assets/add82325-c959-4401-8ebd-c74cca78a395" alt="Screenshot_1748175373" width="300"/>


---

## 🏗️ 프로젝트 구조 (Clean Architecture)

```plaintext
lib/
├── app/                             # 앱 전역 설정 (테마 등)
├── core/                            # 예외, 확장, Provider, 유틸 등 공통 기능
├── data/                            # 데이터 소스, DTO, Repository 구현
├── domain/                          # Entity, Repository 추상화, Usecase
├── presentation/                    # UI 계층
│   └── pages/                       # 페이지별 UI 및 ViewModel
├── widgets/                         # 공용 위젯
└── main.dart
```

- **feature 브랜치 전략**: 각자 main에서 feature/기능명 브랜치를 파서 작업 → PR 후 merge → 슬랙 단톡방 공유

---

## ⚙️ 기술 및 기능

### 🔥 기본 아키텍처 및 상태관리
- Clean Architecture: 데이터소스, Repository, Usecase, Entity, Presentation 레이어 분리
- Repository 패턴, 의존성 주입
- Riverpod 상태관리 (auto-dispose로 메모리 최적화)
- Firebase 백엔드 (Firestore, Storage, Auth)

### 🔐 인증 및 사용자 관리
- Google 로그인 (google_sign_in)
- 인증 상태에 따른 자동 리디렉션
- 사용자 프로필 (이름, 이메일, 사진, 자기소개, 위치 등)
- Cloud Functions로 사용자 데이터 변경 시 동기화

### 🚀 온보딩 및 프로필
- 다단계 온보딩 (이름, 언어, 자기소개, 위치 등)
- 위치 기반 VWorld API 연동
- 프로필 유효성 검사 (연령, 언어, 폼 유효성)

### 📝 게시물 작성 및 관리
- 리치 텍스트 입력, 이미지 다중 업로드 (Firebase Storage)
- YOLO 기반 사람 포함 사진 업로드 차단
- 태그 시스템, 게시물 수정/삭제

### 🌐 피드 및 콘텐츠 발견
- 무한 스크롤, 당겨서 새로고침
- 추천/동급생/근처 탭
- 위치 기반 추천 (읍면동 기반)

### 🖼️ 이미지 처리 최적화
- cached_network_image, easy_image_viewer, shimmer
- 이미지 압축 및 최적화

### 👍 소셜 및 상호작용
- 좋아요/댓글 시스템 (실시간 업데이트)
- 댓글 수정/삭제
- 사용자 프로필 연동

### 📊 투표 기능
- 게시물 내 투표 생성, 관리, 결과 표시
- Firestore 트랜잭션으로 투표 무결성 보장

### ☁️ Cloud Functions
- 사용자 프로필 변경 시 게시물/댓글 동기화
- 댓글 수 자동 업데이트
- 데이터 정리 및 무결성

### 🧪 테스트 및 품질 보증
- 단위 테스트, 통합 테스트
- mocktail 사용한 Mock 데이터 관리
- GitHub Actions 통한 CI/CD
- GitHub Secrets로 민감정보 보호

### 🎨 UI/UX 및 디자인
- Material Design, 반응형 레이아웃
- 애니메이션, 키보드 대응
- 스켈레톤 로더, 진행률 표시

### 🚀 성능 최적화
- mounted 체크, use_build_context_synchronously 처리
- Firestore 쿼리 인덱싱
- auto-dispose로 상태관리 최적화

### 🔒 보안 및 개인정보
- Firestore 보안 규칙, 인증 토큰 관리
- 위치 권한 처리

### ⚙️ 설정 및 사용자 지원
- settings_ui로 설정 페이지 구축
- 개발자 연락 기능, Crashlytics로 모니터링

### 📁 Storage 관리
- 사용자별 Firebase Storage 폴더 구조
- 효율적인 이미지 파일 관리

### 🛠️ 사용 기술 및 패키지
- Riverpod, flutter_dotenv, Firebase (Firestore, Auth, Storage, Crashlytics)
- google_sign_in, geolocator, country_flags, tflite_flutter, yolo_helper
- image_picker, url_launcher, emoji_picker_flutter 등

---

## ✅ 팀 협업 규칙
- 기능 개발은 feature/브랜치에서 진행 후 PR
- main에 merge 후, 슬랙 단톡방에 공유
- main 최신화: `git pull origin main`

---
