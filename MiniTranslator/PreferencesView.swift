import SwiftUI

@available(macOS 15.0, *)
struct PreferencesView: View {
    var body: some View {
        TabView {
            SettingsView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        // 전반적인 탭 뷰 크기 조정 (필요에 맞게 수정 가능)
        .frame(width: 380, height: 320)
    }
}

// MARK: - SettingsView
@available(macOS 15.0, *)
struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("설정")
                .font(.title)
                .bold()

            // 언어 프레임워크 삭제 안내
            VStack(alignment: .leading, spacing: 8) {
                Text("언어 프레임워크 삭제 방법")
                    .font(.headline)

                // 단계별 안내를 라벨(아이콘) 형태로 간소화
                VStack(alignment: .leading, spacing: 6) {
                    Label("시스템 설정에서 **일반** 탭으로 이동합니다.", systemImage: "1.circle.fill")
                    Label("**언어 및 지역** 설정을 선택합니다.", systemImage: "2.circle.fill")
                    Label("**번역 언어** 옵션에서 삭제할 언어 프레임워크를 선택합니다.", systemImage: "3.circle.fill")
                    Label("삭제 확인 후, 해당 언어 프레임워크가 제거됩니다.", systemImage: "4.circle.fill")
                }
                .font(.body)
                .foregroundColor(.secondary)
            }

            Divider()

            // 단축키 안내 섹션
            VStack(alignment: .leading, spacing: 8) {
                Text("단축키 안내")
                    .font(.headline)

                // 구체적인 단축키 설명
                VStack(alignment: .leading, spacing: 4) {
                    Text("• 번역 초기화: Command + D")
                        .font(.callout)
                    Text("해당 단축키를 누르면 입력 필드와 번역 결과가 초기화되며, 입력 필드에 자동 포커스가 이동합니다.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - AboutView
@available(macOS 15.0, *)
struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("MiniTranslator")
                .font(.title)
                .bold()

            Text("버전 1.0")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            // 개발자 정보
            VStack(spacing: 6) {
                Label("cheshire", systemImage: "person.fill")
                    .font(.subheadline)
                HStack(spacing: 4) {
                    Image(systemName: "globe")
                    Text("홈페이지:")
                    Link("방문하기", destination: URL(string: "https://bento.me/cheshire0105")!)
                }
                .font(.subheadline)
            }

            Divider()

            // 앱 설명
            Text("이 앱은 Apple의 Translation API를 사용하여 오프라인 번역 기능을 제공합니다. (초기 번역 모델은 온라인 다운로드가 필요합니다.)")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
