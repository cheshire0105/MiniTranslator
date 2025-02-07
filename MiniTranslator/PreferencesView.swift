//
//  PreferencesView.swift
//  MiniTranslator
//
//  Created by cheshire on 2/1/25.
//

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
        .padding()
        .frame(width: 400, height: 350)
    }
}

@available(macOS 15.0, *)
struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("설정")
                .font(.largeTitle)
                .bold()

            Text("언어 프레임워크 삭제 방법")
                .font(.title2)
                .padding(.bottom, 4)

            VStack(alignment: .leading, spacing: 12) {
                // 1단계
                HStack(alignment: .top, spacing: 8) {
                    Text("1.")
                        .fontWeight(.bold)
                        .frame(width: 24, alignment: .leading)
                    Text("시스템 설정에서 **일반** 탭으로 이동합니다.")
                        .fixedSize(horizontal: false, vertical: true)
                }
                // 2단계
                HStack(alignment: .top, spacing: 8) {
                    Text("2.")
                        .fontWeight(.bold)
                        .frame(width: 24, alignment: .leading)
                    Text("**언어 및 지역** 설정을 선택합니다.")
                        .fixedSize(horizontal: false, vertical: true)
                }
                // 3단계
                HStack(alignment: .top, spacing: 8) {
                    Text("3.")
                        .fontWeight(.bold)
                        .frame(width: 24, alignment: .leading)
                    Text("**번역 언어** 옵션에서 삭제할 언어 프레임워크를 선택합니다.")
                        .fixedSize(horizontal: false, vertical: true)
                }
                // 4단계
                HStack(alignment: .top, spacing: 8) {
                    Text("4.")
                        .fontWeight(.bold)
                        .frame(width: 24, alignment: .leading)
                    Text("삭제 확인 후, 해당 언어 프레임워크가 제거됩니다.")
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .font(.body)
            .foregroundColor(.secondary)

            Divider()

            // 단축키 안내 섹션 추가
            VStack(alignment: .leading, spacing: 8) {
                Text("단축키 안내")
                    .font(.title2)
                    .padding(.bottom, 4)
                HStack {
                    Text("번역 초기화:")
                        .bold()
                    Text("Command + D")
                }
                Text("해당 단축키를 누르면 입력 필드와 번역 결과가 초기화되며, 입력 필드에 자동으로 포커스가 이동합니다.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    // 텍스트가 줄바꿈되도록 고정 사이즈 모디파이어 추가
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
    }
}

@available(macOS 15.0, *)
struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            // 앱 정보 제목 영역
            Text("MiniTranslator")
                .font(.title)
                .bold()

            Text("버전 1.0")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            // 개발자 정보 영역
            VStack(spacing: 4) {
                HStack {
                    Text("개발자:")
                        .bold()
                    Text("cheshire")
                }

                // 홈페이지 링크
                HStack {
                    Text("홈페이지:")
                        .bold()
                    Link("방문하기", destination: URL(string: "https://bento.me/cheshire0105")!)
                        .foregroundColor(.blue)
                }
            }
            .font(.subheadline)

            Divider()

            // 앱 설명 영역
            Text("이 앱은 Apple의 Translation API를 사용하여 오프라인 번역 기능을 제공합니다. (초기 번역 모델은 온라인 다운로드가 필요합니다.)")
                .font(.body)
                .multilineTextAlignment(.center)
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
