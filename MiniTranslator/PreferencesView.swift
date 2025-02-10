import SwiftUI

@available(macOS 15.0, *)
struct PreferencesView: View {
    var body: some View {
        TabView {
            SettingsView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        // 탭 뷰 전체 크기 (필요에 따라 수정)
        .frame(width: 380, height: 320)
    }
}

// MARK: - SettingsView
@available(macOS 15.0, *)
struct SettingsView: View {
    var body: some View {
        // 내용이 많을 경우 스크롤하여 볼 수 있도록 ScrollView로 감쌉니다.
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 타이틀
                Text("Help")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 4)

                // 언어 프레임워크 삭제 안내 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("언어 프레임워크 삭제 방법")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "1.circle.fill")
                            Text("시스템 설정에서 **일반** 탭으로 이동합니다.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "2.circle.fill")
                            Text("**언어 및 지역** 설정을 선택합니다.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "3.circle.fill")
                            Text("**번역 언어** 옵션에서 삭제할 언어 프레임워크를 선택합니다.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "4.circle.fill")
                            Text("삭제 확인 후, 해당 언어 프레임워크가 제거됩니다.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                    }
                }

                Divider()

                // 단축키 안내 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("단축키 안내")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 번역 초기화: Command + D")
                            .font(.callout)
                            .lineLimit(nil)
                        Text("입력 필드와 번역 결과가 초기화되며, 입력 필드에 자동 포커스가 이동합니다.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                }

                Divider()

                // 오프라인 다운로드 안내 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("다운로드 안내")
                        .font(.headline)
                    Text("이 앱은 Apple의 Translation API를 사용하여 오프라인 번역 기능을 제공합니다.\n(초기 번역 모델은 온라인 다운로드가 필요합니다.)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }

                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - AboutView
// MARK: - AboutView
@available(macOS 15.0, *)
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 타이틀
                Text("About")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 4)

                // 앱 정보 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("앱 정보")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("MiniTranslator")
                            .font(.body)
                            .bold()
                        Text("버전 1.2")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("간단하고 빠른 번역을 위한 맥용 미니 번역기")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                }

                Divider()

                // 개발자 정보 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("개발자 정보")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Image("developerImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("cheshire")
                                .font(.body)
                                .bold()
                            Text("Dev, Design and Coffee, Swim")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Divider()

                // 연락처 섹션
                VStack(alignment: .leading, spacing: 8) {
                    Text("연락처")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 12) {
                        Link(destination: URL(string: "https://bento.me/cheshire0105")!) {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                Text("홈페이지")
                                    .font(.body)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }

                        Link(destination: URL(string: "mailto:blackwinter0105@gmail.com")!) {
                            HStack(spacing: 8) {
                                Image(systemName: "envelope")
                                Text("이메일")
                                    .font(.body)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }

                Divider()

                // 저작권 정보
                Text("© 2024 cheshire. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
    }
}
