import SwiftUI
import Translation
import AppKit // 클립보드 복사용
import NaturalLanguage // 언어 감지용

// Locale.Language에 identifier 프로퍼티 추가
extension Locale.Language {
    var identifier: String {
        return String(describing: self)
    }
}

/// 커스텀 언어 옵션 타입: 표시할 이름과 실제 Locale.Language 값을 함께 보관
struct LanguageOption: Identifiable, Hashable {
    let id: String         // 예: "ko", "en", "ja", "zh-Hans"
    let displayName: String
    let language: Locale.Language
}

@available(macOS 15.0, *)
struct TranslatorContentView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""

    /// "모든 에러 상황"에서 공통으로 표시할 에러 메시지를 담는 변수
    @State private var errorMessage: String?

    /// TranslationSession.Configuration을 관리할 상태 변수
    @State private var translationConfig: TranslationSession.Configuration?
    /// 번역 요청마다 변경될 고유 id (새 configuration 변경 인식용)
    @State private var translationRequestId: Int = 0
    /// 앱 종료 알림 표시 여부
    @State private var showExitAlert: Bool = false
    /// 모델 다운로드 완료 알림 표시 여부
    @State private var showDownloadCompleteAlert: Bool = false

    /// 모델 다운로드 진행 중 알림 표시 여부
    @State private var showDownloadProgressAlert: Bool = false

    /// 모델 다운로드가 끝나면, 실패했던 번역을 재시도할지 여부
    @State private var needToRetryTranslation: Bool = false

    /// **모델 다운로드 진행 중 알림을 이미 한 번 표시했는지** 여부 (앱 내부에서만 사용)
    @State private var didShowDownloadProgressAlert: Bool = false

    // 클립보드 복사 성공 여부 상태 변수 (복사 후 체크 아이콘 표시)
    @State private var didCopy: Bool = false

    // 텍스트 필드에 포커스 여부 상태 (앱 실행 시 자동 포커스용)
    @FocusState private var isTextFieldFocused: Bool

    // 언어 옵션 배열 (예시: 한국어, 영어, 일본어, 중국어 간체)
    private static let languageOptions: [LanguageOption] = [
        LanguageOption(id: "ko", displayName: "한국어", language: Locale.Language(identifier: "ko")),
        LanguageOption(id: "en", displayName: "English", language: Locale.Language(identifier: "en")),
        LanguageOption(id: "ja", displayName: "日本語", language: Locale.Language(identifier: "ja")),
        LanguageOption(id: "zh-Hans", displayName: "中文", language: Locale.Language(identifier: "zh-Hans"))
    ]

    // 다중 언어 지원을 위한 선택 상태
    @State private var sourceOption: LanguageOption = TranslatorContentView.languageOptions[0]
    @State private var targetOption: LanguageOption = TranslatorContentView.languageOptions[1]

    // 언어 감지기 추가
    private let languageRecognizer = NLLanguageRecognizer()

    var body: some View {
        VStack(spacing: 10) {
            // 상단 헤더: 앱 타이틀 + 종료 버튼
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                Spacer()
                Button {
                    showExitAlert = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            // 입력 필드
            VStack(spacing: 4) {
                TextField("번역할 텍스트를 입력하세요", text: $inputText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(nsColor: .textBackgroundColor))
                    )
                    .focused($isTextFieldFocused)
                    .onSubmit { triggerTranslation() }
                    .onAppear { isTextFieldFocused = true }
                    .onChange(of: inputText) { _, newValue in
                        detectLanguage(from: newValue)
                    }
            }

            // 언어 선택 영역 (원본/목적어 + 스왑 버튼)
            HStack(spacing: 4) {
                Picker("", selection: $sourceOption) {
                    ForEach(Self.languageOptions) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)

                Button {
                    swap(&sourceOption, &targetOption)
                } label: {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)

                Picker("", selection: $targetOption) {
                    ForEach(Self.languageOptions) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
            }

            // 번역 결과 영역
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    Text(translatedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(nsColor: .textBackgroundColor))
                )

                // 복사 버튼 (내용이 있을 때만 표시)
                if !translatedText.isEmpty {
                    Button {
                        copyToClipboard(translatedText)
                    } label: {
                        Image(systemName: didCopy ? "checkmark.circle.fill" : "doc.on.doc")
                            .foregroundStyle(.secondary)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                }
            }

            // 버튼 영역
            HStack(spacing: 12) {
                Button {
                    reset()
                } label: {
                    Label("초기화", systemImage: "arrow.counterclockwise")
                }
                .keyboardShortcut("d", modifiers: [.command])
                .buttonStyle(.bordered)

                Button("번역하기") {
                    triggerTranslation()
                }
                .buttonStyle(.borderedProminent)
            }

            // 에러 메시지 표시 (상황에 따라 색상 변경)
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(errorMessage == "입력과 출력 언어가 같아요" ? .secondary : .red)
                    .font(.caption)
            }
        }
        .padding()
        .frame(width: 300)
        // 번역 세션 실행 (configuration 변경 시 새로운 번역 작업 시작)
        .translationTask(translationConfig) { session in
            Task {
                guard !inputText.isEmpty else { return }
                do {
                    let response = try await session.translate(inputText)
                    translatedText = response.targetText
                    errorMessage = nil
                    needToRetryTranslation = false  // 정상 번역 성공했으므로 재시도 불필요
                } catch {
                    errorMessage = "번역을 위한 모델을 다운로드 중 입니다. 잠시만 기다려주세요."
                    needToRetryTranslation = true  // 모델 다운로드 후 재시도 필요
                }
            }
        }
        .id(translationRequestId)
        // 앱 종료 알림
        .alert("앱 종료", isPresented: $showExitAlert) {
            Button("취소", role: .cancel) { }
            Button("종료", role: .destructive) { NSApplication.shared.terminate(nil) }
        } message: {
            Text("정말로 앱을 종료하시겠습니까?")
        }
        // 모델 다운로드 진행 중 알림
        .alert("모델 다운로드 진행 중", isPresented: $showDownloadProgressAlert) {
            Button("확인") { showDownloadProgressAlert = false }
        } message: {
            Text("번역 모델 다운로드가 진행 중입니다. 잠시만 기다려주세요.")
        }
        // 모델 다운로드 완료 알림
        .alert("모델 다운로드 완료", isPresented: $showDownloadCompleteAlert) {
            Button("확인") { }
        } message: {
            Text("번역 모델 다운로드가 완료되었습니다.")
        }
    }

    @available(macOS 15.0, *)
    private func triggerTranslation() {
        translatedText = ""
        errorMessage = nil

        // 소스와 타겟 언어가 같은 경우 안내 메시지 표시
        if sourceOption.id == targetOption.id {
            translatedText = inputText
            errorMessage = "입력과 출력 언어가 같아요"
            return
        }

        translationRequestId += 1
        translationConfig = TranslationSession.Configuration(
            source: sourceOption.language,
            target: targetOption.language
        )

        // 언어 페어링별로 고유한 UserDefaults 키 생성
        let downloadCompleteKey = "didShowDownloadCompleteAlert_\(sourceOption.language.identifier)_\(targetOption.language.identifier)"

        Task {
            let availability = LanguageAvailability()
            while true {
                let status = await availability.status(from: sourceOption.language, to: targetOption.language)

                if status == .supported {
                    if !didShowDownloadProgressAlert {
                        await MainActor.run {
                            showDownloadProgressAlert = true
                            didShowDownloadProgressAlert = true
                        }
                    }
                } else if status == .installed {
                    await MainActor.run {
                        let alreadyShown = UserDefaults.standard.bool(forKey: downloadCompleteKey)
                        if !alreadyShown {
                            showDownloadCompleteAlert = true
                            UserDefaults.standard.set(true, forKey: downloadCompleteKey)
                        }
                        if needToRetryTranslation {
                            translationConfig?.invalidate()
                        }
                    }
                    break
                } else if status == .unsupported {
                    await MainActor.run {
                        errorMessage = "이 언어 페어링은 지원되지 않습니다."
                    }
                    break
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }

    @available(macOS 15.0, *)
    private func reset() {
        inputText = ""
        translatedText = ""
        errorMessage = nil
        translationConfig = nil
        needToRetryTranslation = false
        // 초기화 후 입력 필드에 포커스 부여
        isTextFieldFocused = true
    }

    @available(macOS 15.0, *)
    private func copyToClipboard(_ text: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(text, forType: .string)

        // 복사 성공 시 didCopy를 true로 설정한 뒤, 일정 시간 후 false로 되돌리기
        didCopy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            didCopy = false
        }
    }
    
    // 언어 자동 감지 함수 수정
    private func detectLanguage(from text: String) {
        // 텍스트가 너무 짧으면 감지하지 않음
        guard text.count >= 2 else { return }
        
        languageRecognizer.processString(text)
        guard let dominantLanguage = languageRecognizer.dominantLanguage else { return }
        
        // NLLanguage를 문자열로 변환
        let languageCode = dominantLanguage.rawValue
        
        // 디버깅을 위한 로그
        print("감지된 언어 코드: \(languageCode)")
        
        // 지원하는 언어 중에서 매칭되는 언어 찾기
        // NLLanguage의 한국어 코드는 'ko'이므로 직접 매칭
        var matchedOption: LanguageOption?
        
        switch languageCode {
        case "ko":
            matchedOption = Self.languageOptions.first { $0.id == "ko" }
        case "en":
            matchedOption = Self.languageOptions.first { $0.id == "en" }
        case "ja":
            matchedOption = Self.languageOptions.first { $0.id == "ja" }
        case "zh-Hans", "zh-Hant", "zh":
            matchedOption = Self.languageOptions.first { $0.id == "zh-Hans" }
        default:
            // 기본 매칭 로직
            matchedOption = Self.languageOptions.first(where: { option in
                return option.id == languageCode || option.language.identifier == languageCode
            })
        }
        
        if let matchedOption = matchedOption {
            print("매칭된 언어: \(matchedOption.displayName)")
            
            // 현재 선택된 언어와 다르면 자동으로 변경
            if sourceOption.id != matchedOption.id {
                sourceOption = matchedOption
                print("소스 언어 변경: \(matchedOption.displayName)")
                
                // 소스와 타겟이 같아지면 자동으로 적절한 타겟 언어 선택
                if sourceOption.id == targetOption.id {
                    // 감지된 언어별로 적절한 타겟 언어 설정
                    switch sourceOption.id {
                    case "ko":
                        // 한국어 -> 영어
                        if let englishOption = Self.languageOptions.first(where: { $0.id == "en" }) {
                            targetOption = englishOption
                            print("타겟 언어 변경: 영어")
                        }
                    case "en":
                        // 영어 -> 한국어
                        if let koreanOption = Self.languageOptions.first(where: { $0.id == "ko" }) {
                            targetOption = koreanOption
                            print("타겟 언어 변경: 한국어")
                        }
                    case "ja":
                        // 일본어 -> 한국어
                        if let koreanOption = Self.languageOptions.first(where: { $0.id == "ko" }) {
                            targetOption = koreanOption
                            print("타겟 언어 변경: 한국어")
                        }
                    case "zh-Hans":
                        // 중국어 -> 한국어
                        if let koreanOption = Self.languageOptions.first(where: { $0.id == "ko" }) {
                            targetOption = koreanOption
                            print("타겟 언어 변경: 한국어")
                        }
                    default:
                        // 기본적으로 영어로 설정
                        if let englishOption = Self.languageOptions.first(where: { $0.id == "en" }) {
                            targetOption = englishOption
                            print("타겟 언어 변경: 영어 (기본)")
                        }
                    }
                }
            }
        } else {
            print("매칭되는 언어 없음: \(languageCode)")
        }
        
        // 언어 감지기 초기화 (다음 감지를 위해)
        languageRecognizer.reset()
    }
}

struct TranslatorContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorContentView()
    }
}
