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
        .frame(width: 400, height: 300)
    }
}

@available(macOS 15.0, *)
struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("설정")
                .font(.largeTitle)
                .bold()

            Text("언어 프레임워크 삭제는\n설정 → 일반 → 언어 및 지역 → 번역 언어 → 에서 삭제 가능 합니다.")
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding()
    }
}

@available(macOS 15.0, *)
struct AboutView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("MiniTranslator")
                .font(.title)
                .bold()
            Text("버전 1.0")
                .font(.subheadline)
            Text("개발자: cheshire")
                .font(.subheadline)
            Text("이 앱은 WWDC24 번역 API를 사용하여 번역 기능을 제공합니다.")
                .font(.body)
                .multilineTextAlignment(.center)
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
