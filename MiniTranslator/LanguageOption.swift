//
//  LanguageOption.swift
//  MiniTranslator
//
//  Created by cheshire on 2/1/25.
//


//
//  TranslatorContentView.swift
//  MiniTranslator
//
//  Created by cheshire on 1/29/25.
//

import SwiftUI
import Translation
import AppKit // 클립보드 복사를 위해 필요

// 커스텀 언어 옵션 타입: 표시할 이름과 실제 Locale.Language 값을 함께 보관
struct LanguageOption: Identifiable, Hashable {
    let id: String         // 예: "ko", "en", "ja", "zh-Hans"
    let displayName: String
    let language: Locale.Language
}

@available(macOS 15.0, *)
struct TranslatorContentView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var errorMessage: String?

    /// TranslationSession.Configuration을 관리할 상태 변수
    @State private var translationConfig: TranslationSession.Configuration?

    /// 번역 요청마다 변경될 고유 id (새 configuration 변경 인식용)
    @State private var translationRequestId: Int = 0

    // 커스텀 언어 옵션 배열 (예시: 한국어, 영어, 일본어, 중국어 간체)
    private static let languageOptions: [LanguageOption] = [
        LanguageOption(id: "ko", displayName: "한국어", language: Locale.Language(identifier: "ko")),
        LanguageOption(id: "en", displayName: "English", language: Locale.Language(identifier: "en")),
        LanguageOption(id: "ja", displayName: "日本語", language: Locale.Language(identifier: "ja")),
        LanguageOption(id: "zh-Hans", displayName: "中文", language: Locale.Language(identifier: "zh-Hans"))
    ]

    // 다중 언어 지원을 위한 선택 상태 (초기값은 languageOptions 배열의 값 사용)
    @State private var sourceOption: LanguageOption = TranslatorContentView.languageOptions[0]
    @State private var targetOption: LanguageOption = TranslatorContentView.languageOptions[1]

    var body: some View {
        VStack(spacing: 12) {
            // 0) 언어 선택 영역
            VStack(spacing: 8) {
                HStack {
                    Text("원본 언어:")
                    Picker("원본 언어", selection: $sourceOption) {
                        ForEach(Self.languageOptions) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 100)
                }
                HStack {
                    Text("번역 언어:")
                    Picker("번역 언어", selection: $targetOption) {
                        ForEach(Self.languageOptions) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 100)
                }
            }

            // 1) 사용자 입력 필드
            TextField("번역할 내용을 입력하세요.", text: $inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    triggerTranslation()
                }

            // 2) 번역 결과 + 복사 버튼
            HStack(alignment: .top, spacing: 8) {
                ScrollView {
                    Text(translatedText)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                }
                .frame(minHeight: 60, maxHeight: 200)

                if !translatedText.isEmpty {
                    Button(action: {
                        copyToClipboard(translatedText)
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.plain)
                    .help("클립보드에 복사")
                }
            }

            // 3) 수동 번역 버튼
            Button("번역하기") {
                triggerTranslation()
            }

            // 4) 에러 메시지 표시
            if let errorMessage {
                Text("에러: \(errorMessage)")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding(12)
        .frame(width: 280)
        // configuration이 변경될 때마다 id가 바뀌도록 해서 새로운 번역 세션을 강제합니다.
        .translationTask(translationConfig) { session in
            Task {
                guard !inputText.isEmpty else { return }
                do {
                    let response = try await session.translate(inputText)
                    translatedText = response.targetText
                    errorMessage = nil
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
        .id(translationRequestId)
    }

    // MARK: - 번역 트리거 및 클립보드 복사 메서드
    @available(macOS 15.0, *)
    private func triggerTranslation() {
        // 이전 번역 결과 및 에러 메시지 초기화
        translatedText = ""
        errorMessage = nil

        // 고유 id를 증가시켜 뷰의 변경을 강제합니다.
        translationRequestId += 1

        // 새로운 TranslationSession.Configuration 인스턴스를 동기적으로 생성하여 할당
        translationConfig = TranslationSession.Configuration(
            source: sourceOption.language,
            target: targetOption.language
        )
    }

    @available(macOS 15.0, *)
    private func copyToClipboard(_ text: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(text, forType: .string)
    }
}

struct TranslatorContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslatorContentView()
    }
}
