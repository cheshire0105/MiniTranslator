# MiniTranslator

**MiniTranslator**는 macOS에서 동작하는 간단한 **메뉴바 번역기**입니다.  
Apple이 WWDC24에서 공개한 오프라인 번역 API(Translation)를 활용하여, **초기 모델 다운로드 이후 오프라인으로 빠르고 안전하게 번역**할 수 있습니다.

이 앱은 **Mac App Store**에서도 다운로드할 수 있으며, 오픈 소스로도 공개되어 있어, 원하시는 경우 직접 빌드하고 커스터마이징하실 수도 있습니다.

<br>

## 주요 기능

- **메뉴바 앱**: 상태 표시줄(메뉴바)에 위치하여 손쉽게 접근 가능  
- **오프라인 번역 지원**: Apple이 제공하는 번역 모델을 다운로드하면 인터넷 연결이 없이도 동작  
- **자동 포커스**: 앱(또는 팝오버)이 열리면 즉시 입력 필드에 커서가 위치하여 빠른 번역 가능  
- **다국어 간 번역**: 한국어, 영어, 일본어, 중국어(간체) 간 번역 지원  
- **클립보드 복사**: 번역된 텍스트를 버튼 한 번으로 복사 가능 (복사 성공 시 체크 아이콘 표시)  
- **초기화 기능**: Command + D 단축키 또는 초기화 버튼을 눌러 입력 필드와 번역 결과를 빠르게 리셋  
- **환경설정(Preferences)**: 
  - 번역 언어 모델 삭제 방법 안내  
  - 단축키 정보 안내  
  - 앱 정보(About) 및 개발자 정보  

<br>

## 스크린샷

> 본 레포지토리에서는 간단한 코드 예제와 UI가 포함되어 있습니다.  
> 실제 실행 시에는 아래처럼 메뉴바에 아이콘이 표시되고, 클릭 시 간단한 팝오버 창으로 MiniTranslator가 실행됩니다.


아래는 MiniTranslator의 스크린샷입니다:

| 스크린샷 1 | 스크린샷 2 | 스크린샷 3 |
|------------|------------|------------|
| ![Macbook Pro - Dark Background (5)](https://github.com/user-attachments/assets/ede7440a-c5f3-449c-80c5-872b76231f7a) | ![Macbook Pro - Dark Background (4)](https://github.com/user-attachments/assets/6232a87c-f344-492a-9b92-22771c4bb25f) | ![Macbook Pro - Dark Background (3)](https://github.com/user-attachments/assets/394358f3-39b2-4d4c-9a16-b35bfac85698) |


<br>

## 설치 방법

### 1. Mac App Store에서 다운로드

- **Mac App Store**에서 “MiniTranslator”를 검색하세요.  
- 다운로드 후 메뉴바 아이콘을 클릭하면 바로 사용할 수 있습니다.

### 2. 소스 코드로 직접 빌드하기

1. 이 레포지토리를 클론(clone)합니다:
    ```bash
    git clone https://github.com/cheshire0105/MiniTranslator.git
    cd MiniTranslator
    ```
2. **Xcode**에서 `MiniTranslator.xcodeproj`(또는 `.xcworkspace`)을 열고,  
   **macOS 15.0** 이상에 맞춰 빌드 타겟을 설정합니다. (SwiftUI의 최신 기능 사용)
3. 빌드 후 앱을 실행하면 메뉴바에 아이콘이 나타납니다.

<br>

## 사용 방법

1. **메뉴바 아이콘**(지구본 아이콘)을 클릭하면 팝오버(Popover) 형태의 간단한 번역 창이 열립니다.
2. 상단 텍스트 필드에 번역할 문장을 입력하고 `Enter`(또는 “번역하기” 버튼)를 누르면 결과가 하단에 표시됩니다.
3. **언어 선택**: 원본 언어와 번역 언어를 각각 설정할 수 있습니다.  
   - 기본값은 한국어 → 영어입니다.  
   - 좌우 화살표 버튼으로 즉시 언어 쌍을 뒤바꿀 수도 있습니다.
4. **결과 복사**: 번역 결과 오른쪽 상단의 복사 버튼을 클릭하면 클립보드에 결과가 저장됩니다.  
   - 복사 시 버튼 아이콘이 잠시 체크 표시로 바뀝니다.
5. **초기화**: 
   - Command + D 단축키  
   - 또는 “초기화” 버튼  
   - 입력 필드와 번역 결과를 모두 지우고 다시 포커스를 입력 필드에 둡니다.
6. **환경설정**: Mac 메뉴바에서 “MiniTranslator > 환경설정(Preferences)”를 선택하면  
   - 언어 모델 삭제 방법,  
   - 단축키 안내,  
   - 앱 및 개발자 정보  
   등을 확인할 수 있습니다.

<br>

## 언어 모델 다운로드

- WWDC24에서 공개된 **Apple Translation API**는 처음 사용 시 필요한 언어 쌍 모델을 자동으로 다운로드합니다.  
- 모델 다운로드 진행 중에는 “번역 모델 다운로드 중”이라는 메시지가 표시됩니다.  
- 다운로드가 완료되면 “모델 다운로드가 완료되었습니다” 알림이 나타납니다.  
- 한 번 다운로드한 언어 모델은 오프라인 환경에서도 계속해서 번역에 사용됩니다.

<br>

## 언어 모델 삭제 방법

시스템에 다운로드된 번역 모델을 삭제하고 싶다면 다음 절차를 따르세요. (macOS 시스템 설정 기준)

1. **시스템 설정**에서 **일반** 탭으로 이동  
2. **언어 및 지역**을 선택  
3. **번역 언어** 옵션에서 삭제할 언어 프레임워크 선택  
4. 삭제 확인 후 모델 제거

자세한 내용은 앱의 **환경설정** → **설정** 탭에서도 확인할 수 있습니다.

<br>

## 기술 스택

- **SwiftUI** (macOS 15.0 이상)  
- **Translation 프레임워크** (Apple)  
- **Menu Bar App**: `NSStatusBar`, `NSStatusItem`, `NSPopover` 활용  
- **Concurrency**: `async/await` 기반의 비동기 번역 처리  
- **UserDefaults**: 언어 모델 다운로드 완료 여부 저장  

<br>

## 기여하기 (Contributing)

오픈 소스로 공개된 프로젝트이므로, 누구나 자유롭게 이슈를 등록하고 PR(Pull Request)을 열어 개선안을 제안할 수 있습니다.

1. 레포지토리를 포크(Fork)하고 로컬에 클론(Clone)  
2. 새로운 브랜치에서 수정 및 추가 기능 구현  
3. 변경 사항을 커밋 후 원격 저장소에 푸시(Push)  
4. 본 레포지토리로 Pull Request 생성  

<br>

## 라이선스

MiniTranslator는 [MIT License](LICENSE) 하에 배포됩니다.  
자세한 사항은 라이선스 파일을 참고하세요.

<br>

## 문의

- **개발자**: [cheshire](https://bento.me/cheshire0105)  
- 이메일 문의: \[개발자 이메일 또는 연락처\]  
- 버그 신고나 기능 제안은 [Issues](../../issues) 탭을 이용해주세요.
- 앱스토어 링크 [MiniTranslator](https://apps.apple.com/kr/app/minitranslator/id6741555755?mt=12)  

<br>

---

**감사합니다!** MiniTranslator와 함께 빠르고 편리한 오프라인 번역을 경험해보세요.  
